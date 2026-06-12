/**
 * Plan Mode Extension
 *
 * Three commands for structured planning:
 *   /read-only       — Toggle read-only mode (safe code exploration)
 *   /plan <prompt>   — Enter plan mode, explore, and generate a plan
 *   /plan-execute    — Execute the last plan created by /plan
 *
 * Also provides:
 *   Ctrl+Alt+P    — Toggle read-only mode
 *   --read-only   — Start pi in read-only mode
 */

import type { ExtensionAPI, ExtensionCommandContext } from "@mariozechner/pi-coding-agent";
import { Key } from "@mariozechner/pi-tui";

// ── Tool lists ───────────────────────────────────────────────────────

const READ_ONLY_TOOLS = ["read", "bash", "grep", "find", "ls"];

// ── Bash command safety ───────────────────────────────────────────────

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

function isSafeCommand(command: string): boolean {
	const trimmed = command.trim();
	if (!trimmed) return true;

	const isDestructive = DESTRUCTIVE_PATTERNS.some((p) => p.test(trimmed));
	const isSafe = SAFE_PATTERNS.some((p) => p.test(trimmed));

	return !isDestructive && isSafe;
}

// ── Extension entry point ─────────────────────────────────────────────

export default function planModeExtension(pi: ExtensionAPI): void {
	let readOnlyEnabled = false;
	let planModeActive = false;
	let currentPlan = "";
	let savedTools: string[] = [];

	// ── Helpers ─────────────────────────────────────────────────────

	function enterReadOnly(ctx: ExtensionCommandContext): void {
		if (savedTools.length === 0) {
			savedTools = pi.getActiveTools();
		}
		pi.setActiveTools(READ_ONLY_TOOLS);
		readOnlyEnabled = true;
		ctx.ui.setStatus("plan-mode", ctx.ui.theme.fg("warning", "⏸ read-only"));
	}

	function exitReadOnly(ctx: ExtensionCommandContext): void {
		if (savedTools.length > 0) {
			pi.setActiveTools(savedTools);
			savedTools = [];
		} else {
			pi.setActiveTools(pi.getAllTools().map((t) => t.name));
		}
		readOnlyEnabled = false;
		planModeActive = false;
		ctx.ui.setStatus("plan-mode", undefined);
	}

	function toggleReadOnly(ctx: ExtensionCommandContext): void {
		if (readOnlyEnabled) {
			exitReadOnly(ctx);
			ctx.ui.notify("▶ Read-only mode disabled — full access restored", "info");
		} else {
			planModeActive = false;
			enterReadOnly(ctx);
			ctx.ui.notify(
				`⏸ Read-only mode enabled — only: ${READ_ONLY_TOOLS.join(", ")}`,
				"info",
			);
		}
	}

	// ── CLI flag ───────────────────────────────────────────────────

	pi.registerFlag("read-only", {
		description: "Start in read-only mode (safe exploration, no modifications)",
		type: "boolean",
		default: false,
	});

	// ── Commands ───────────────────────────────────────────────────

	// /read-only — toggle read-only mode (formerly /plan)
	pi.registerCommand("read-only", {
		description: "Toggle read-only mode (safe exploration, no modifications)",
		handler: async (_args, ctx) => {
			toggleReadOnly(ctx);
		},
	});

	// /plan <prompt> — create a structured plan
	pi.registerCommand("plan", {
		description:
			"Create a plan. Usage: /plan <description of task to plan>. " +
			"Explores the codebase in read-only mode, then produces a structured plan. " +
			"Run /plan-execute afterward to carry it out.",
		handler: async (args, ctx) => {
			if (!args || !args.trim()) {
				ctx.ui.notify("Usage: /plan <description of task to plan>", "error");
				return;
			}

			// Enter read-only mode for safe exploration
			currentPlan = "";
			planModeActive = true;
			enterReadOnly(ctx);
			ctx.ui.notify("📋 Plan mode — exploring and creating a plan...", "info");

			// Queue a user message to generate the plan
			pi.sendUserMessage(
				`[PLAN REQUEST]\n\n` +
				`Create a detailed, step-by-step plan for the following task:\n\n` +
				`${args.trim()}\n\n` +
				`Explore the codebase first using read tools. Then produce a structured plan with:\n` +
				`- Clear steps in order\n` +
				`- Files to create or modify\n` +
				`- What each change entails\n` +
				`- Dependencies between steps\n` +
				`- Any risks or considerations`,
				{ triggerTurn: true },
			);
		},
	});

	// /plan-execute — execute the stored plan
	pi.registerCommand("plan-execute", {
		description: "Execute the current plan made by /plan",
		handler: async (_args, ctx) => {
			if (!currentPlan) {
				ctx.ui.notify(
					"No plan found. Use /plan <prompt> first to create a plan.",
					"error",
				);
				return;
			}

			const plan = currentPlan;
			planModeActive = false;
			currentPlan = "";

			// Exit read-only mode — full tools for execution
			exitReadOnly(ctx);
			ctx.ui.notify("▶ Executing plan — full tools restored", "info");

			// Queue a user message to execute the plan
			pi.sendUserMessage(
				`[EXECUTE PLAN]\n\n` +
				`Execute the following plan step by step:\n\n` +
				`${plan}\n\n` +
				`Work through each step carefully. Report progress and any issues encountered. ` +
				`When all steps are done, confirm completion.`,
				{ triggerTurn: true },
			);
		},
	});

	// ── Shortcut ───────────────────────────────────────────────────

	pi.registerShortcut(Key.ctrlAlt("p"), {
		description: "Toggle read-only mode",
		handler: async (ctx) => {
			toggleReadOnly(ctx);
		},
	});

	// ── Capture plan from assistant response ───────────────────────

	pi.on("message_end", async (event) => {
		if (!planModeActive) return;
		if (event.message.role !== "assistant") return;

		const content = event.message.content;
		if (typeof content !== "string" || !content.trim()) return;

		// Store the plan. In plan mode the LLM may make multiple
		// assistant responses (e.g. exploring with tools first).
		// The final response is what's kept.
		currentPlan = content.trim();
	});

	// ── Inject context for read-only / plan modes ─────────────────

	pi.on("before_agent_start", async (_event) => {
		if (!readOnlyEnabled) return;

		let message: string;
		if (planModeActive) {
			message =
				`[PLAN MODE]\n\n` +
				`You are in plan mode — explore the codebase and create a detailed plan.\n\n` +
				`Restricted to: ${READ_ONLY_TOOLS.join(", ")}.\n` +
				`Do NOT make any changes. Read, analyze, and produce a structured plan.\n\n` +
				`Use web_search and fetch_content for external research.\n` +
				`Ask clarifying questions with ask_user_question.`;
		} else {
			message =
				`[READ-ONLY MODE]\n\n` +
				`You are in read-only mode — safe code analysis only.\n\n` +
				`Restricted to: ${READ_ONLY_TOOLS.join(", ")}.\n` +
				`Do NOT make any changes. Explore and describe what needs to be done.\n\n` +
				`Use web_search and fetch_content for external research.\n` +
				`Ask clarifying questions with ask_user_question.`;
		}

		return {
			message: {
				customType: "plan-mode-context",
				content: message,
				display: false,
			},
		};
	});

	// ── Block destructive bash in read-only mode ──────────────────

	pi.on("tool_call", async (event) => {
		if (!readOnlyEnabled) return;
		if (event.toolName !== "bash") return;

		const command = event.input.command as string;
		if (!isSafeCommand(command)) {
			return {
				block: true,
				reason:
					`⏸ Read-only mode: this bash command is not on the safe allowlist.\n` +
					`Use /read-only to disable read-only mode, or /plan-execute to execute a plan.\n` +
					`Blocked command: ${command}`,
			};
		}
	});

	// ── Start in read-only mode via --read-only flag ──────────────

	pi.on("session_start", async (_event, ctx) => {
		if (pi.getFlag("read-only") === true) {
			enterReadOnly(ctx);
		}
	});
}
