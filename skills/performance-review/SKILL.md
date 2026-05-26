---
name: performance-review
description: |
  Use when analyzing performance, optimizing slow code, investigating latency,
  or reviewing bundle size. Activate when the user says "slow", "optimize",
  "performance", "latency", "bundle size", "Core Web Vitals", "lighthouse",
  "memory leak", or is profiling application behavior.
license: MIT
compatibility: Kiro, Claude Code, Copilot, Codex, Gemini CLI, Windsurf
metadata:
  author: nara-governance
  category: performance
  trigger-type: conditional
  stack-match: react,nextjs,angular,vue,express,fastapi
---

# Performance Review

Measure-first performance analysis and optimization.

## Process

### Step 1: Measure Before Optimizing
- **NEVER optimize without a baseline measurement**
- Identify the metric: response time? bundle size? FPS? memory?
- Measure current state with profiling tools
- Set a target: "reduce from Xms to Yms" or "reduce bundle by Z%"

### Step 2: Identify the Bottleneck

**Frontend:**
- Lighthouse / Core Web Vitals (LCP < 2.5s, FID < 100ms, CLS < 0.1)
- Bundle analysis: `npm run build -- --analyze` or `@next/bundle-analyzer`
- React Profiler: unnecessary re-renders
- Network waterfall: blocking requests, large payloads

**Backend:**
- APM / distributed tracing (identify slow spans)
- Database: EXPLAIN ANALYZE on slow queries
- CPU profiling: which function takes the most time?
- Memory profiling: growing heap, unreleased connections

### Step 3: Apply the Right Fix

| Bottleneck | Common Fix |
|-----------|-----------|
| Large bundle | Code splitting, tree shaking, lazy imports |
| Unnecessary re-renders | React.memo, useMemo, useCallback (only where measured) |
| Slow DB query | Add index, optimize JOIN, pagination, caching |
| N+1 queries | Eager loading, DataLoader, batch queries |
| Blocking I/O | async/await, connection pooling, parallel requests |
| Memory leak | Clear intervals, close connections, weak references |
| Large payload | Pagination, field selection, compression |

### Step 4: Verify the Improvement
- Measure AFTER with the same tool as before
- Compare: did the target metric actually improve?
- Check for regressions in other metrics
- Run under realistic load (not just one request)

### Step 5: Prevent Regression
- Add performance budget (bundle size limit in CI)
- Add performance test (response time assertion)
- Document the optimization and why it was needed
- Set up alerting for the metric

## Anti-Rationalization Table

| Excuse | Rebuttal |
|--------|----------|
| "Let me refactor for performance" | Measure first. Refactoring without data is guessing. |
| "useMemo everywhere for safety" | useMemo has a cost. Only where profiler shows re-render problem. |
| "Add an index on every column" | Indexes slow writes and use memory. Add only where queries are slow. |
| "Caching will fix it" | Caching adds complexity and staleness. Fix the root cause first. |
| "It's fast enough on my machine" | Your machine isn't production. Measure under realistic load. |

## Red Flags
- Optimizing without measuring first
- Adding `React.memo` / `useMemo` everywhere "just in case"
- Premature optimization on code that runs rarely
- Caching without invalidation strategy
- "Fix" that improves one metric but degrades another
- No performance budget or regression detection in CI

## Verification
- [ ] Baseline measurement documented
- [ ] Specific bottleneck identified with profiling
- [ ] Fix targets the measured bottleneck (not a guess)
- [ ] Improvement measured with same tool
- [ ] No regressions in other metrics
- [ ] Performance budget or test added to prevent regression
