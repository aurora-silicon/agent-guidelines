# Issue Structure and Diagnosis

> **Status: IN FORCE** (since 2026-11-24). One structure for every issue in every Aurora Silicon repository. The forms live in [`aurora-silicon/.github`](https://github.com/aurora-silicon/.github/tree/main/.github/ISSUE_TEMPLATE) and GitHub serves them to every repository without forms of its own; their required fields are enforced by GitHub.

Kind: the forms and the privacy rules are **hard rules**; the diagnosis guidance is a default. Hardware safety and tainted-data handling are linked where they apply. See "Two kinds of rule" and the glossary in [`AGENTS.md`](../AGENTS.md).

A conclusion is as good as the evidence behind it. Evidence overturns an earlier conclusion; assertion does not.

## Forms

Three short forms ([`aurora-silicon/.github`](https://github.com/aurora-silicon/.github/tree/main/.github/ISSUE_TEMPLATE)); GitHub enforces their required fields:

- **Bug**: what happens (and what you expected), Mac and build, how to reproduce, logs.
- **Regression**: last good build, first bad build, Mac(s), what changed, evidence.
- **Bring-up**: goal (what should work, on which Macs), current state, plan, evidence.

Same shape as PRs: the visible part is a few plain sentences; long logs go in the evidence field (folded automatically) or a gist. Never post serial numbers, ECIDs, UDIDs, keys, calibration bytes, raw device trees or per-unit firmware, and nothing derived from Apple binaries, firmware or tuning values.

## Filing

What a good report contains (the forms ask for the first four):

1. **Symptom**: what is wrong, on which machine (chip and board), kernel or build, firmware version.
2. **Repro**: exact minimal steps, the smallest workload that triggers it, how often.
3. **Expected vs actual.**
4. **Evidence**: logs, counters, traces. Link public ones. Refer to tainted ones without quoting them.
5. **Scope**: which generations are affected and which are known not to be. A bug limited to one chip is itself a finding.

One problem per issue. Add evidence for a known bug to its existing issue; search first.

## Triage

Add the `area:` label, close duplicates with a link, and fix with a PR that says `Fixes #NNN`.

## Diagnosing

- **Reproduce first, then bisect.** A bisection result beats a hunch.
- **Decode the actual fault** (the exception syndrome, the faulting instruction, the register value) instead of guessing. Check that a reported value is the real hardware value.
- **Corroborate with independent signals.** One signal can mislead. Agreement between a counter, a log line and a measured timing makes a root cause.
- **Confirm on the affected Mac(s).** Green CI is not a diagnosis.
- **Test earlier verdicts.** If old notes say "Y is the cause", check it. Say when a claim comes from reading source and not from this run. Record what you cleared ("not commit abc1234; the cause is the buffer-cleanup drain").
- **Hardware safety applies**: read before write, dead-man on every test boot ([`tracing-guidelines.md`](tracing-guidelines.md)).

## Writing up

End with a verdict a human can act on:

```
## RESULTS
VERDICT: FIXED | BLOCKED | DISPROVEN | ROOT-CAUSED
What was proven, and the evidence that proves it.
NEXT LEVER: the single most promising next step, and what it needs (hardware, a review,
a supervised boot, a decision).
```

Mark disproven and stale findings clearly ("disproven; don't re-chase") so nobody repeats the work. A well-evidenced negative result is a result.
