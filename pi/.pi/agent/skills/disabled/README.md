# Disabled Skills

Skills disabled because their cost (context slot, wrong-activation risk) exceeds their value.

## Categories

| Category | Count | Criteria |
|----------|-------|----------|
| `too-thin/` | 20 | < 4KB SKILL.md — insufficient depth to justify baseline context cost |
| `niche/` | 8 | Narrow domain or technique with low general utility |
| `ecc-ops/` | 2 | ECC-internal operational workflows, not broadly useful |

## Evaluation

See the original rating in session history: A/B/C/D/F framework.
All disabled skills were rated C or below.

Recover any skill by moving it back to `../`:

```bash
mv too-thin/skill-name ..
```
