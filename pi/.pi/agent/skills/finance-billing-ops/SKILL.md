---
name: finance-billing-ops
description: Evidence-first revenue, pricing, refunds, team-billing, and billing-model truth workflow for ECC. Use when the user wants a sales snapshot, pricing comparison, duplicate-charge diagnosis, customer remediation, or code-backed billing reality instead of generic payments advice.
metadata:
  origin: ECC
---

# Finance & Billing Ops

Operator truth about money: revenue state, pricing decisions, team billing, code-backed billing behavior, and customer remediation.

---

## When to Use

- User asks for Stripe sales, refunds, MRR, or recent customer activity
- User asks whether team billing, per-seat billing, or quota stacking is real in code
- User wants competitor pricing comparisons or pricing-model benchmarks
- Customer says billing is broken, wants a refund, or cannot cancel
- Investigating duplicate subscriptions, accidental charges, failed renewals, or churn risk
- Reviewing plan mix, active subscriptions, yearly vs monthly conversion, or team-seat confusion
- Question mixes revenue facts with product implementation truth

## Skill Stack

- `research-ops` — competitor pricing or current market evidence
- `github-ops` — billing truth depending on code, backlog, or release state
- `verification-loop` — proving checkout, seat handling, or entitlement behavior

## Guardrails

- Distinguish live data from saved snapshots
- Never expose secret keys, full card details, or unnecessary customer PII
- Do not refund blindly; classify the issue first
- Separate: revenue fact, customer impact, code-backed product truth, recommendation
- Do not say "per seat" unless the actual entitlement path enforces it
- Do not assume duplicate subscriptions imply duplicate value
- Do not conflate failed attempts with net revenue
- Do not infer team billing from marketing language alone
- Do not compare competitor pricing from memory when current evidence is available

## Workflows

### Workflow A: Revenue & Pricing Truth

#### 1. Start from freshest billing evidence

Prefer live billing data. If not live, state snapshot timestamp.

Normalize:
- paid sales
- active subscriptions
- failed or incomplete checkouts
- refunds
- disputes
- duplicate subscriptions

#### 2. Separate customer incidents from product truth

If the question is customer-specific, classify first:
- duplicate checkout
- real team intent
- broken self-serve controls
- unmet product value
- failed payment or incomplete setup

Then separate from broader product question:
- does team billing really exist?
- are seats actually counted?
- does checkout quantity change entitlement?
- does the site overstate current behavior?

#### 3. Inspect code-backed billing behavior

If answer depends on implementation truth, inspect:
- checkout
- pricing page
- entitlement calculation
- seat or quota handling
- installation vs user usage logic
- billing portal or self-serve management

#### 4. End with decision and product gap

```
SNAPSHOT
- timestamp
- revenue / subscriptions / anomalies

CUSTOMER IMPACT
- who is affected
- what happened

PRODUCT TRUTH
- what the code actually does
- what the website or sales copy claims

DECISION
- refund / preserve / convert / no-op

PRODUCT GAP
- exact follow-up item to build or fix
```

### Workflow B: Customer Remediation

Use when a specific customer needs help — refunds, duplicates, cancellations.

#### 1. Identify the customer

Strongest identifier first: email, Stripe customer ID, subscription ID, invoice ID.

Return a concise identity summary:
- customer
- active subscriptions
- canceled subscriptions
- invoices
- anomalies (duplicate active subs)

#### 2. Classify the issue

| Case | Typical action |
|------|----------------|
| Duplicate personal subscription | cancel extras, consider refund |
| Real multi-seat/team intent | preserve seats, clarify billing model |
| Failed payment / incomplete checkout | recover via portal or update payment method |
| Missing self-serve controls | provide portal, cancellation path |
| Product failure or trust break | refund, apologize, log product issue |

#### 3. Safest reversible action first

1. Restore self-serve management
2. Fix duplicate or broken billing state
3. Refund only the affected charge or duplicate
4. Document the reason
5. Send short customer follow-up

If fix requires product work, separate:
- customer remediation now
- product bug / workflow gap for backlog

#### 4. Check operator-side product gaps

Call out missing operator surfaces: no billing portal, no usage visibility, no plan explanation, no cancellation flow, no duplicate-subscription guard.

#### 5. Operator handoff

```
CUSTOMER
- name / email
- relevant account identifiers

BILLING STATE
- active subscriptions
- invoice or renewal state
- anomalies

DECISION
- issue classification
- why this action is correct

ACTION TAKEN
- refund / cancel / portal / no-op

FOLLOW-UP
- short customer message

PRODUCT GAP
- what should be fixed in product or website
```

## Verification

- Answer includes live-data statement or snapshot timestamp
- Product-truth claims are code-backed
- Customer-impact and broader pricing/product conclusions separated cleanly
