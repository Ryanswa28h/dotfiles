/**
 * Dynamic Title Extension
 *
 * Changes the terminal title (and tmux window name when inside tmux)
 * based on agent status:
 *   🟢 pi  — agent is done/idle
 *   🟠 pi  — agent is thinking (model reasoning)
 *   🔴 pi  — agent is outputting (streaming response)
 *   🟡 pi  — agent is stuck/question/waiting
 */

import type {
	ExtensionAPI,
	ExtensionContext,
} from "@mariozechner/pi-coding-agent";

type AgentStatus = "idle" | "thinking" | "outputting" | "waiting";

const STATUS_EMOJI: Record<AgentStatus, string> = {
	idle: "🟢",
	thinking: "🟠",
	outputting: "🔴",
	waiting: "🟡",
};

export default function (pi: ExtensionAPI) {
	let status: AgentStatus = "idle";
	let pendingQuestions = 0;

	/**
	 * Build the title string: {emoji} pi
	 */
	function buildTitle(): string {
		const emoji = STATUS_EMOJI[status];
		return `${emoji} pi`;
	}

	/**
	 * Set the title across all available channels.
	 */
	async function setTitle(ctx: ExtensionContext, title: string): Promise<void> {
		if (!ctx.hasUI) return;

		ctx.ui.setTitle(title);
		process.stderr.write(`\x1b]0;${title}\x07`);

		if (process.env.TMUX) {
			try {
				await pi.exec("tmux", ["set-window-option", "automatic-rename", "off"]);
				await pi.exec("tmux", ["rename-window", title]);
			} catch {
				// tmux session may have ended
			}
		}
	}

	async function restoreTmux(): Promise<void> {
		if (!process.env.TMUX) return;
		try {
			await pi.exec("tmux", ["set-window-option", "automatic-rename", "on"]);
		} catch {
			// tmux session may have ended
		}
	}

	async function doUpdate(ctx: ExtensionContext): Promise<void> {
		if (!ctx.hasUI) return;
		await setTitle(ctx, buildTitle());
	}

	/**
	 * Update only if the status actually changed (avoids redundant tmux renames
	 * during rapid streaming events).
	 */
	async function setStatusAndUpdate(
		ctx: ExtensionContext,
		newStatus: AgentStatus,
	): Promise<void> {
		if (status === newStatus) return;
		status = newStatus;
		await doUpdate(ctx);
	}

	// --- Event handlers ---

	pi.on("session_start", async (_event, ctx) => {
		status = "idle";
		pendingQuestions = 0;
		await doUpdate(ctx);
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		status = "idle";
		pendingQuestions = 0;
		if (ctx.hasUI) ctx.ui.setTitle("pi");
		process.stderr.write("\x1b]0;pi\x07");
		await restoreTmux();
	});

	// The agent has finished — idle
	pi.on("agent_end", async (_event, ctx) => {
		pendingQuestions = 0;
		await setStatusAndUpdate(ctx, "idle");
	});

	// A turn starts — the model typically begins by thinking
	pi.on("turn_start", async (_event, ctx) => {
		await setStatusAndUpdate(ctx, "thinking");
	});

	// Streaming updates — distinguish thinking from outputting
	pi.on("message_update", async (event, ctx) => {
		const eventType = event.assistantMessageEvent?.type;
		if (!eventType) return;

		if (eventType.startsWith("text")) {
			await setStatusAndUpdate(ctx, "outputting");
		} else if (eventType.startsWith("thinking")) {
			await setStatusAndUpdate(ctx, "thinking");
		}
	});

	// Detect when the agent asks the user a question (waiting state)
	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName === "ask_user_question") {
			pendingQuestions++;
			await setStatusAndUpdate(ctx, "waiting");
		}
	});

	// When the user answers, let the next turn_start/agent_end handle state
	pi.on("tool_result", async (event, _ctx) => {
		if (event.toolName === "ask_user_question") {
			pendingQuestions = Math.max(0, pendingQuestions - 1);
		}
	});
}
