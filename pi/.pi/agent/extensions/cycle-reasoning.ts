/**
 * Reasoning Level Cycler
 *
 * Cycles the agent's reasoning/thinking level through:
 *   none (off) → high → xhigh → none → ...
 *
 * Commands:
 *   /cycle-reasoning
 *
 * Shortcut:
 *   Alt+R
 */

import type {
	ExtensionAPI,
	ExtensionContext,
} from "@mariozechner/pi-coding-agent";

type ThinkingLevel = "off" | "minimal" | "low" | "medium" | "high" | "xhigh";

const CYCLE: ThinkingLevel[] = ["off", "high", "xhigh"];

function nextLevel(current: ThinkingLevel): ThinkingLevel {
	const idx = CYCLE.indexOf(current);
	if (idx === -1 || idx === CYCLE.length - 1) return CYCLE[0];
	return CYCLE[idx + 1];
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("cycle-reasoning", {
		description:
			"Cycle reasoning level: none → high → xhigh → none → ...",
		handler: async (_args, ctx) => {
			if (!ctx.hasUI) return;
			const next = nextLevel(pi.getThinkingLevel() as ThinkingLevel);
			pi.setThinkingLevel(next);
		},
	});

	pi.registerShortcut("alt+r", {
		description: "Cycle reasoning level",
		handler: async (ctx) => {
			if (!ctx.hasUI) return;
			const next = nextLevel(pi.getThinkingLevel() as ThinkingLevel);
			pi.setThinkingLevel(next);
		},
	});
}
