# Maintainer PR Review

> **Status: DRAFT. Not in force yet.** The [pre-PR checklist](../pre-pr-checklist.md) is in use today; where this draft and the checklist differ, the checklist wins.

Kind: defaults, except lines marked **Hard rule**. See "Two kinds of rule" and the glossary in [`AGENTS.md`](../AGENTS.md). Reviewers also check every item of the [pre-PR checklist](../pre-pr-checklist.md).

## Triage

Sort every open PR into one outcome:

- **MERGE**: meets the gate now.
- **FINISH-then-MERGE**: correct, but missing evidence or a small fix. Name what it needs.
- **CLOSE-as-superseded**: replaced by another PR or commit. Say which.
- **HOLD**: blocked on a dependency, a decision or hardware. Name the blocker and its owner.

## Merge gate

All must hold.

1. **Clean-room review of the whole diff (Hard rule).** Search the entire diff (source, tools, kits, tests), not one directory, for Apple-derived values or names, tainted data, and bare hex constants that match Apple program or firmware words. A tainted diff is never merged. If one was accepted by mistake, close it, back it up privately and requeue the work. The test for clean-room is in [`ip-and-tainted-data.md`](ip-and-tainted-data.md).
2. **Authorship and attribution (Hard rule).** Third-party commits are unchanged, commits carry human identity only, reporters and testers are credited ([`commits-and-performance.md`](commits-and-performance.md), [`pr-structure.md`](pr-structure.md)).
3. **Proper fix.** No workaround, no disabled check, no gate without a hardware reason ([`commits-and-performance.md`](commits-and-performance.md)). A stated deviation from a default is reviewed on its reason.
4. **CI green where it applies.** The `aurora-silicon/mesa` fork does not gate on GitHub CI; there, hardware proof is the gate.
5. **Tested on the Mac(s) it touches**, where testable, with a regression run (the fleet regression suite or the repo's own tests) showing no regression: 0 AVC (SELinux denials), 0 failed units, 0 new kernel errors. Performance claims meet [`mesa-performance-claims.md`](mesa-performance-claims.md).
6. **Shared paths.** If the change touches a shared path, the PR states which other generations were verified unaffected.

## Routing

- **Merge proven work yourself.** Do not wait on another maintainer, except for that maintainer's own areas or boards and for changes to user-facing defaults.
- **Kernel PRs** are batched into one fleet candidate, not booted one PR at a time. Route them to the kernel/fleet maintainer.
- **Hardware not in the lab:** merge on review plus DT and CI checks plus proof that supported boards are unaffected. Send the hardware confirmation to the machine's owner as a regression request.
- **Website (Hard rule):** never merge or deploy without the designated owners. `main` is protected with code-owner review.

## Review comments

Comment on the code. No internal process in public PR threads. If a PR is held for an internal reason, record the reason privately and leave a neutral, code-focused note.
