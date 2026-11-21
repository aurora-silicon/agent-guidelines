# Issue Structure and Diagnosis

> **Status: DRAFT. Not in force yet.** The [pre-PR checklist](../pre-pr-checklist.md) is in use today; where this draft and the checklist differ, the checklist wins.

Kind: defaults. Hardware safety and tainted-data handling are hard rules; they are linked where they apply. See "Two kinds of rule" and the glossary in [`AGENTS.md`](../AGENTS.md).

A conclusion is as good as the evidence behind it. Evidence overturns an earlier conclusion; assertion does not.

## Filing

State, in order (skeleton: [`templates/ISSUE_TEMPLATE/bug.md`](../templates/ISSUE_TEMPLATE/bug.md)):

1. **Symptom**: what is wrong, on which machine (chip and board), kernel or build, firmware version.
2. **Repro**: exact minimal steps, the smallest workload that triggers it, how often.
3. **Expected vs actual.**
4. **Evidence**: logs, counters, traces. Link public ones. Refer to tainted ones without quoting them ([`ip-and-tainted-data.md`](ip-and-tainted-data.md)).
5. **Scope**: which generations are affected and which are known not to be. A bug limited to one chip is itself a finding.

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
