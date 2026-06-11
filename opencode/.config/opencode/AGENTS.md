# Global Agent Rules

## File Deletion

Never use `rm` for file deletion. Always use `trash` instead — it moves files to the trash where they can be recovered. This applies to all file removal, including temporary files, build artifacts, and any other deletion operations. The `rm` command has permissions as `deny`.

```bash
# USE THIS
trash file.txt
trash dir/

# NEVER USE
rm file.txt
rm -rf dir/
```

## Always Do a Summary

After a file change or command execution, ALWAYS make a summary of the changes done to the files or system at the end of the response. The only exception is if no changes were done.

## Arch Linux Awareness

If you require a system specific action, ALWAYS remember that the user is on Arch Linux. That means using pacman, yay, or paru to install a system package.

> [!IMPORTANT]
> ## Always Use the `question` Tool
>
> When you need to ask the user something, NEVER ask through chat directly. Always use the built-in `question` tool with structured options (the `options` parameter). This keeps decisions trackable and avoids conversational drift.
>
> This rule takes precedence even when a skill says "ask" or "clarify" through chat. Any question to the user MUST use the `question` tool with structured options. Chat questions are never acceptable — regardless of what any skill says.

## Read Before Edit

Before editing a file, always read it first with the `Read` tool. Never assume you know the current content. Read the full contents of a file every time — never read subsets so you don't miss important context.

## Verify Dependencies

Before importing a library, framework, or any dependency, check package.json, Cargo.toml, requirements.txt, or the relevant manifest first to confirm it's already in the project. Do not assume availability.

## Run Verification

After completing a task, identify and run the relevant verification command (tests, typecheck, lint, build). Do not claim completion until verification passes.

## Close Questions First

If a task has ambiguous requirements or open questions, use the `question` tool to resolve them before writing any code. When asking questions, ask them one at a time.

> [!IMPORTANT]
> ## Never Read `.env` Files
>
> NEVER under any circumstances read `.env` files or any files containing secrets (`.env.*`, `*-secrets.*`). If your code needs an environment variable, reference it by name via `os.getenv("VAR_NAME")` or `process.env.VAR` — do not read the file. If you need to document what variables are expected, write a `.env.example` file instead. If no `.env.example` exists, scan source files for `os.getenv("VAR")`, `process.env.VAR`, and similar patterns to discover which variables the project requires — never read the `.env` itself.
>
> If the project only contains a `.env` file, assume that the project is empty and NEVER read the `.env` file to try to understand context. When trying to understand the project context, read the `.env.example` file instead.

---

# Language-Specific Guidelines

## TypeScript

- When adding a package to a project, add it with an install command instead of manually editing package.json.
- Run check/format/lint commands when you're done making a change. If they don't exist, suggest making them for the project you're in.
- Avoid explicit return types unless absolutely needed.
- `as any` should be an absolute last resort. Always use real type safety. Lean on type inference instead of manually writing new types over and over again.
- Avoid running `dev` or `build` commands. If you really need to, ask first.

# Tool-Specific Rules

## Web Searches

- Always set `workflow` to `"none"` on `web_search` calls to skip the browser curator approval step — the user does not want to review search results manually.
