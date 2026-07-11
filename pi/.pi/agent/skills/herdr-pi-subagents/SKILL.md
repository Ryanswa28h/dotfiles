---
name: herdr-pi-subagents
description: Use when user asks to spawn, launch, delegate work to, or coordinate Pi subagents through Herdr tabs.
---

# Herdr Pi Subagents

Master orchestrator owns user communication. Subagent gets isolated task, reports result in named Herdr pane. Apply applicable `orchestrator` policy below to every delegation.

## Orchestration Policy

Before non-trivial work, master must establish: requested outcome, file scope, and relevant code/API patterns. Do not guess. Resolve user-facing ambiguity before spawn; use a scout or researcher for codebase or current-documentation gaps.

| Role       | Use for                                           | Required output                                |
| ---------- | ------------------------------------------------- | ---------------------------------------------- |
| Scout      | Locate code, patterns, tests, blast radius        | Concise file map and evidence; no edits        |
| Researcher | Current external API, library, or migration facts | Sources and actionable findings; no repo edits |
| Worker     | One isolated, fully specified change              | Minimal diff, tests, verification evidence     |
| Reviewer   | Diff, security, regressions, coverage             | Findings with locations; no edits              |

- Give each subagent all needed task context: role, goal, scope, constraints, prior scout/research findings, and required output. Subagents have no master-session context.
  -/reload Parallelize only independent scopes. Serialize overlapping files or shared configuration.
- Keep master context clean: delegate codebase exploration rather than broad direct reads.
- Workers investigate root cause before changes, make only requested changes, and run relevant verification. Master independently checks their claims before reporting completion.

## Model Routing

Use only these exact model IDs. Select model when starting each Pi subagent with `pi --model`.

| Role                        | Default model                     | Use                                                                         |
| --------------------------- | --------------------------------- | --------------------------------------------------------------------------- |
| Scout                       | `opencode/deepseek-v4-flash-free` | File maps, code discovery, simple read-only checks                          |
| Researcher                  | `openai-codex/gpt-5.6-luna`       | Documentation, APIs, migrations, evidence synthesis                         |
| Worker                      | `openai-codex/gpt-5.6-terra`      | Isolated implementation, debugging, tests                                   |
| Reviewer                    | `openai-codex/gpt-5.6-terra`      | Security, regression, and diff review                                       |
| Exceptional worker/reviewer | `openai-codex/gpt-5.6-sol`        | Only hardest/highest-risk cases after Terra is insufficient; cost-sensitive |

Set `ROLE` and map it before launch. Use Sol only when master records why Terra is insufficient. Never automatically escalate to Sol.

**If the user specifies a different model outside of this list, follow the user's instructions. User instructions takes priority over this list.**

## Model Failover

On provider-offline, rate-limit, authentication, or model-start errors, read pane output first. Retry in same named pane with next model below; preserve role, scope, and task.

| Role / selected model   | Retry order                   |
| ----------------------- | ----------------------------- |
| Scout                   | DeepSeek → Luna → Terra       |
| Researcher              | Luna → Terra → DeepSeek       |
| Worker or reviewer      | Terra → Luna → DeepSeek       |
| Explicit Sol escalation | Sol → Terra → Luna → DeepSeek |

Before retrying a worker, inspect prior pane output and worktree. If it executed edits, do not blindly resend task; report partial state to master and resume only from verified state. If every eligible model fails, report blocker with attempted models and exact error.

**If all of these models don't work, stop your response and report to the user.**

To switch, close current Pi process, wait for pane to return to shell, start Pi with replacement `--model`, then resend unchanged `TASK`:

```bash
NEXT_MODEL="<next exact model from retry order>"
herdr pane run "$SUB_PANE" "/quit"
herdr wait agent-status "$SUB_PANE" --status unknown --timeout 30000 \
  || { herdr pane read "$SUB_PANE" --source recent-unwrapped --lines 80; exit 1; }
MODEL="$NEXT_MODEL"
herdr pane run "$SUB_PANE" "pi --model \"$MODEL\" --exclude-tools ask_user_question --append-system-prompt \"You are a scoped subagent working for a master orchestrator in another Herdr pane. Complete only delegated role and task. Do not use ask_user_question. Do not ask user questions by any channel. Do not spawn or delegate to other agents. Work from supplied context, then inspect only assigned scope. Do not guess code or API behavior: report missing evidence or use least-risk reversible assumption. Investigate root cause before changing code; avoid unrelated refactors. Report evidence, changed files, commands run, verification, blockers, and assumptions to master orchestrator.\""
herdr wait output "$SUB_PANE" --match "[Prompts]" --timeout 30000 \
  || { herdr pane read "$SUB_PANE" --source recent --lines 40; exit 1; }
herdr pane send-text "$SUB_PANE" "$TASK"
herdr pane send-keys "$SUB_PANE" Enter
```

## Preconditions

- Need concrete task. If missing detail materially changes work, master asks user before spawn.
- Run only inside Herdr:

```bash
test "$HERDR_ENV" = 1 || { echo "Not inside Herdr"; exit 1; }
```

## Spawn Batch

Create one new tab per subagent batch in master workspace. Never split master tab under 5 agents. Every subagent lives in a named pane inside batch tab; never create one tab per agent.

For three agents: launch first in root pane, split root `right` (vertical divider), then split new right pane `down` (horizontal divider). Result: one left pane plus upper-right and lower-right panes. For fourth agent, split left pane `down` on the tallest pane; for further agents, split largest pane and alternate direction to keep layout as balanced as possible.

When you have to spawn more than five agents, utilize two tabs, not just panes. When you have more than ten agents, use three tabs.

```bash
read -r WORKSPACE MASTER_PANE < <(
  herdr pane list | python3 -c '
import json, sys
for pane in json.load(sys.stdin)["result"]["panes"]:
    if pane["focused"]:
        print(pane["workspace_id"], pane["pane_id"])
        break
else:
    raise SystemExit("No focused master pane")'
)

BATCH_LABEL="subagents-<batch-slug>"
TAB_RESULT=$(herdr tab create --workspace "$WORKSPACE" --label "$BATCH_LABEL" --no-focus)
BATCH_TAB=$(printf '%s' "$TAB_RESULT" | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["tab"]["tab_id"])')
SCOUT_PANE=$(printf '%s' "$TAB_RESULT" | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["root_pane"]["pane_id"])')

launch_subagent() {
  local pane="$1" role="$2" label="$3" model="${4:-}"
  if [[ -z "$model" ]]; then
    case "$role" in
      scout) model="opencode/deepseek-v4-flash-free" ;;
      researcher) model="openai-codex/gpt-5.6-luna" ;;
      worker|reviewer) model="openai-codex/gpt-5.6-terra" ;;
      *) echo "Unknown role: $role"; return 1 ;;
    esac
  fi
  herdr pane rename "$pane" "$label"
  herdr pane run "$pane" "pi --model \"$model\" --exclude-tools ask_user_question --append-system-prompt \"You are a scoped subagent working for a master orchestrator in another Herdr pane. Complete only delegated role and task. Do not use ask_user_question. Do not ask user questions by any channel. Do not spawn or delegate to other agents. Work from supplied context, then inspect only assigned scope. Do not guess code or API behavior: report missing evidence or use least-risk reversible assumption. Investigate root cause before changing code; avoid unrelated refactors. Report evidence, changed files, commands run, verification, blockers, and assumptions to master orchestrator.\""
  herdr wait output "$pane" --match "[Prompts]" --timeout 30000 \
    || { herdr pane read "$pane" --source recent --lines 40; return 1; }
}

launch_subagent "$SCOUT_PANE" scout "subagent-scout-<task-slug>"
RESEARCH_PANE=$(herdr pane split "$SCOUT_PANE" --direction right --no-focus \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
launch_subagent "$RESEARCH_PANE" researcher "subagent-research-<task-slug>"
WORKER_PANE=$(herdr pane split "$RESEARCH_PANE" --direction down --no-focus \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
launch_subagent "$WORKER_PANE" worker "subagent-worker-<task-slug>"
SUBAGENT_PANES=("$SCOUT_PANE" "$RESEARCH_PANE" "$WORKER_PANE")
```

`--no-focus` keeps master focused. Returned IDs are source of truth; never guess IDs. `pane rename` is mandatory before launching Pi.

## Delegate Task

Set `SUB_PANE` to target named pane, then set task. `send-text` passes task to running Pi without shell interpolation.

```bash
SUB_PANE="$SCOUT_PANE" # or RESEARCH_PANE / WORKER_PANE
TASK=$(cat <<'TASK_PROMPT'
Role: <scout | researcher | worker | reviewer>
Model: <exact MODEL value selected above>
Task: <specific goal>
Scope: <files or area>
Evidence provided: <prior findings, API docs, or none>
Constraints: <requirements>
Required output: <file map | sources | minimal diff + tests | findings>

Finish independently. Do not use ask_user_question or request clarification. Do not exceed scope. Report result to master with evidence, changed files, commands run, verification, blockers, and assumptions.
TASK_PROMPT
)
herdr pane send-text "$SUB_PANE" "$TASK"
herdr pane send-keys "$SUB_PANE" Enter
```

## Observe and Integrate

For independent work, keep running panes visible. For result needed now:

```bash
herdr wait agent-status "$SUB_PANE" --status done --timeout 120000
herdr pane read "$SUB_PANE" --source recent-unwrapped --lines 100
```

Master verifies subagent claims. Do not treat report as proof. After reading and verifying every pane result, close entire batch tab; this removes all subagent panes. Never leave completed batch tabs open.

```bash
for pane in "${SUBAGENT_PANES[@]}"; do
  herdr wait agent-status "$pane" --status done --timeout 120000
  herdr pane read "$pane" --source recent-unwrapped --lines 100
done
# Verify reports and worktree first, then clean up all subagents at once.
herdr tab close "$BATCH_TAB"
```

## Constraints

| Rule                          | Enforcement                                            |
| ----------------------------- | ------------------------------------------------------ |
| One batch tab, same workspace | `tab create --workspace "$WORKSPACE"` once per batch   |
| Named panes                   | `pane rename` for every root/split pane before `pi`    |
| Master stays focused          | `--no-focus`                                           |
| No user-question tool         | `--exclude-tools ask_user_question` plus system prompt |
| No unclear task delegation    | Master clarifies or scouts/researches before spawn     |
| Evidence before completion    | Worker verifies; master independently checks report    |

## Failures

- `HERDR_ENV` absent: stop; cannot manage focused pane safely.
- Pi startup wait times out: read pane output; report failure to master. Do not send task blind.
- Subagent blocked: master resolves blocker; subagent never asks user directly.
- Selected model fails, provider is off, or rate limit occurs: use Model Failover; only report blocker after eligible retries fail.
- Batch complete: master reads and verifies all pane results, then runs `herdr tab close "$BATCH_TAB"`.
