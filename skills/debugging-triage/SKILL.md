---
name: debugging-triage
description: |
  Use when the user reports an error, exception, failing test, unexpected behavior,
  or asks for help fixing a bug. Guides systematic diagnosis through reproduce,
  localize, reduce, fix, guard. Activate even if they don't say "debug" explicitly —
  any "it's broken", "why does this fail", "getting an error", or stack trace triggers this.
license: MIT
compatibility: Kiro, Claude Code, Copilot, Codex, Gemini CLI, Windsurf
metadata:
  author: nara-governance
  category: debugging
  trigger-type: universal
---

# Debugging Triage

Systematic 5-step process for resolving errors and unexpected behavior.

## Process

### Step 1: Reproduce
- Identify the exact error message, stack trace, or unexpected output
- Determine the minimal steps to trigger the issue
- Confirm environment (local, staging, prod, CI)
- Note: if you cannot reproduce it, say so — do not guess

### Step 2: Localize
- Trace the error to the specific file and line
- Identify the call chain that leads to the failure
- Check recent changes (git log, blame) that may have introduced it
- Look at the relevant test that should have caught this

### Step 3: Reduce
- Isolate the minimal code path that triggers the issue
- Remove unrelated complexity
- Create a failing test that reproduces the bug (Red)
- If the issue is intermittent, identify the race condition or state dependency

### Step 4: Fix
- Apply the minimal change that resolves the root cause
- Do NOT apply band-aids (catching/swallowing the error)
- Verify the failing test now passes (Green)
- Check for similar patterns elsewhere in the codebase

### Step 5: Guard
- Ensure the fix has a corresponding test
- Add logging or metrics if the failure was silent
- Document the root cause in the commit message
- Consider if a linter rule or type constraint can prevent recurrence

## Anti-Rationalization Table

| Excuse | Rebuttal |
|--------|----------|
| "I'll just add a try/catch" | That hides the bug. Fix the cause, not the symptom. |
| "It works on my machine" | Reproduce in the same env as the failure. Check CI logs. |
| "I'll fix it properly later" | The later fix never comes. Fix it now or file a tracked ticket. |
| "It's probably a flaky test" | Flaky tests have deterministic causes. Find the race condition. |
| "Let me rewrite this whole module" | Minimize blast radius. Fix the bug, not the architecture. |

## Red Flags
- Error is swallowed somewhere (empty catch, except: pass)
- The same error appeared before and was "fixed" already
- Fix changes more than 20 lines (probably addressing wrong layer)
- No test added with the fix

## Verification
- [ ] Root cause identified and documented
- [ ] Failing test written that reproduces the bug
- [ ] Fix is minimal and targeted
- [ ] Test passes after fix
- [ ] No other tests broken by the change
- [ ] Commit message explains the WHY
