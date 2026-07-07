---
name: herdr
description: >-
  Terminal workspace manager for AI coding agents. Manages workspaces, tabs, panes, and agent sessions.
  Use when user says "herdr", "create a pane", "split pane", "manage workspace/tab/pane", "launch agent",
  or asks about herdr commands. Supersedes ad-hoc herdr --help calls.
allowed-tools: Bash Read
---

# Herdr CLI Reference

Herdr is a terminal multiplexer focused on AI coding agents. It manages workspaces, tabs, panes, and agent lifecycle.

## Essential Principles

1. **All output is JSON** — Every `herdr` subcommand returns JSON to stdout. Parse with `jq` or pipe to `python3 -m json.tool`. Human-readable output only for top-level `herdr` (status) and `herdr --help`.
2. **IDs not names** — Workspaces, tabs, and panes are identified by IDs like `w5Z`, `w5Z:t3`, `w5Z:pA`. Use `--workspace`, `--tab`, `--pane` flags with IDs, never display names.
3. **Agent targets are flexible** — `herdr agent` commands accept terminal IDs, unique agent names, detected/reported agent labels, and legacy pane IDs as targets.
4. **`pane run` vs `send-text` vs `send-keys`** — `pane run <pane_id> <command>` executes a command (text + Enter). `send-text <pane_id> <text>` types text without Enter. `send-keys <pane_id> <key> [key ...]` sends key events (Enter, Escape, etc.). For launching an interactive program, use `pane run`.
5. **`agent start` vs `pane run`** — `herdr agent start <name> -- <argv...>` creates a new pane and marks it as running the named agent. `pane run` just runs a command in an existing pane without agent lifecycle tracking.
6. **Pi is already integrated** — Pi has a state hook at `~/.pi/agent/extensions/herdr-agent-state.ts` that reports agent status (idle/working/blocked) to herdr over its Unix socket. This is managed by herdr, do not edit.
7. **Config is at `~/.config/herdr/config.toml`** — Keybindings, theme, UI settings. `prefix` defaults to `ctrl+space` in the user's config. Reload with `herdr server reload-config`.
8. **Session JSON at `~/.config/herdr/session.json`** — Full state snapshot including workspace/tab/pane layout and agent sessions.
9. **Always name everything you create** — Every workspace, tab, and pane MUST be given a descriptive label at creation time. Use `--label` on `workspace create`, `tab create`, and `pane rename`. A tab called "Build Output" or "Test Runner" is far more useful than "Tab 3". Never leave generated labels. If you create something without naming it, go back and rename it.

## Data Model

```
Workspace (id: "w5Z", label: "~")
  └── Tab (id: "w5Z:t3", label: "Util", number: 3)
       └── Pane (id: "w5Z:pA", cwd: "/home/ryan")
            └── Agent (label: "pi", status: "working")
```

- **Workspace**: A named collection of tabs. Has an `id` and optional `custom_name`. Created with a cwd (identity_cwd).
- **Tab**: A tab within a workspace. Contains one root pane which can be split into multiple panes. Has an `id` (workspace_id + ":t" + number), `custom_name`, and `number`.
- **Pane**: A terminal pane within a tab. Has an `id` (workspace_id + ":p" + letter/number), `cwd`, `foreground_cwd`, and optionally an `agent_session`.
- **Agent**: A running AI agent in a pane. Has a `label` (e.g. "pi", "claude"), `status` (working/idle/blocked/unknown), and optional `agent_session` with session file path.

### ID Patterns

- Workspace: `w5Z` (3-char base62)
- Tab: `w5Z:t3` (workspace + ":t" + number)
- Pane: `w5Z:pA` (workspace + ":p" + letter) — legacy: `w5Z:p1` (number)

### JSON Response Format

All subcommands return:

```json
{"id": "cli:<subcommand>:<action>", "result": { ... }}
```

Error responses:

```json
{ "code": "error_code", "message": "human-readable message" }
```

### Naming Convention

Always assign descriptive labels immediately after creation. Track IDs by storing them in variables, not by re-parsing output.

```bash
# BAD — no label, can't find it later
herdr tab create
herdr pane split w5Z:pN --direction right

# GOOD — labeled and IDs captured
NEW_TAB=$(herdr tab create --label "Build Monitor" --cwd /home/ryan --focus)
TAB_ID=$(echo "$NEW_TAB" | jq -r '.result.tab.tab_id')
LEFT_PANE=$(echo "$NEW_TAB" | jq -r '.result.root_pane.pane_id')

# Rename existing things that weren't named
herdr tab rename "$TAB_ID" "Build Monitor"
herdr pane rename "$LEFT_PANE" "Logs"

# Split and name the new pane too
SPLIT=$(herdr pane split "$LEFT_PANE" --direction right --ratio 0.5)
RIGHT_PANE=$(echo "$SPLIT" | jq -r '.result.pane.pane_id')
herdr pane rename "$RIGHT_PANE" "Tests"

# Workspaces also get named
herdr workspace create --label "ProjectX" --cwd /home/ryan/projects/x
```

**Naming conventions by context:**

- **Workspaces** → project name or purpose: `"Docs Overhaul"`, `"Bug Bash"`, `"ProjectX"`
- **Tabs** → task or tool: `"Build"`, `"Tests"`, `"Logs"`, `"Agent"`, `"Neovim"`, `"Git"`
- **Panes** → specific role: `"Main"`, `"Preview"`, `"Server"`, `"Linter"`, `"Output"`

## Command Reference

### Workspace Management

```bash
# List all workspaces
herdr workspace list

# Create new workspace
herdr workspace create [--cwd PATH] [--label TEXT] [--env KEY=VALUE] [--focus] [--no-focus]

# Get workspace info
herdr workspace get <workspace_id>

# Focus workspace
herdr workspace focus <workspace_id>

# Rename workspace
herdr workspace rename <workspace_id> <label>

# Close workspace
herdr workspace close <workspace_id>
```

Output shape:

```json
{
  "workspaces": [
    {
      "workspace_id": "w5Z",
      "label": "~",
      "number": 1,
      "tab_count": 5,
      "pane_count": 5,
      "focused": true,
      "active_tab_id": "w5Z:t3",
      "agent_status": "working"
    }
  ]
}
```

### Tab Management

```bash
# List tabs in workspace
herdr tab list [--workspace <workspace_id>]

# Create new tab
herdr tab create [--workspace <workspace_id>] [--cwd PATH] [--label TEXT] [--env KEY=VALUE] [--focus] [--no-focus]

# Get tab info
herdr tab get <tab_id>

# Focus tab
herdr tab focus <tab_id>

# Rename tab
herdr tab rename <tab_id> <label>

# Close tab
herdr tab close <tab_id>
```

Creating a tab returns the root pane and tab:

```json
{
  "tab": {
    "tab_id": "w5Z:t6",
    "label": "Pi Test",
    "number": 6,
    "pane_count": 1,
    "focused": false,
    "workspace_id": "w5Z"
  },
  "root_pane": {
    "pane_id": "w5Z:pN",
    "cwd": "/home/ryan",
    "focused": false
  }
}
```

### Pane Management

```bash
# List panes
herdr pane list [--workspace <workspace_id>]

# Get current pane (from env context)
herdr pane current [--pane ID|--current]

# Get pane details
herdr pane get <pane_id>

# Get pane layout tree (splits, rectangles, focus)
herdr pane layout [--pane ID|--current]

# Focus adjacent pane
herdr pane focus --direction left|right|up|down [--pane ID|--current]

# Split pane
herdr pane split [<pane_id>|--pane ID|--current] --direction right|down [--ratio FLOAT] [--cwd PATH] [--env KEY=VALUE] [--focus] [--no-focus]

# Zoom pane toggle
herdr pane zoom [<pane_id>|--pane ID|--current] [--toggle|--on|--off]

# Rename pane
herdr pane rename <pane_id> <label>|--clear

# Read pane content
herdr pane read <pane_id> [--source visible|recent|recent-unwrapped] [--lines N] [--format text|ansi] [--ansi]

# Close pane
herdr pane close <pane_id>

# Send text to pane (no Enter)
herdr pane send-text <pane_id> <text>

# Send key events to pane
herdr pane send-keys <pane_id> <key> [key ...]

# Run command in pane (text + Enter)
herdr pane run <pane_id> <command>

# Move pane to another tab
herdr pane move <pane_id> --tab <tab_id> --split right|down [--target-pane ID] [--ratio FLOAT] [--focus|--no-focus]

# Move pane to new tab
herdr pane move <pane_id> --new-tab [--workspace ID] [--label TEXT] [--focus|--no-focus]

# Move pane to new workspace
herdr pane move <pane_id> --new-workspace [--label TEXT] [--tab-label TEXT] [--focus|--no-focus]

# Swap panes
herdr pane swap --direction left|right|up|down [--pane ID|--current]
herdr pane swap --source-pane ID --target-pane ID

# Resize pane
herdr pane resize --direction left|right|up|down [--amount FLOAT] [--pane ID|--current]

# Get neighbor pane
herdr pane neighbor --direction left|right|up|down [--pane ID|--current]

# Get pane edges (bounding box)
herdr pane edges [--pane ID|--current]

# Get process info in pane
herdr pane process-info [--pane ID|--current]
```

### Agent Management

```bash
# List all agents
herdr agent list

# Get agent info
herdr agent get <target>

# Read agent pane content
herdr agent read <target> [--source visible|recent|recent-unwrapped] [--lines N] [--format text|ansi] [--ansi]

# Send text to agent pane (literal text, no Enter)
herdr agent send <target> <text>

# Rename agent
herdr agent rename <target> <name>|--clear

# Focus agent pane
herdr agent focus <target>

# Wait for agent status
herdr agent wait <target> --status <idle|working|blocked|unknown> [--timeout MS]

# Attach to agent pane (take over)
herdr agent attach <target> [--takeover]

# Start a new agent in a new pane
herdr agent start <name> [--cwd PATH] [--workspace ID] [--tab ID] [--split right|down] [--env KEY=VALUE] [--focus|--no-focus] -- <argv...>

# Explain why an agent was detected (debug)
herdr agent explain <target> [--json|--verbose]
herdr agent explain --file PATH --agent LABEL [--json|--verbose]
```

### Agent Lifecycle (from pi's state hook)

Pi reports its state to herdr via the Unix socket at `$HERDR_SOCKET_PATH`. The extension at `~/.pi/agent/extensions/herdr-agent-state.ts` handles:

- **idle** → published after `idleDebounceMs` (250ms default) of no agent activity
- **working** → published on `agent_start` event
- **blocked** → published when a tool result requires user input (`ask_user_question` tool)
- **retry hold** → during provider error retries (holds "working" for `retryGraceMs` = 2500ms before showing "blocked")

The `herdr:blocked` event is emitted by pi for `ask_user_question` tools. Herdr shows the blocked pane in the sidebar.

### Waiting & Synchronization

```bash
# Wait for pane content to match
herdr wait output <pane_id> --match <text> [--source visible|recent|recent-unwrapped] [--lines N] [--timeout MS] [--regex] [--raw]

# Wait for agent status
herdr wait agent-status <pane_id> --status <idle|working|blocked|done|unknown> [--timeout MS]
```

### Notifications

```bash
# Show a toast notification
herdr notification show <title> [--body TEXT] [--position top-left|top-right|bottom-left|bottom-right] [--sound none|done|request]
```

### Worktrees (Git)

```bash
# List worktrees
herdr worktree list [--workspace ID | --cwd PATH] [--json]

# Create worktree (new branch from base)
herdr worktree create [--workspace ID | --cwd PATH] [--branch NAME] [--base REF] [--path PATH] [--label TEXT] [--focus] [--no-focus] [--json]

# Open existing worktree
herdr worktree open [--workspace ID | --cwd PATH] (--path PATH | --branch NAME) [--label TEXT] [--focus] [--no-focus] [--json]

# Remove worktree
herdr worktree remove --workspace ID [--force] [--json]
```

### Session Management

```bash
# List named sessions
herdr session list [--json]

# Attach to session
herdr session attach <name>

# Stop session
herdr session stop <name> [--json]

# Delete session
herdr session delete <name> [--json]
```

### Server & Config

```bash
# Check status
herdr status [server|client]

# Update herdr
herdr update [--handoff]

# Switch channel
herdr channel set <stable|preview>

# Stop server
herdr server stop

# Reload config
herdr server reload-config

# Reset custom keybindings
herdr config reset-keys

# Integration management
herdr integration status [--outdated-only]
herdr integration install pi
herdr integration install claude
herdr integration install opencode
# ... (see herdr integration --help for full list)
herdr integration uninstall pi
```

### Plugin Info

Plugins are installed via the config and stored in `~/.config/herdr/plugins/`. Each has a manifest at `plugin_root/herdr-plugin.toml` with:

- `plugin_id`, `name`, `version`
- `events` — triggers (e.g. `pane.focused`, `tab.focused`, `workspace.focused`)
- `actions` — context menu entries
- `source` — install origin (github, local)

Install a plugin: add to config.toml and set `enabled = true`.

To see installed plugins, check `~/.config/herdr/plugins.json`.

## Common Workflows

### Create a Tab with Two Panes

```bash
# 1. Create tab
NEW_TAB=$(herdr tab create --label "My Tab" --cwd /home/ryan --focus)
LEFT_PANE=$(echo "$NEW_TAB" | jq -r '.result.root_pane.pane_id')

# 2. Split right
SPLIT_RESULT=$(herdr pane split "$LEFT_PANE" --direction right --ratio 0.5)
RIGHT_PANE=$(echo "$SPLIT_RESULT" | jq -r '.result.pane.pane_id')

# 3. Run commands in each
herdr pane run "$LEFT_PANE" 'pi "what is pi"'
herdr pane run "$RIGHT_PANE" 'pi "what is a coding agent"'
```

### Launch Pi in a New Pane (Managed)

```bash
herdr agent start pi --cwd /home/ryan \
  --workspace w5Z --split right --focus -- \
  pi "my prompt"
```

### Check Current Context

```bash
# Get what tab/pane we're in
herdr tab list

# Get current pane
herdr pane current

# Get layout
herdr pane layout
```

## Reading Results from Panes

There are three main strategies for getting output back from panes you've created.

### Strategy 1: Read Pane Content (After Command Runs)

Use `herdr pane read` when the command has already finished or you want to check progress.

```bash
# Read visible content (what you'd see on screen)
herdr pane read "$PANE_ID" --source visible --lines 50

# Read recent scrollback
herdr pane read "$PANE_ID" --source recent --lines 100

# Read recent scrollback, unwrapped (no line-wrap artifacts)
herdr pane read "$PANE_ID" --source recent-unwrapped --lines 100

# Get ANSI content (preserves colors, useful for parsing)
herdr pane read "$PANE_ID" --source recent --lines 50 --format ansi
```

**When to use which source:**

- `visible` — what's currently on screen. Fast, small. Use for status checks.
- `recent` — scrollback buffer. Use when output scrolled off screen.
- `recent-unwrapped` — same as recent but line-wrap removed. Best for parsing command output programmatically.

### Strategy 2: Wait for Specific Output, Then Read

Use `herdr wait output` to block until content appears, then read.

```bash
# Block until "Done!" appears in pane, then grab full output
herdr wait output "$PANE_ID" --match "Done!" --timeout 60000 --source recent
herdr pane read "$PANE_ID" --source recent-unwrapped --lines 200

# Wait with regex pattern
herdr wait output "$PANE_ID" --match "error|fail|traceback" --timeout 30000 --regex --source recent

# Wait for agent to finish, then read
herdr wait agent-status "$PANE_ID" --status idle --timeout 120000
herdr pane read "$PANE_ID" --source recent-unwrapped --lines 200
```

### Strategy 3: Wait for Agent Status

Use `herdr wait agent-status` when running an integrated agent (pi, claude, etc.):

```bash
# Wait until the agent completes
herdr wait agent-status "$PANE_ID" --status idle --timeout 120000

# Wait until agent blocks waiting for user input
herdr wait agent-status "$PANE_ID" --status blocked --timeout 60000

# After agent finishes, read the output
herdr pane read "$PANE_ID" --source recent-unwrapped --lines 500
```

### Complete Pattern: Create, Run, Wait, Read

```bash
# 1. Create tab with descriptive name
TAB_OUTPUT=$(herdr tab create --label "Build Check" --cwd /home/ryan/project --focus)
TAB_ID=$(echo "$TAB_OUTPUT" | jq -r '.result.tab.tab_id')
PANE_ID=$(echo "$TAB_OUTPUT" | jq -r '.result.root_pane.pane_id')
herdr pane rename "$PANE_ID" "Build"

# 2. Run a command
herdr pane run "$PANE_ID" 'npm run build 2>&1'

# 3. Wait for it to finish
herdr wait output "$PANE_ID" --match "finished|error|Failed" --timeout 120000 --regex

# 4. Read results
OUTPUT=$(herdr pane read "$PANE_ID" --source recent-unwrapped --lines 200)
echo "$OUTPUT"

# 5. Report back with a summary
```

### Sharing Results with the User

When you read output from a pane, summarize what you found rather than dumping raw text:

```
Build finished in tab "Build Check" (pane "Build"):
- Exit: success
- Tests: 42 passed, 0 failed
- Warnings: 3 (module resolution)
```

### Focus and Navigation

```bash
# Focus neighbor pane
herdr pane focus --direction right
herdr pane focus --direction left

# Focus a specific tab
herdr tab focus w5Z:t3

# Focus a specific pane
herdr agent focus pi

# Rename for clarity
herdr tab rename w5Z:t3 "Build Output"
herdr pane rename w5Z:pA "Main Agent"
```

### Sending Text vs Keys vs Run

```bash
# Type text (no enter) — for answering interactive prompts
herdr pane send-text w5Z:pA "my answer here"

# Press keys — for control sequences
herdr pane send-keys w5Z:pA Enter
herdr pane send-keys w5Z:pA Escape
herdr pane send-keys w5Z:pA Ctrl+c

# Run command (text + Enter)
herdr pane run w5Z:pA 'echo "hello"'
```

## Integration Points

Pi's herdr integration is at `~/.pi/agent/extensions/herdr-agent-state.ts` (managed by herdr, do not edit).

The integration uses two environment variables set by herdr:

- `HERDR_ENV=1` — signals we're inside herdr
- `HERDR_SOCKET_PATH` — path to herdr's Unix socket for JSON-RPC messages
- `HERDR_PANE_ID` — the pane ID pi is running in

Messages sent to the socket use JSON-RPC format:

- `pane.report_agent` — update agent state (idle/working/blocked)
- `pane.report_agent_session` — report session file path for resume support
- `pane.release_agent` — release agent on session shutdown

## Config File Keybindings

Current user config at `~/.config/herdr/config.toml`:

- Prefix: `ctrl+space`
- New tab: `prefix+c`, Next/prev tab: `prefix+n` / `prefix+p`
- Split horizontal: `prefix+minus`, Split vertical: `prefix+backslash`
- Pane focus: `prefix+h/j/k/l` (vim-style)
- Detach: `prefix+q`
- Workspace picker: `prefix+w`
- Goto: `prefix+g`
- Worktrees: `prefix+m` (new), `prefix+shift+m` (open)
- Lazygit: `prefix+G` (temporary pane)
- Floating shell: `prefix+t` (temporary pane)

## Environment Variables

| Variable                    | Purpose                                              |
| --------------------------- | ---------------------------------------------------- |
| `HERDR_CONFIG_PATH`         | Override config file path                            |
| `HERDR_SOCKET_PATH`         | Unix socket for agent state reporting                |
| `HERDR_PANE_ID`             | Current pane ID (set by herdr for integrated agents) |
| `HERDR_ENV`                 | Set to `1` when running inside herdr                 |
| `HERDR_PI_IDLE_DEBOUNCE_MS` | Override idle debounce (default: 250)                |
| `HERDR_PI_RETRY_GRACE_MS`   | Override retry grace (default: 2500)                 |
