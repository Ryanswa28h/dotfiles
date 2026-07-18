---
name: skill-improver
description: "Iteratively reviews and fixes skill quality issues until they meet standards. Runs automated fix-review cycles. Use to fix skill quality issues, improve skill descriptions, run automated skill review loops, or iteratively refine a skill. Triggers on 'fix my skill', 'improve skill quality', 'skill improvement loop'."
allowed-tools: Read Edit Write Glob Grep
---

# Skill Improvement Methodology

Iteratively improve a skill until it meets quality standards.

**Also see:** [writing-skills](../writing-skills/SKILL.md) for the TDD-based skill creation process and quality checklist. This skill focuses on the iterative fix-review loop; writing-skills covers the RED-GREEN-REFACTOR cycle for creating new skills.

## Prerequisites

Requires a skill quality reviewer (e.g., an agent or tool that can analyze SKILL.md files against quality standards). Verify your reviewer is available before starting.

## Core Loop

1. **Review** - Run a quality review on the target skill directory
2. **Categorize** - Parse issues by severity (critical, major, minor)
3. **Fix** - Address critical and major issues
4. **Evaluate** - Check minor issues for validity before fixing
5. **Repeat** - Continue until quality bar is met

## When to Use

- Improving a skill with multiple quality issues
- Iterating on a new skill until it meets standards
- Automated fix-review cycles instead of manual editing
- Consistent quality enforcement across skills

## When NOT to Use

- **One-time review**: Use your platform's review tool directly instead
- **Quick single fixes**: Edit the file directly
- **Non-skill files**: Only works on SKILL.md files
- **Experimental skills**: Manual iteration gives more control during exploration

## Issue Categorization

### Critical Issues (MUST fix immediately)

These block skill loading or cause runtime failures:

- Missing required frontmatter fields (name, description) — skill cannot be indexed or triggered
- Invalid YAML frontmatter syntax — Parsing fails, skill won't load
- Referenced files that don't exist — Runtime errors when Pi follows links
- Broken file paths — Same as above, leads to tool failures

### Major Issues (MUST fix)

These significantly degrade skill effectiveness:

- Weak or vague trigger descriptions — agent may not recognize when to use the skill
- Wrong writing voice (second person "you" instead of imperative) — Inconsistent with agent execution models
- SKILL.md exceeds 500 lines without using references/ — Overloads context, reduces comprehension
- Missing "When to Use" or "When NOT to Use" sections — Required by project quality standards
- Description doesn't specify when to trigger — Skill may never be selected

### Minor Issues (Evaluate before fixing)

These are polish items that may or may not improve the skill:

- Subjective style preferences — Reviewer may have different taste than author
- Optional enhancements — May add complexity without proportional value
- "Nice to have" improvements — Consider cost-benefit before implementing
- Formatting suggestions — Often valid but low impact

## Minor Issue Evaluation

Before implementing any minor issue fix, evaluate:

1. **Is this a genuine improvement?** - Does it add real value or just satisfy a preference?
2. **Could this be a false positive?** - Is the reviewer misunderstanding context?
3. **Would this actually help agents use the skill?** - Focus on functional improvements

Only implement minor fixes that are clearly beneficial. Reviewers may produce false positives.

## Running a Review

Use your platform's review tool or subagent. Request a review with:

> Review the skill at [SKILL_PATH]. Provide a detailed quality assessment with issues categorized by severity (critical, major, minor).

Replace `[SKILL_PATH]` with the absolute path to the skill directory.

## Example Fix Cycle

**Iteration 1 — reviewer output:**
```text
Critical: SKILL.md:1 - Missing required 'name' field in frontmatter
Major: SKILL.md:3 - Description uses second person ("you should use")
Major: Missing "When NOT to Use" section
Minor: Line 45 is verbose
```

**Fixes applied:**
- Added name field to frontmatter
- Rewrote description in third person
- Added "When NOT to Use" section

**Iteration 2 — run review again to verify fixes:**
```text
Minor: Line 45 is verbose
```

**Minor issue evaluation:**
Line 45 communicates effectively as-is. The verbosity provides useful context. Skip.

**All critical/major issues resolved. Output the completion marker:**
```
<skill-improvement-complete>
```

Note: The marker MUST appear in the output. Statements like "quality bar met" or "looks good" will NOT stop the loop.

## Completion Criteria

**CRITICAL**: The stop hook ONLY checks for the explicit marker below. No other signal will terminate the loop.

Output this marker when done:

```
<skill-improvement-complete>
```

**When to output the marker:**

1. **skill-reviewer reports "Pass"** or **no issues found** → output marker immediately
2. **All critical and major issues are fixed** AND you've verified the fixes → output marker
3. **Remaining issues are only minor** AND you've evaluated them as false positives or not worth fixing → output marker

**When NOT to output the marker:**

- Any critical issue remains unfixed
- Any major issue remains unfixed
- You haven't run skill-reviewer to verify your fixes worked

The marker is the ONLY way to complete the loop. Natural language like "looks good" or "quality bar met" will NOT stop the loop.

**Related:** See [writing-skills](../writing-skills/SKILL.md) for the TDD-based skill creation process. That skill covers creating skills from scratch; this skill covers improving existing ones.

## Rationalizations to Reject

- "I'll just mark it complete and come back later" - Fix issues now
- "This minor issue seems wrong, I'll skip all of them" - Evaluate each one individually
- "The reviewer is being too strict" - The quality bar exists for a reason
- "It's good enough" - If there are major issues, it's not good enough
