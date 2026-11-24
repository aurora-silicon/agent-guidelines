# Aurora Silicon: Agent and Contributor Policy

> **Status: DRAFT. Not in force yet.** The [pre-PR checklist](pre-pr-checklist.md) is in use today, and so are the governance policies: [branching and releases](policy/branching-and-releases.md), [governance and roles](policy/governance-and-roles.md), [merge policy](policy/merge-policy.md) and [hotfixes](policy/hotfix.md). Where this draft differs from those, they win. See the [README](README.md) for open questions.

This file is the policy for this repository. It applies to everyone, human or agent, from any provider. The source is `.github/aurora/AGENTS.md`. The `aurora-agent-policy` workflow copies it to `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` and `.github/copilot-instructions.md` and restores the copies if anything overwrites them (including an upstream merge). Edit the source, not the copies. This tree carries no other assistant-instruction file, and never an upstream project's.

Aurora Silicon brings Linux to Apple Silicon Macs. The standard: match macOS behaviour and defaults, beat it on performance, close every gap, expose all the hardware.

## Two kinds of rule

- **Hard rules** protect safety, legality and other people's work. Never deviate. If one seems wrong for your case, stop and ask a maintainer.
- **Defaults** exist so everyone works the same way. If a default gets in the way of a better solution, deviate, state the reason in the PR body, and propose a change to the default in [`aurora-silicon/agent-guidelines`](https://github.com/aurora-silicon/agent-guidelines).

No tool or model is mandated. The rules apply to the output.

Each hard rule below is binding as written. The linked policy has the detail. Words in the [glossary](#glossary) are explained there.

## Hard rules

1. **Public repos hold clean-room code only.** No Apple code or strings, firmware, decompiled or disassembled output, or Apple tuning values in any public repo, PR, issue or channel. Tainted data stays private. Our own traces, measurements and build outputs are public. Detail: [`policy/ip-and-tainted-data.md`](policy/ip-and-tainted-data.md).
2. **Hardware safety.** Detail: [`policy/tracing-guidelines.md`](policy/tracing-guidelines.md).
   - Every test boot has a dead-man.
   - Read a register before you write it. No writes to unknown registers.
   - No Stage 1 or boot-object change without the machine's owner.
   - Never weaken or bypass speaker protection. Speakers can be physically destroyed.
   - Safety limits come from the machine (ADT/DT, its own firmware or tuning bundle, driver-reported ranges), never from per-model tables or constants in code. If the machine does not provide a limit, the feature stays off.
3. **Preserve other people's authorship.** Carry third-party commits unchanged (cherry-pick or merge; never squash or re-author). Your fixes go on top as separate commits. Detail: [`policy/commits-and-performance.md`](policy/commits-and-performance.md).
4. **Commits carry human identity only.** Agents never co-author, sign off or co-commit: no `Co-Authored-By`, no agent `Signed-off-by`, no `Assisted-by`, no session trailers in any commit. When an agent helped, disclose it at the end of the PR body with a plain `Assisted-by:` line naming the model or tool (exact phrasing, vendor prefix, and punctuation do not matter). Detail: [`policy/pr-structure.md`](policy/pr-structure.md).
5. **Licensing and sign-off.** Aurora contributions are GPL-2.0-only. Inherited `aura` code is MIT. Mixed files are `MIT AND GPL-2.0-only`. Every commit has a human `Signed-off-by` (DCO). *(Open question: repos whose base licence differs, see the README.)*
6. **Never upstream to anti-AI projects:** Asahi Linux, NT-for-ASi, upstream Mesa, FEX, or similar. The upstream Linux kernel is fine.
7. **No force pushes to shared branches.** Work lands on the single trunk `main` by pull request only. Shared branches and the branch model: [`policy/branching-and-releases.md`](policy/branching-and-releases.md).
8. **No model gating, no hacks.** No chip, board or firmware-version gates where a hardware property can decide; features work on the default kernel command line. See the [pre-PR checklist](pre-pr-checklist.md), items 1 and 2.
9. **Merge gate and roles.** A PR merges when CI is green, a hardware row ran at its head, and someone other than the author reviewed it with no blocking finding. Only Owners cut releases or change settings. Detail: [`policy/merge-policy.md`](policy/merge-policy.md), [`policy/governance-and-roles.md`](policy/governance-and-roles.md).

## Defaults

Follow these unless you have a better reason, and say so when you deviate.

- **Ship the proper fix.** Fix the cause, not the symptom: no sleeps or retries that hide a race, no disabled checks. If the proper fix is not known yet, write up the diagnosis in the issue and stop. [`policy/commits-and-performance.md`](policy/commits-and-performance.md)
- **Improvements are on by default wherever the hardware exists.** Select by a hardware property, never by "where it was tested". A gate needs a documented hardware reason. No kernel command-line knobs to make a machine work. One kernel config for every supported machine. [`policy/commits-and-performance.md`](policy/commits-and-performance.md)
- **Prove it on the affected hardware before merge.** CI does not replace a run on the Mac(s) the change touches. [`policy/merge-policy.md`](policy/merge-policy.md)
- **Public text describes the code, not the process.** No internal chat, reviews, holds or orchestration in commits, PRs or issues.
- **Test end to end first.** Prefer a real run on the affected hardware to unit tests written to pass. Delete low-signal unit tests.
- **Isolate parallel agents.** Separate worktrees and branches. Do not collide on files or on a hardware lock.

| Topic | Policy |
| --- | --- |
| Checks before opening a PR | [`pre-pr-checklist.md`](pre-pr-checklist.md) |
| Commits, proper fixes, hardware-selected defaults | [`policy/commits-and-performance.md`](policy/commits-and-performance.md) |
| PR body, agent disclosure, credits | [`policy/pr-structure.md`](policy/pr-structure.md) |
| Merge gate (in use) | [`policy/merge-policy.md`](policy/merge-policy.md) |
| Branches, release channels, upstream updates (in use) | [`policy/branching-and-releases.md`](policy/branching-and-releases.md) |
| Roles and permissions (in use) | [`policy/governance-and-roles.md`](policy/governance-and-roles.md) |
| Stable hotfixes (in use) | [`policy/hotfix.md`](policy/hotfix.md) |
| Review triage and routing | [`policy/pr-review.md`](policy/pr-review.md) |
| Filing and diagnosing issues | [`policy/issue-structure.md`](policy/issue-structure.md) |
| Bringing up a new Mac | [`policy/device-bringup-ladder.md`](policy/device-bringup-ladder.md) |
| GPU performance claims | [`policy/mesa-performance-claims.md`](policy/mesa-performance-claims.md) |
| Trace contents, hardware safety | [`policy/tracing-guidelines.md`](policy/tracing-guidelines.md) |
| Public vs tainted, licensing, upstreaming | [`policy/ip-and-tainted-data.md`](policy/ip-and-tainted-data.md) |

## Glossary

*(Open question: the Stage 1/2, 1TR, stub, proxyclient and fleet-kernel entries still need a check by a boot-chain owner.)*

- **aura**: Aurora's bootloader. Apple's boot chain starts it; it sets up the hardware and starts U-Boot and Linux. It can also run as a hypervisor (HV).
- **Stage 1 / boot object**: the first part of aura, the piece Apple's boot chain loads. Changing it needs a person at the machine, in 1TR.
- **Stage 2**: the rest of aura plus devicetrees, on the EFI system partition (ESP). It can be updated from Linux.
- **1TR**: One True Recovery. Apple's recovery mode, entered by holding the power button at power-on. Boot-security changes are only possible there.
- **Dead-man**: an automatic reboot or recovery you arm before a test, so the machine comes back by itself if the test hangs or you lose the session.
- **Tainted**: derived from Apple binaries, firmware or tuning values. Private, always.
- **Clean-room**: written from documented hardware facts and named fields, not copied from reverse-engineering (RE) output.
- **ADT / DT**: the Apple Device Tree that Apple's bootloader hands to aura, and the Linux devicetree that aura builds from it.
- **Fleet kernel**: the single kernel build the test Macs run, built from the merged tip of `main` (the `aurora-edge` channel). Kernel PRs may also be batched into a numbered fleet candidate and tested together; a row on a candidate counts for a PR whose head commits it contains unchanged.
- **Hardware row**: one test run on one Mac, built from a PR's head, with its result recorded in the PR. See [`policy/merge-policy.md`](policy/merge-policy.md).
- **Owner / Core / Maintainer**: the roles in [`policy/governance-and-roles.md`](policy/governance-and-roles.md).
- **main / aurora-edge / aurora-nightly / v\***: the trunk and the three release channels. See [`policy/branching-and-releases.md`](policy/branching-and-releases.md).
- **A/B run**: the same test on the same machine, arm A (baseline) against arm B (your change). One machine's result is one row of the A/B table.
- **Machine names**: T-codes name the chip (`T6040` = M4 Pro), J-codes name the board (`J616s`), G-codes name the GPU generation (`G13`, `G14`, `G17P`). One GPU generation can span chips: G17P is in both M4 Pro and A18 Pro. "Neo" is J700, the A18 Pro Mac.
- **DCO**: Developer Certificate of Origin. The `Signed-off-by` line states you have the right to submit the code.

## Per-repo notes

*Repo-specific build, test and bring-up notes. Keep them short. Link the policies above instead of restating them.*
