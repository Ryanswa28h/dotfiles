---
description: Summarize unstaged git changes with per-file +/- counts and descriptions of what changed
---

Run git status, inspect what has changed, then respond with:

1. A short 2-4 sentence summary of the unstaged changes.
2. For each changed unstaged file: the filename, +/- line counts, and a brief description of what changed (use `git diff` to inspect the actual diff). Describe the nature of the changes.
3. A total +/- line count at the bottom.

Use git commands to inspect diffs and calculate line counts. Do not include staged changes unless they also have unstaged modifications. Group related files together under shared descriptions where it makes sense.
