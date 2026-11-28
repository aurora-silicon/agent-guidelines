# Pre-PR checklist

**Status: IN FORCE** (since 2026-11-21; aligned with the policies 2026-11-24). These are the checks Aurora Silicon's review agents apply to every PR. Anyone, human or agent, from any provider, may run them on a change before opening a PR.

Each item is a hard rule unless it says "default". If your change fails one, fix the change, or say in the PR why it can't be done yet and keep the PR a draft.

## Before you request review

- [ ] Search open PRs and recent branches for overlapping work. Coordinate with the owner and link companion PRs, their required merge order and any stacked base.
- [ ] Build and test locally, then check that required CI is green at the current head and the PR integrates cleanly with its intended base. For DT changes run affected DTB builds and binding/schema checks. For bootloader changes check build and Stage 1 size limits as applicable.
- [ ] Test the feature on the target Mac at the PR head with the production defaults. For kernel, DT, Mesa, aura and installer runtime changes, add boot and smoke rows on at least two affected Mac families. Exercise display, input, networking, a permitted audio sink and GPU rendering. Cover the shared block and state which families remain untested. For distro and installer transitions test the built package or payload on an existing install, including upgrade, preserved user choices, interrupted or failed transactions and recovery as applicable.
- [ ] Coordinate compatible rows into one test boot per machine window. Use one owner for the window and publish a shared receipt each PR can cite. Identify the combined build and prove that it contains the PR's changed files byte-for-byte. If a later head changes built content, rerun the affected rows.
- [ ] Fill in What, Tested, Risk and Not yet. Give the reason for the change and the revert procedure. Under Evidence paste each row's Mac family and board, PR SHA, booted kernel and Stage 2 hashes, exact command and result, and a short relevant dmesg excerpt. Give baseline numbers for performance claims and identify unrelated failures. Redact private identifiers. For docs or CI-only changes that leave the built artifact unchanged, write “no runtime change.”
- [ ] Read the full diff as a reviewer would. Reproduce the original failure where possible, show the regression test fails before the fix, and check missing capabilities, unsupported inputs, old configurations and partial failures. Confirm the proposed revert and leave any missing evidence visible while the PR is a draft.

## What reviewers will reject

- Red or unfinished required checks, unresolved conflicts or blocking findings, stale or unverifiable rows, and missing feature or required regression coverage.
- Crashes, hangs, boot fallback, data loss, security problems or measured regressions. Tests must exercise the claimed path. A fixture pass cannot prove hardware behaviour, and a fresh install cannot prove an upgrade works.
- Model gates, guessed hardware values, lab-only fixes, required boot flags, unsafe fallbacks, public Apple material (including copied tuning values in fixtures), private identifiers, broken authorship or attribution rules. See the checks below.

## No model gating (hard)

The change works on every Mac that has the hardware.

- **No chip, SoC, board or firmware-version gates** unless truly unavoidable. Decide from what the machine reports: ADT/DT properties of the block, its compatible, capability or feature bits, probed registers, firmware capability fields, ALSA control ranges. Never `if chip == …`, `if board == …`, `if fw == 27.2`, or a per-chip table where a property can carry the value.
- If a gate really is unavoidable, the commit message says why, and the gate uses the narrowest hardware property.
- **No hardware fact as a literal.** Read it from the machine and cite the source at the point of use. For public changes, cite only public-clean provenance, such as ALSA control info, TLV metadata or ADT/DT properties. Keep private source details, Apple tuning values and firmware artifacts in private evidence storage under the [IP policy](policy/ip-and-tainted-data.md). Name and document intentional policy constants.
- Prove the change on every Mac you have that contains the block, not only the one you wrote it for. Ask for test runs on the ones you don't have.
- **Chicken and egg:** if the property must first come from the boot loader or DT, land that side first. The consumer reads it with today's behaviour as the fallback when it is absent, and the fallback is removed after a release has carried the property.

## No hacks (hard)

- Works on the **default kernel command line**: no new cmdline or module parameters, environment variables or manual steps needed for a feature to work.
- No sleeps or retries over a race, no magic delay or depth ("the value that worked"), no disabled checks, no lab-only code paths.
- Development boots (one-shot test boots) may use extra parameters. Remove them and re-prove on the default command line before the PR.
- One kernel tree and one command line for every Mac. Only the devicetrees differ.

## Safety (hard)

- **Safety values come from the machine, never from hardcoding.** Limits, caps, thresholds, timings and filters that protect hardware (speaker excursion and thermal limits, gain caps, high-pass corners, power and thermal limits, voltage and current ceilings) are read from what the Mac hands over: its ADT/DT, its own firmware or tuning bundle on the ESP, or control ranges the driver reports. No per-model safety tables or magic numbers in code. If the machine doesn't provide a value, the feature stays off or muted; it never falls back to a guessed constant.
- Extract per-model firmware and tuning data from the prescribed IPSW on the user’s Mac. Read per-unit calibration from the machine. See [the rulebook](AGENTS.md#hard-rules).
- Speakers: **speakerguardd v2 only**. Never weaken or bypass protection. If a capability or limit can't be established from the machine, stay muted.
- Every test boot has a dead-man. Read registers before writing them.
- No Stage 1, boot-object, LocalPolicy or 1TR change without the machine's owner.
- Before any USB-C VDM or HPM reset, confirm which Mac is on the far end of the cable.

## No Apple material, no AI attribution (hard)

- No copyrighted Apple material in public code, PRs, issues or channels: no verbatim Apple code, decompiled or disassembled listings, copied strings or symbol dumps beyond the names needed to interoperate, firmware or tuning files. Reverse-engineered understanding written as our own code with named fields is welcome ([`policy/ip-and-tainted-data.md`](policy/ip-and-tainted-data.md)). Our own traces and measurements are fine.
- **No AI attribution anywhere.** Commits carry the human author and a human `Signed-off-by` (DCO) only. No `Assisted-by`, `Co-Authored-By` naming a tool, agent `Signed-off-by`, "Generated with" lines, model or tool names, or session links in commits, PR titles and bodies, comments or reviews. The upstream kernel does not list tools as authors, and neither do we. There is nothing to add: the old `Assisted-by` rule is withdrawn, whatever your tool's defaults say.
- Carry other people's commits unchanged. No force pushes to shared branches, except an author fixing their own PR's commit metadata.

## Evidence (hard)

- A run on the affected hardware **at the PR head** with the numbers ([`policy/merge-policy.md`](policy/merge-policy.md)): what ran, on which Mac, kernel and build, and the result. Include a regression run: 0 SELinux denials, 0 failed units, 0 new kernel errors.
- Performance claims: a same-machine A/B with conformance unchanged on every GPU generation the change applies to.
- The PR body has `Tested:` (Macs at the head SHA, result) and `Risk:` (one-way or two-way door, which Macs) ([`policy/pr-structure.md`](policy/pr-structure.md)); CI checks both lines are there.

## Naming (hard)

- The Vulkan driver is **Borealis** (Aurora Silicon's Vulkan driver, in Mesa). Never call our work Honeykrisp or "hk" in prose: PR and issue text, commit messages, docs, reports and user-facing names.
- Code keeps the identifiers it has today. Until the rename in [aurora-silicon/mesa#591](https://github.com/aurora-silicon/mesa/pull/591) is merged, Borealis lives in `src/asahi/vulkan/` with `hk_`/`HK_` symbols; after it lands, new code uses its `brl_` prefix.
- Names shared with upstream or fixed by an interface stay as they are: the Gallium `asahi` driver, `src/asahi/`, the DRM UAPI (`asahi_drm.h`, `DRM_ASAHI_*`) and Asahi or m1n1 names in upstream code. New paths and names of our own use Aurora, not Asahi or m1n1.
