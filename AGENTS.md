# Aurora Silicon: the Rulebook for Agents and Contributors

> **Status: IN USE** (since 2026-11-24, Ryan's ruling "one rulebook for all agents"; co-Owner sign-off requested in the PR that made it so). Every agent working on Aurora Silicon loads this file, whoever runs it: the Owners' agents, Core's, the Omarchy Mac team's, Aurora Dev's, anyone's. Humans follow the same rules. Where a linked policy goes into more detail, the policy wins.

Every repository in the organisation carries a root `AGENTS.md` and `CLAUDE.md` that point here, followed by that repo's own notes. Codex, Gemini, Antigravity and similar tools read `AGENTS.md`; Claude reads `CLAUDE.md`. Repos that carry the `aurora-agent-policy` workflow (aura and others) keep their source in `.github/aurora/AGENTS.md`, which also points here.

Aurora Silicon brings Linux to Apple Silicon Macs. The standard: match macOS behaviour and defaults, beat it on performance, close every gap, expose all the hardware.

## Two kinds of rule

- **Hard rules** protect safety, legality and other people's work. Never deviate. If one seems wrong for your case, stop and ask an Owner.
- **Defaults** exist so everyone works the same way. If a default gets in the way of a better solution, deviate, state the reason in the PR body, and propose a change here by PR.

No tool or model is mandated. The rules apply to the output.

## Hard rules

1. **No copyrighted Apple material in public.** Public repos, PRs, issues, gists and channels never contain Apple's own material: verbatim Apple code, decompiled or disassembled listings, copied strings or symbol dumps beyond the names needed to interoperate, or Apple files (firmware, tuning sets; the installer extracts those from the IPSW on the user's Mac). Reverse-engineering contributions are welcome: drivers, interface layouts, register and protocol descriptions and the constants needed to interoperate, written as our own code with named fields. ADT/DT values are hardware facts and may be cited from any source. Our own traces, measurements and build outputs are public by default. Detail: [`policy/ip-and-tainted-data.md`](policy/ip-and-tainted-data.md).
2. **Per-model firmware data comes from the IPSW only.** Speaker tunings, audio/DSP tables and other per-model, firmware-version data are extracted from the macOS restore image (IPSW) that matches the Mac's firmware (speaker tunings: the pinned 27.2 IPSW), on the user's own Mac, and never redistributed. No fallback to an installed macOS. Only per-unit data (calibration, unit-unique keys) is read from the machine itself.
3. **Hardware safety.** Detail: [`policy/tracing-guidelines.md`](policy/tracing-guidelines.md).
   - Every test boot has a dead-man. Read a register before you write it; no writes to unknown registers.
   - No Stage 1, boot-object, LocalPolicy or 1TR change without the machine's owner.
   - **Speakers can be physically destroyed.** Playback over internal speakers only with speaker protection (speakerguardd v2) running and gating, only when the machine's owner allows playback, starting quiet, stopping at the first protection event. Never weaken, bypass or disable protection.
   - Safety limits come from the machine (ADT/DT, its own firmware or tuning bundle, driver-reported ranges), never from per-model tables or constants in code. If the machine does not provide a limit, the feature stays off or muted.
   - Before a USB-C VDM or HPM reset, confirm which Mac is on the far end of the cable.
4. **No model gating, no hacks: one implementation.** No chip, SoC, board or firmware-version gates where a hardware property (DT/ADT property, block compatible, capability bit, probed register) can decide. Features work on the **default kernel command line**: no new command-line or module parameters, environment variables or manual steps. No sleeps over races, magic delays or lab-only paths. Code that serves several chips is one implementation keyed on hardware data. Details: the [pre-PR checklist](pre-pr-checklist.md), items 1 and 2.
5. **No AI attribution anywhere.** Commits carry the human author and a human `Signed-off-by` (DCO) only. No `Assisted-by`, `Co-Authored-By` naming a tool, agent `Signed-off-by`, "Generated with" lines, model or tool names, or session links in commits, PR titles and bodies, comments or reviews. The upstream kernel does not list tools as authors, and neither do we. Detail: [`policy/pr-structure.md`](policy/pr-structure.md).
6. **No serial numbers in public.** No Mac serials, ECIDs, UDIDs or monitor/accessory EDID serials in PRs, issues, commits, gists or logs you publish. Write `[serial redacted]`.
7. **Preserve other people's authorship.** Carry third-party commits unchanged (cherry-pick or merge; never squash or re-author them). Your fixes go on top as separate commits.
8. **Licensing.** Aurora contributions are GPL-2.0-only. Inherited `aura` code is MIT. Mixed files are `MIT AND GPL-2.0-only`. *(Open question: repos whose base licence differs, see the README.)*
9. **Never upstream to anti-AI projects:** Asahi Linux, NT-for-ASi, upstream Mesa, FEX, or similar. The upstream Linux kernel is fine.
10. **One trunk, no force pushes.** Work lands on the default branch (`main`) by pull request only, from `feat/`, `fix/` or `wip/` branches; `archive/`, `hotfix/` and `rebase/` have their own rules. Never force-push a shared branch. Detail: [`policy/branching-and-releases.md`](policy/branching-and-releases.md).
11. **Merge gate.** A PR merges when CI is green, a hardware row ran at its head, and someone other than the author reviewed it with no blocking finding; then within the hour. A PR written mainly by a smaller, faster model gets its review from a human or a stronger model; the author's team routes that request internally, never through attribution in the PR. Agent reviews never replace a human Owner's sign-off on Owner-level policy. Detail: [`policy/merge-policy.md`](policy/merge-policy.md), [handbook](policy/review-and-merge-handbook.md).
12. **Roles.** Core and Omarchy Mac review and merge; Aurora Dev develop and do not merge into default branches; only Owners cut releases, move release tags or change settings and access. Detail: [`policy/governance-and-roles.md`](policy/governance-and-roles.md), [`policy/access-tiers.md`](policy/access-tiers.md).
13. **Shared hardware: take a turn, give it back as you found it.** Take the machine's lock (or the owner's agreement) before you use a shared Mac; one user at a time. Before you release it, restore its saved default (default kernel and boot entry, no pending one-shot boot, SELinux enforcing, 0 failed units) and verify it. A Mac running a lab build goes back to the current edge build.
14. **No device "what works" articles.** Device support status goes only into the website's support data, with evidence, never into hand-written per-device support or install articles.
15. **Naming.** Our Vulkan driver is **Borealis**; never call our work Honeykrisp or "hk" in prose. New paths and names of our own use Aurora, not Asahi or m1n1 (for example `/Aurora/` on the ESP). Names fixed by upstream code or an interface stay. Detail: [pre-PR checklist](pre-pr-checklist.md), item 6.

## Defaults

Follow these unless you have a better reason, and say so when you deviate.

- **Search before you start; no duplicated work.** Before starting any piece, search open PRs and recent branches in `aurora-silicon` (all teams and their agents) for the same file, function or feature, and post your intent (area, files) where the other agents see it. If someone already has it, review, test or build on theirs instead. If a teammate reports a bug on hardware you also have, reproduce it and add rows, coordinated with the owner; write the fix only when nobody owns it.
- **Ship the proper fix.** Fix the cause, not the symptom. If the proper fix is not known yet, write up the diagnosis in the issue and stop. [`policy/commits-and-performance.md`](policy/commits-and-performance.md)
- **Improvements are on by default wherever the hardware exists**, selected by a hardware property, never by "where it was tested". One kernel config and one command line for every supported machine.
- **Prove it on the affected hardware before merge.** CI does not replace a run on the Mac(s) the change touches. Rows can be asked of any team through a regression request ([handbook](policy/review-and-merge-handbook.md), section 4); give a fetchable kit (release asset or gist), never a path on your machine.
- **Never park work waiting on a person**, except for things only a person can do (physical access, 1TR, credentials, an Owner's sign-off). Do not block on volunteers who have not agreed to run something: produce the closest equivalent row yourself and say what it stands in for.
- **Push finished work, once.** Build and test locally; push a PR branch when it is ready for review, as one push. Related changes to one repo go in one PR where reviewable. Do not re-push unchanged branches to re-trigger CI.
- **Finished work goes to the default branch**, not to side, backup or private branches. Lab machines run the merged tips; a local stack is temporary proof only.
- **Report status plainly.** Results are numbers on disk or in the PR (what ran, where, on which build, the result). Plans and "should work" are not results. When blocked, say what blocked you, with the evidence, and the next thing you would try.
- **Public text describes the code, not the process.** No internal chat, reviews, holds or orchestration in commits, PRs or issues.
- **Test end to end first.** Prefer a real run on the affected hardware to unit tests written to pass; end-to-end runs leave a verifiable, repeatable artifact. Before testing a part in isolation, write down how it could fail. Delete low-signal unit tests that would not catch a real bug the end-to-end run misses.
- **Isolate parallel agents.** Separate worktrees and branches. Do not collide on files or on a hardware lock.

## Agents: how to join

For agents run by any team (Dj's, the Omarchy Mac team's, anyone's):

1. **Load this file.** Every repo's `AGENTS.md`/`CLAUDE.md` points here; read it in full, then the [pre-PR checklist](pre-pr-checklist.md).
2. **Connect to the Aurora Agents channel** (the coordination service the teams' agents share; ask an Owner for access and a token for your agent). Introduce your agent: who runs it, which Macs it can test on.
3. **Post intent before work** (area, files, PR you will build on), and read what others posted.
4. **Use regression requests for hardware rows.** Post a `regression_request` (repository, exact ref, platforms, instructions, pass criteria, baseline, constraints); claim requests your owner's Macs can run, and post the structured result on the request and the PR. Release candidates are cross-checked the same way ([`policy/branching-and-releases.md`](policy/branching-and-releases.md), section 4).
5. **Review in waves.** Request changes with numbered blocking findings and a separate non-blocking list; approve with what you checked; one format for everyone ([`policy/pr-review.md`](policy/pr-review.md)).
6. **Propose rule changes by PR here.** Never fork the rules into a local file that disagrees with this one.

## Index

| Topic | Policy |
| --- | --- |
| Checks before opening a PR | [`pre-pr-checklist.md`](pre-pr-checklist.md) |
| Reviewing and merging (for Core and Omarchy Mac) | [`policy/review-and-merge-handbook.md`](policy/review-and-merge-handbook.md) |
| Merge gate | [`policy/merge-policy.md`](policy/merge-policy.md) |
| Branches, release channels, stable gate, upstream updates | [`policy/branching-and-releases.md`](policy/branching-and-releases.md) |
| Roles and permissions | [`policy/governance-and-roles.md`](policy/governance-and-roles.md) |
| Team access per repository, rulesets | [`policy/access-tiers.md`](policy/access-tiers.md) |
| Stable hotfixes | [`policy/hotfix.md`](policy/hotfix.md) |
| Commits, proper fixes, hardware-selected defaults | [`policy/commits-and-performance.md`](policy/commits-and-performance.md) |
| PR body, no AI attribution, credits | [`policy/pr-structure.md`](policy/pr-structure.md) |
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
- **Tainted**: Apple's own material (code, disassembly or decompiler listings, firmware, tuning sets) and RE byproducts such as raw listings, addresses and symbol tables. Private, always. The understanding gained from RE is not tainted: write it up as our own code.
- **Clean-room**: our own code, written from hardware facts and named fields, not copied from Apple's code or RE listings.
- **ADT / DT**: the Apple Device Tree that Apple's bootloader hands to aura, and the Linux devicetree that aura builds from it.
- **Fleet kernel**: the single kernel build the test Macs run, built from the merged tip of `main` (the `aurora-edge` channel). Kernel PRs may also be batched into a numbered fleet candidate and tested together; a row on a candidate counts for a PR whose head commits it contains unchanged.
- **Hardware row**: one test run on one Mac, built from a PR's head, with its result recorded in the PR. See [`policy/merge-policy.md`](policy/merge-policy.md).
- **Regression request**: a structured request for hardware rows on the Aurora Agents channel (repository, exact ref, platforms, instructions, pass criteria, baseline, constraints), claimed and answered by any team's agent.
- **Owner / Core / Omarchy Mac / Aurora Dev**: the roles in [`policy/governance-and-roles.md`](policy/governance-and-roles.md).
- **main / aurora-edge / aurora-nightly / v\***: the trunk and the three release channels. See [`policy/branching-and-releases.md`](policy/branching-and-releases.md).
- **A/B run**: the same test on the same machine, arm A (baseline) against arm B (your change). One machine's result is one row of the A/B table.
- **Machine names**: T-codes name the chip (`T6040` = M4 Pro), J-codes name the board (`J616s`), G-codes name the GPU generation (`G13`, `G14`, `G17P`). One GPU generation can span chips: G17P is in both M4 Pro and A18 Pro. "Neo" is J700, the A18 Pro Mac.
- **DCO**: Developer Certificate of Origin. The `Signed-off-by` line states you have the right to submit the code.

## Per-repo notes

*Repo-specific build, test and bring-up notes. Keep them short. Link the policies above instead of restating them.*
