import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

type ClipboardCommand = {
  command: string;
  args: string[];
};

const CLIPBOARD_COMMANDS: ClipboardCommand[] = [
  { command: "wl-copy", args: [] },
  { command: "xclip", args: ["-selection", "clipboard"] },
  { command: "xsel", args: ["--clipboard", "--input"] },
  { command: "pbcopy", args: [] },
];

const CLIPBOARD_SETTLE_MS = 250;

function textFromContent(content: unknown) {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";

  return content
    .map((block) => {
      if (!block || typeof block !== "object") return "";
      if (!("type" in block)) return "";

      if (block.type === "text" && "text" in block && typeof block.text === "string") {
        return block.text;
      }

      if (block.type === "image") return "[image]";
      return "";
    })
    .filter(Boolean)
    .join("\n");
}

function isMissingCommand(error: unknown) {
  return typeof error === "object" && error !== null && "code" in error && error.code === "ENOENT";
}

function runClipboardCommand(spec: ClipboardCommand, text: string) {
  return new Promise<void>((resolve, reject) => {
    const child = spawn(spec.command, spec.args, {
      detached: true,
      stdio: ["pipe", "ignore", "ignore"],
    });
    let settled = false;
    let settleTimer: NodeJS.Timeout | undefined;

    const finish = (error?: Error) => {
      if (settled) return;
      settled = true;
      if (settleTimer) clearTimeout(settleTimer);
      if (!error) child.unref();
      if (error) reject(error);
      else resolve();
    };

    child.on("error", (error) => finish(error));
    child.on("close", (code) => {
      if (settled) return;
      if (code === 0) finish();
      else finish(new Error(`${spec.command} exited with code ${code}`));
    });

    child.stdin?.on("error", (error) => finish(error));
    child.stdin?.on("finish", () => {
      settleTimer = setTimeout(() => finish(), CLIPBOARD_SETTLE_MS);
      settleTimer.unref?.();
    });
    child.stdin?.end(text);
  });
}

async function copyToClipboard(text: string) {
  const failures: string[] = [];

  for (const spec of CLIPBOARD_COMMANDS) {
    try {
      await runClipboardCommand(spec, text);
      return spec.command;
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      failures.push(`${spec.command}: ${isMissingCommand(error) ? "not found" : message}`);
    }
  }

  throw new Error(
    [
      "No clipboard command worked.",
      "On Arch Linux install one with: sudo pacman -S wl-clipboard xclip xsel",
      ...failures.map((failure) => `- ${failure}`),
    ].join("\n"),
  );
}

function isSelfInvocation(text: string) {
  return /^\s*\/cprompt(?:\s|$)/.test(text);
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("cprompt", {
    description: "Copy the last user prompt to the clipboard",
    handler: async (_args, ctx) => {
      const entries = ctx.sessionManager.getBranch();
      let promptText = "";

      for (let index = entries.length - 1; index >= 0; index -= 1) {
        const entry = entries[index];
        if (entry.type !== "message") continue;
        if (entry.message.role !== "user") continue;

        const text = textFromContent(entry.message.content).trim();
        if (!text || isSelfInvocation(text)) continue;

        promptText = text;
        break;
      }

      if (!promptText) {
        ctx.ui.notify("No user prompt found on the active branch", "warning");
        return;
      }

      try {
        const command = await copyToClipboard(promptText);
        ctx.ui.notify(`Copied last prompt to clipboard with ${command}`, "info");
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(`Clipboard error: ${message}`, "error");
      }
    },
  });
}
