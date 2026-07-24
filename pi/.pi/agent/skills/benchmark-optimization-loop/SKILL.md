---
name: benchmark-optimization-loop
description: Use when the user asks to measure performance baselines, detect regressions before/after PRs, compare stack alternatives, make something faster, try many variants, run recursive optimization, or benchmark latency/throughput/cost. Covers both one-shot benchmarking and iterative optimization loops.
metadata:
  origin: ECC
tools: Read, Write, Edit, Bash, Grep, Glob
---

# Benchmark & Optimization Loop

Two modes: **benchmark** (measure baseline / detect regression) and **optimize** (iterative speedup loop).

---

## Mode 1: Benchmark Baselines

### Page Performance (browser metrics)

```
1. Navigate to each target URL
2. Measure Core Web Vitals:
   - LCP — target < 2.5s
   - CLS — target < 0.1
   - INP — target < 200ms
   - FCP — target < 1.8s
   - TTFB — target < 800ms
3. Measure resource sizes:
   - Total page weight (target < 1MB)
   - JS bundle size (target < 200KB gzipped)
   - CSS size, Image weight, Third-party script weight
4. Count network requests
5. Check for render-blocking resources
```

### API Performance

```
1. Hit each endpoint 100 times
2. Measure: p50, p95, p99 latency
3. Track: response size, status codes
4. Test under load: 10 concurrent requests
5. Compare against SLA targets
```

### Build Performance

```
1. Cold build time
2. Hot reload time (HMR)
3. Test suite duration
4. TypeScript check time
5. Lint time
6. Docker build time
```

### Before/After Comparison

```
/benchmark baseline    # saves current metrics
# ... make changes ...
/benchmark compare     # compares against baseline
```

Output:
```
| Metric | Before | After | Delta | Verdict |
|--------|--------|-------|-------|---------|
| LCP | 1.2s | 1.4s | +200ms | WARNING |
| Bundle | 180KB | 175KB | -5KB | ✓ BETTER |
| Build | 12s | 14s | +2s | WARNING |
```

Stores baselines in `.ecc/benchmarks/` as JSON (git-tracked).

---

## Mode 2: Optimization Loop

Convert "make it 20x faster" into a bounded measured loop.

### Required Baseline

Do not optimize until these exist:
- the operation being optimized
- the correctness gate that must stay green
- the metric: wall time, p95 latency, rows/sec, cost/run, memory, error rate
- the current baseline
- the search budget: max variants, max time, max spend, max data impact

### Loop

1. Measure the baseline.
2. Identify bottlenecks from evidence.
3. Generate variants that test one hypothesis each.
4. Run variants with the same input shape.
5. Reject variants that fail correctness, safety, or reproducibility.
6. Promote the fastest safe variant.
7. Codify the winning path in script, command, test, config, or doc.
8. Rerun baseline and winner to confirm delta.

### Variant Table

```
Variant | Hypothesis | Command | Time | Correct? | Notes
baseline | current path | npm run job | 120s | yes | stable
batch-500 | fewer round trips | npm run job --batch 500 | 42s | yes | winner
parallel-8 | more workers | npm run job --workers 8 | 31s | no | rate limited
```

### Recursive Search

- Persist every run to a ledger
- Compare against prior accepted winner, not only previous run
- Keep a holdout or replay check
- Stop when improvement within noise, correctness fails, cost exceeds budget, or search changes more variables than it can explain

Use "best measured safe variant" not "global optimum" unless search was exhaustive.

### Promotion Gate

A variant cannot become the new default until:
- correctness tests pass
- performance delta is repeated or explained
- rollback is obvious
- change is encoded in source control or durable runbook
- final summary includes exact commands and measurements
