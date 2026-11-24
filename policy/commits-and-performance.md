# Commits and Performance

> **Status: IN FORCE** (since 2026-11-24). Change it by PR here.

Kind: defaults, except lines marked **Hard rule**. Sections 1 and 2 are defaults with a high bar; their core ("no hacks", "default command line", "no chip/board/firmware gates") is a hard rule in the pre-PR checklist. See "Two kinds of rule" and the glossary in [`AGENTS.md`](../AGENTS.md).

## 1. Proper fixes

A merged change fixes the cause. These do not belong in a merged change:

- A workaround that hides a bug: a sleep, delay or retry over a race, a second init pass, a swallowed error.
- A check, test or assertion disabled, loosened or skipped to get a pass.
- A magic constant that is "the value that worked", with no explanation of why it is correct.
- Commented-out code, dead branches, or `TODO`/`FIXME`/`XXX`/`HACK` without a tracking issue and a reason to defer.
- A revert of someone's fix made without understanding why the fix was there.

If the proper fix is not known yet, open or update an issue with the diagnosis so far and the blocker, and stop. Do not ship a hack in the meantime.

One exception: a temporary mitigation is allowed when a real user is broken now. Label it in the code and file the issue to remove it in the same PR.

How to diagnose: [`issue-structure.md`](issue-structure.md).

## 2. Improvements are defaults, selected by hardware

The aim is to beat macOS on GPU, ANE (neural engine), media engines, CPU, I/O and battery, on every generation.

- **Default on wherever the hardware exists.** An improvement is enabled on every machine that has the hardware it uses. It is never limited to the machines it was tested on.
- **Select by a hardware property.** Decide from what the hardware reports (a capability probe, an ADT/DT field, a feature bit), not from a list of chips or boards. The house pattern is `monitor_required()`. Lists go stale; probes do not.
- **A gate needs a documented hardware reason:** a real erratum, a different hardware block, a value that exists only on that chip. Put the reason and the evidence in a code comment and in the PR.
- **No kernel command-line knobs to make a machine work.** Every supported machine works with the default command line.
- **One kernel config for every supported machine.**
- **"Not tested there" is not a reason to gate.** Check the other machines the change plausibly affects before you claim a win. Ask for a regression run on machines you do not have ([handbook](review-and-merge-handbook.md)). GPU claims: [`mesa-performance-claims.md`](mesa-performance-claims.md).
- **Root-cause regressions.** If the change costs performance, stability or power anywhere, find out why and fix that. A default must not regress power or stability. If a trade-off is truly unavoidable, a maintainer decides, with the measured numbers written down.

To deviate from this section you need a hardware reason, stated in the PR.

## 3. Commits

- One logical change per commit. Refactors and behaviour changes are separate commits.
- Plain, descriptive subject. The message explains the code and its testing, not internal process, reviews or holds.
- Build hardware values from named, commented fields. No bare hex that only makes sense because it matches an Apple firmware word ([`ip-and-tainted-data.md`](ip-and-tainted-data.md)).
- **Hard rule: human identity only.** Every commit has a `Signed-off-by` (DCO) from the human responsible. Agents never co-author, sign off or co-commit: no `Co-Authored-By`, no agent `Signed-off-by`, no `Assisted-by`, no session trailers. PR text carries no AI attribution either ([`pr-structure.md`](pr-structure.md)).
- **Hard rule: preserve authorship.** Carry third-party commits unchanged (cherry-pick or merge; never squash, never re-author). Your fixes are separate commits on top.
- **Hard rule: no force pushes to shared branches.**
