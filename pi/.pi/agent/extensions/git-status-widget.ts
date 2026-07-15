import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);
const WIDGET_ID = "git-status-widget";
const UPDATE_INTERVAL_MS = 2_000;

async function runGit(args: string[], cwd: string) {
  const { stdout } = await execFileAsync("git", args, {
    cwd,
    timeout: 2_000,
    maxBuffer: 1024 * 1024,
  });
  return stdout.trimEnd();
}

async function getBranch(cwd: string) {
  const branch = await runGit(["branch", "--show-current"], cwd);
  if (branch.length > 0) return branch;

  const head = await runGit(["rev-parse", "--short", "HEAD"], cwd);
  return head.length > 0 ? `detached@${head}` : "unknown";
}

function countUnstagedFiles(statusOutput: string) {
  if (statusOutput.length === 0) return 0;

  let count = 0;
  for (const line of statusOutput.split("\n")) {
    if (line.startsWith("??") || line[1] !== " ") count += 1;
  }
  return count;
}

async function getUnstagedCount(cwd: string) {
  const status = await runGit(
    ["status", "--porcelain", "--untracked-files=normal"],
    cwd,
  );
  return countUnstagedFiles(status);
}

interface Lifecycle {
  active: boolean;
}

function formatStatus(
  branch: string,
  unstagedCount: number,
  theme: {
    fg: (color: string, text: string) => string;
  },
) {
  const branchPart = theme.fg("success", ` ${branch}`);
  const sep = theme.fg("muted", " · ");

  let countPart: string;
  const fileLabel = unstagedCount === 1 ? "file" : "files";
  if (unstagedCount > 0) {
    countPart = theme.fg("accent", `${unstagedCount} unstaged ${fileLabel}`);
  } else {
    countPart = theme.fg("dim", "clean");
  }

  return `${branchPart}${sep}${countPart}`;
}

async function updateWidget(ctx: ExtensionContext, lifecycle: Lifecycle) {
  if (!lifecycle.active || !ctx.hasUI) return;
  const cwd = ctx.cwd;

  try {
    await runGit(["rev-parse", "--is-inside-work-tree"], cwd);
    const [branch, unstagedCount] = await Promise.all([
      getBranch(cwd),
      getUnstagedCount(cwd),
    ]);

    if (!lifecycle.active) return;
    ctx.ui.setWidget(WIDGET_ID, (_tui, theme) => {
      const line = formatStatus(branch, unstagedCount, theme);
      return new Text(line, 1, 0);
    });
  } catch {
    if (lifecycle.active) ctx.ui.setWidget(WIDGET_ID, undefined);
  }
}

export default function (pi: ExtensionAPI) {
  let interval: NodeJS.Timeout | undefined;
  let lifecycle: Lifecycle = { active: false };

  pi.on("session_start", async (_event, ctx) => {
    if (interval) clearInterval(interval);

    const nextLifecycle = { active: true };
    lifecycle = nextLifecycle;
    await updateWidget(ctx, nextLifecycle);
    if (!nextLifecycle.active || lifecycle !== nextLifecycle) return;

    interval = setInterval(() => {
      void updateWidget(ctx, nextLifecycle);
    }, UPDATE_INTERVAL_MS);
  });

  pi.on("input", async (_event, ctx) => {
    await updateWidget(ctx, lifecycle);
    return { action: "continue" };
  });

  pi.on("tool_execution_end", async (_event, ctx) => {
    await updateWidget(ctx, lifecycle);
  });

  pi.on("session_shutdown", async (_event, ctx) => {
    lifecycle.active = false;
    if (interval) {
      clearInterval(interval);
      interval = undefined;
    }
    if (ctx.hasUI) ctx.ui.setWidget(WIDGET_ID, undefined);
  });
}
