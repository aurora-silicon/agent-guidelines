# Mesa / GPU Performance Claims

> **Status: DRAFT. Not in force yet.** The [pre-PR checklist](../pre-pr-checklist.md) is in use today; where this draft and the checklist differ, the checklist wins.

Kind: defaults. See "Two kinds of rule" and the glossary in [`AGENTS.md`](../AGENTS.md).

How to back a GPU or Mesa performance claim. Performance claims are easy to get wrong, and the `aurora-silicon/mesa` fork does not gate on GitHub CI. It merges on clean-room review plus hardware proof ([handbook](review-and-merge-handbook.md)). Green CI is not evidence of a win or of no regression.

## Every claim is an on-hardware A/B

Same machine, same kernel, same builder and release options. Arm A is the baseline, arm B is the change. Record each arm's driver identity: git id plus `libvulkan_borealis.so` sha256, or the GL renderer/version string.

## What a claim includes

- **Benchmark and metric**, named: glmark2 fps, a deqp/CTS subset, a fixed render or compute loop, geomean cost B/A. State the run-to-run variance.
- **Conformance unchanged**: deqp-vk, dEQP-GLES or piglit at the stated version. 0 new Fail/Crash/Timeout/QualityWarning against the baseline. NotSupported sets identical except for the flips you document.
- **System health** over the run window: 0 GPU kernel error lines (faults, recoveries, timeouts, lost devices), 0 AVC (SELinux denials), 0 failed units.
- **Power, where relevant**: idle and load watts. A win that costs idle power is a trade-off. Call it out.

## Every generation it applies to

The hardware-selection default in [`commits-and-performance.md`](commits-and-performance.md) section 2 applies. For GPU work that means:

- Confirm the win on every GPU generation it applies to before you claim it. Do not claim a Neo/G17P win without checking G13 and G14. Remember shared silicon: G17P is both M4 Pro and A18 Pro.
- Select a path by a capability or feature check, not a chip list.
- Root-cause a regression on any generation. Do not ship it.

## Reporting

In the PR `## Testing` section give: machine, kernel (`uname -rv`), both arms' driver identities, per-group Pass/Fail/Crash/Timeout/NotSupported counts, the performance table, and the kernel GPU-error line count per window. Link the full results.
