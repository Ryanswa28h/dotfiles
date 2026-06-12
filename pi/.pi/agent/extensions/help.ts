import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const HELP_INTRO = `You are answering a question about Pi itself — your own runtime, configuration, capabilities, and ecosystem.

## Your task

First, read the "Before answering" section below carefully. Then answer the user's question thoroughly, citing relevant documentation files you read.

## Before answering

1. **Read pi's documentation files** — they are at \`~/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/\`. The index file is \`index.md\` — start there to find which docs are relevant, then read the specific ones you need.

2. **Read the user's pi configuration** — the agent config is at \`~/.pi/agent/\`. Read these key files if relevant:
   - \`settings.json\` — user's global pi settings
   - \`AGENTS.md\` — any custom agent rules
   - \`auth.json\` — to understand which providers are configured (but do not expose secret values)
   - \`trust.json\` — trusted projects
   - \`extensions/\` — list the installed extensions
   - \`skills/\` — list the installed skills
   - \`themes/\` — any custom themes

3. **Read any relevant skill, extension, or theme files** if the question relates to those areas.

4. **If the question is about a specific topic**, read the specific documentation file(s) for that topic:
   | Topic | Documentation file |
   |-------|-------------------|
   | Getting started / install | \`quickstart.md\` |
   | Daily usage, commands | \`usage.md\` |
   | Providers, API keys, /login | \`providers.md\`, \`custom-provider.md\` |
   | Configuration / settings | \`settings.md\` |
   | Security, trust, sandbox | \`security.md\`, \`containerization.md\` |
   | Sessions, branching, /tree | \`sessions.md\`, \`session-format.md\` |
   | Context compaction | \`compaction.md\` |
   | Extensions (custom tools, events) | \`extensions.md\` |
   | Skills | \`skills.md\` |
   | Prompt templates | \`prompt-templates.md\` |
   | Themes | \`themes.md\` |
   | Pi packages (npm/git distribution) | \`packages.md\` |
   | Custom models | \`models.md\` |
   | Keybindings | \`keybindings.md\` |
   | SDK (embed pi in Node.js) | \`sdk.md\` |
   | RPC mode | \`rpc.md\` |
   | TUI components for extensions | \`tui.md\` |
   | Terminal setup | \`terminal-setup.md\`, \`tmux.md\`, \`shell-aliases.md\` |

## Answering guidelines

- Be concise but complete. Cite specific documentation files and their contents.
- If configuration is mentioned, describe where settings go (global \`~/.pi/agent/settings.json\` vs project-local \`.pi/settings.json\`).
- Suggest best practices where applicable.
- If you read a file but it wasn't relevant, mention that briefly rather than ignoring it.
- If the user's question is unclear or too broad, ask a single clarifying question before answering.

## The user's question`;

export default function (pi: ExtensionAPI) {
  pi.registerCommand("help", {
    description: "Ask a question about Pi itself — configuration, extensions, commands, sessions, and more",
    handler: async (args, ctx) => {
      const question = args?.trim();
      if (!question) {
        ctx.ui.notify(
          "Usage: /help <your question about Pi>\n\n" +
          "Example: /help how do I manage sessions\n\n" +
          "I'll research Pi's documentation and answer your question.",
          "info",
        );
        return;
      }

      const prompt = `${HELP_INTRO}\n\n${question}`;

      if (ctx.isIdle()) {
        pi.sendUserMessage(prompt);
      } else {
        pi.sendUserMessage(prompt, { deliverAs: "followUp" });
        ctx.ui.notify("Queued /help after the current turn finishes.", "info");
      }
    },
  });
}
