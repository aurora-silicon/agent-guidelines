<!--
DRAFT template (aurora-silicon/agent-guidelines).
Aurora Silicon PR. Rules: AGENTS.md, pre-pr-checklist.md and policy/pr-structure.md
in https://github.com/aurora-silicon/agent-guidelines.
Short prose a person can read in a minute. Describe the code and its testing.
No internal process, reviews or holds.
-->

## Problem

<!-- What is wrong or missing, on which machine (chip/board), kernel/build, firmware. Fixes #NNN -->

## Change

<!-- What you changed and why it is the proper fix.
     Which chips/boards it affects. If it is gated: the hardware reason.
     If you deviated from a default: which one and why. -->

## Testing

<!-- Hardware you ran on and the result. A/B or regression table. Suite name and counts
     (0 AVC, 0 failed units, 0 new kernel errors). Performance change if any.
     GPU claims: policy/mesa-performance-claims.md. -->

## Still to run

<!-- What is not covered yet, and on which hardware. -->

<!-- Full detail for reviewers goes in collapsible blocks. Never hide the problem, the
     change or a regression in one.
<details>
<summary>Full test results</summary>

...
</details>
-->

- [ ] Clean-room: no Apple code, strings, firmware, RE output or tuning values
- [ ] No chip/board/firmware-version gate where a hardware property can decide
- [ ] Works on the default kernel command line; no hacks, delays or lab-only paths
- [ ] Safety limits come from the machine, not from constants in code
- [ ] Hardware safety rules followed for every test boot
- [ ] Third-party commits unchanged; reporters and testers credited
- [ ] Commits: human Signed-off-by only; no agent trailers of any kind
- [ ] Tested on the affected hardware; no regression

<!-- If an agent helped, keep this as the LAST line of the body. Otherwise delete it. -->
Assisted-by: LLM (<Vendor>:<Model>)
