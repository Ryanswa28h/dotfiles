import type { ExtensionAPI, ExtensionCommandContext } from "@earendil-works/pi-coding-agent";

const READ_ONLY_TOOLS = ["read", "bash", "grep", "find", "ls"];

const DESTRUCTIVE_PATTERNS = [
  /\brm\b/i,
  /\brmdir\b/i,
  /\bmv\b/i,
  /\bcp\b/i,
  /\bmkdir\b/i,
  /\btouch\b/i,
  /\bchmod\b/i,
  /\bchown\b/i,
  /\bchgrp\b/i,
  /\bln\b/i,
  /\btee\b/i,
  /\btruncate\b/i,
  /\bdd\b/i,
  /\bshred\b/i,
  /(^|[^<])>(?!>)/,
  />>/,
  /\bnpm\s+(install|uninstall|update|ci|link|publish)/i,
  /\byarn\s+(add|remove|install|publish)/i,
  /\bpnpm\s+(add|remove|install|publish)/i,
  /\bpip\s+(install|uninstall)/i,
  /\bapt(-get)?\s+(install|remove|purge|update|upgrade)/i,
  /\bbrew\s+(install|uninstall|upgrade)/i,
  /\bdnf\s+(install|remove|update)/i,
  /\bpacman\s+(--remove|-R\b)/i,
  /\bparu\s+(--remove|-R\b)/i,
  /\byay\s+(--remove|-R\b)/i,
  /\bgit\s+(add|commit|push|pull|merge|rebase|reset|checkout\s+(?!-{0,2})|branch\s+-[dD]|stash\s+(save|push|pop|drop|clear)|cherry-pick|revert|tag|init|clone)/i,
  /\bsudo\b/i,
  /\bsu\b/i,
  /\bkill\b/i,
  /\bpkill\b/i,
  /\bkillall\b/i,
  /\breboot\b/i,
  /\bshutdown\b/i,
  /\bsystemctl\s+(start|stop|restart|enable|disable)/i,
  /\bservice\s+\S+\s+(start|stop|restart)/i,
  /\b(vim?|nano|emacs|code|subl|zed)\b/i,
  /\bpasswd\b/i,
  /\bhtpasswd\b/i,
];

const SAFE_PATTERNS = [
  /^\s*cat\b/,
  /^\s*head\b/,
  /^\s*tail\b/,
  /^\s*less\b/,
  /^\s*more\b/,
  /^\s*grep\b/,
  /^\s*rg\b/,
  /^\s*find\b/,
  /^\s*fd\b/,
  /^\s*ls\b/,
  /^\s*eza\b/,
  /^\s*bat\b/,
  /^\s*pwd\b/,
  /^\s*echo\b/,
  /^\s*printf\b/,
  /^\s*wc\b/,
  /^\s*sort\b/,
  /^\s*uniq\b/,
  /^\s*diff\b/,
  /^\s*file\b/,
  /^\s*stat\b/,
  /^\s*du\b/,
  /^\s*df\b/,
  /^\s*tree\b/,
  /^\s*which\b/,
  /^\s*whereis\b/,
  /^\s*type\b/,
  /^\s*env\b/,
  /^\s*printenv\b/,
  /^\s*uname\b/,
  /^\s*whoami\b/,
  /^\s*id\b/,
  /^\s*date\b/,
  /^\s*cal\b/,
  /^\s*uptime\b/,
  /^\s*ps\b/,
  /^\s*top\b/,
  /^\s*htop\b/,
  /^\s*free\b/,
  /^\s*nproc\b/,
  /^\s*arch\b/,
  /^\s*lscpu\b/,
  /^\s*lsblk\b/,
  /^\s*lsusb\b/,
  /^\s*lspci\b/,
  /^\s*git\s+(status|log|diff|show|branch\s+(?!-{0,2}[dD])|remote|config\s+--get|ls-)/i,
  /^\s*npm\s+(list|ls|view|info|search|outdated|audit)/i,
  /^\s*yarn\s+(list|info|why|audit)/i,
  /^\s*node\s+(-[^-].*|--version|--help|--eval|-e)/i,
  /^\s*python3?\s+(-[^-].*|--version|--help|-c)/i,
  /^\s*curl\s/i,
  /^\s*wget\s/i,
  /^\s*jq\b/,
  /^\s*awk\b/,
  /^\s*sed\s+-n/i,
  /^\s*read\b/,
  /^\s*time\b/,
];

function isSafeCommand(command: string) {
  const trimmed = command.trim();
  if (!trimmed) return true;

  const isDestructive = DESTRUCTIVE_PATTERNS.some((pattern) => pattern.test(trimmed));
  const isSafe = SAFE_PATTERNS.some((pattern) => pattern.test(trimmed));

  return !isDestructive && isSafe;
}

export default function readOnlyExtension(pi: ExtensionAPI) {
  let readOnlyEnabled = false;
  let savedTools: string[] = [];

  function enterReadOnly(ctx: ExtensionCommandContext) {
    if (savedTools.length === 0) {
      savedTools = pi.getActiveTools();
    }

    pi.setActiveTools(READ_ONLY_TOOLS);
    readOnlyEnabled = true;
    ctx.ui.setStatus("read-only", ctx.ui.theme.fg("warning", "⏸ read-only"));
  }

  function exitReadOnly(ctx: ExtensionCommandContext) {
    if (savedTools.length > 0) {
      pi.setActiveTools(savedTools);
      savedTools = [];
    } else {
      pi.setActiveTools(pi.getAllTools().map((tool) => tool.name));
    }

    readOnlyEnabled = false;
    ctx.ui.setStatus("read-only", undefined);
  }

  function toggleReadOnly(ctx: ExtensionCommandContext) {
    if (readOnlyEnabled) {
      exitReadOnly(ctx);
      ctx.ui.notify("Read-only mode disabled; full access restored", "info");
      return;
    }

    enterReadOnly(ctx);
    ctx.ui.notify(`Read-only mode enabled; active tools: ${READ_ONLY_TOOLS.join(", ")}`, "info");
  }

  pi.registerCommand("read-only", {
    description: "Toggle read-only mode: safe exploration without file changes",
    handler: async (_args, ctx) => {
      toggleReadOnly(ctx);
    },
  });

  pi.on("before_agent_start", async () => {
    if (!readOnlyEnabled) return;

    return {
      message: {
        customType: "read-only-context",
        content: [
          "[READ-ONLY MODE]",
          "",
          "You are in read-only mode: safe analysis only.",
          `Active tools are restricted to: ${READ_ONLY_TOOLS.join(", ")}.`,
          "Do not make file changes, install packages, commit, push, or run destructive commands.",
          "Use /read-only to disable read-only mode if the user asks you to proceed with changes.",
        ].join("\n"),
        display: false,
      },
    };
  });

  pi.on("tool_call", async (event) => {
    if (!readOnlyEnabled) return;
    if (event.toolName !== "bash") return;

    const command = typeof event.input.command === "string" ? event.input.command : "";
    if (isSafeCommand(command)) return;

    return {
      block: true,
      reason: [
        "Read-only mode blocked this bash command because it is not on the safe allowlist.",
        "Use /read-only to disable read-only mode before making changes.",
        `Blocked command: ${command}`,
      ].join("\n"),
    };
  });
}
