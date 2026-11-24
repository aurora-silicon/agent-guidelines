# Maintainer Handbook: 15 minutes a day

For everyone who reviews and merges: Core and Omarchy Mac. Rules: [merge policy](../policy/merge-policy.md), [PR structure](../policy/pr-structure.md), [review format](../policy/pr-review.md). Same routine whoever you are and whoever wrote the PR.

A bot keeps one comment and a set of labels on every open PR ([what each label means](https://github.com/aurora-silicon/.github/blob/main/docs/pr-readiness.md)). When CI, review, hardware row, change requests and conflicts all pass, the PR gets **`ready-to-merge`**.

## Every day

1. **Merge what's ready (5 min).** Open the ready queue for your area (below). For each PR: the bot comment is all `ok` at the current head; skim the diff once for what a bot can't see (Apple-derived values, a chip/board/firmware gate, a new parameter, a hardcoded safety limit); press **Merge** (merge commit). Owners and Core through the bypass: `gh pr merge <n> --merge --admin`; the bypass skips the button, never the policy.
2. **Review the queue (10 min).** Oldest first. Paste the [review template](../templates/REVIEW_TEMPLATE.md), read the diff, try to break it, post one verdict at the head SHA. If you approved and it turns `ready-to-merge`, merge it now. Need a row you can't run? Ask in the PR, verdict FINISH, move on.
3. **Hand off what needs an Owner (1 min).** One line on the PR mentioning `@RyanTheTide` or `@DjDeveloperr`, then move on: repository settings, rulesets, secrets, teams; `v*` releases and `aurora-*` tags; policy, CI and release files (CODEOWNERS requests them); private repos and anything tainted; a one-way door that changes a user-visible default.

Don't wait for a second reviewer or polish; nits become follow-up issues. A merge that breaks something is reverted by PR first, then diagnosed.

## Labels

| Label | Do |
| --- | --- |
| `ready-to-merge` | Check the comment, merge. |
| `needs-review` | Review it. |
| `needs-hw-row` | Run a row at the head, or ask for one. |
| `changes-requested` | Author fixes; reviewer re-checks only the blockers. |
| `ci-failing`, `merge-conflict` | Author fixes CI, or merges `main` in (never force-push). |
| `hold`, `blocked` | Set by a person (verdict HOLD, or held on purpose); the bot never touches them. Remove when the blocker is gone. |
| `needs-template` | Body lacks `Tested:` / `Risk:`; older PRs adopt it on next edit. |
| `hw-row-ok` | You read the row and it is valid for this head (e.g. a clean rebase); the bot drops it on new commits. |
| `area:*`, `blast:*`, `door:*` | Filter your queue by area, by the Macs you own, by one-way doors. |

A row counts when one line in the PR or a comment has **the head SHA, the Mac and the result**: `J413 M2 Air at 3f2a9c1: boots, 0 failed units`.

## Queues (bookmark yours)

- All repos, ready: https://github.com/pulls?q=is%3Aopen+is%3Apr+org%3Aaurora-silicon+label%3Aready-to-merge
- All repos, needs review: https://github.com/pulls?q=is%3Aopen+is%3Apr+org%3Aaurora-silicon+label%3Aneeds-review+-is%3Adraft+sort%3Acreated-asc
- Requested from Omarchy Mac: https://github.com/pulls?q=is%3Aopen+is%3Apr+org%3Aaurora-silicon+team-review-requested%3Aaurora-silicon%2Fomarchy-m
- Requested from Core: https://github.com/pulls?q=is%3Aopen+is%3Apr+org%3Aaurora-silicon+team-review-requested%3Aaurora-silicon%2Fcore
- linux, M1–M3 platform, ready: https://github.com/aurora-silicon/linux/pulls?q=is%3Aopen+is%3Apr+label%3Aarea%3Aplatform+label%3Aready-to-merge
- linux, M1–M3 platform, needs review: https://github.com/aurora-silicon/linux/pulls?q=is%3Aopen+is%3Apr+label%3Aarea%3Aplatform+label%3Aneeds-review+-is%3Adraft
- linux, touches M2: https://github.com/aurora-silicon/linux/pulls?q=is%3Aopen+is%3Apr+label%3Ablast%3Am2+-is%3Adraft
- mesa, ready: https://github.com/aurora-silicon/mesa/pulls?q=is%3Aopen+is%3Apr+label%3Aready-to-merge

Other repos: swap the repo name; other areas: swap the `area:` label (each repo's `.github/CODEOWNERS` lists its areas). CLI: `gh pr list -R aurora-silicon/linux -l area:platform -l ready-to-merge`.

## Who gets asked

CODEOWNERS requests Core and Omarchy Mac on every PR (either team's approval counts) and adds specialists by area, e.g. Dj on the GPU driver. Both teams load-balance one reviewer per PR; the Owners are left out of the rotation. Omarchy Mac first for M1–M3 platform work and what Omarchy ships, Core for the rest. Picked and can't review within a few hours? Remove yourself so it is reassigned.

## Set up once

Save the [review template](../templates/REVIEW_TEMPLATE.md) as a GitHub saved reply (Settings, Saved replies); bookmark your queues; watch your repos with "Participating, @mentions and review requests" (the bot edits its comment in place, it doesn't notify).

## Examples

**PR** (linux#2150):

```markdown
**What:** a 16" M4 Pro (J616s) on 26.6.2 boot firmware loads a fourth T6040 GPU firmware
image; the probe refuses it and the Mac falls back to software rendering. Admit its digest
and add it to the KUnit lookup case.

**Tested:** J616s M4 Pro at `c268dc5b`: GPU up on two boots, Hyprland on the GPU. J613 M3 Air,
J700 Neo, M1 Pro: no regression, 25-minute GPU soak clean.

**Risk:** two-way · M4 Pro

**Not yet:** M3 Pro, M3 Max, J615.

<details><summary>Details</summary> 27.2 stub is separate work: ... </details>
<details><summary>Evidence</summary> base main a7dd26e6, make W=1, run-host-tests.py ... </details>
```

**Review** (Dj on mesa#927):

```markdown
**Verdict:** FINISH, then merge at `05334c8c`

**Blockers:**
1. `src/asahi/compiler/agx_nir_opt_preamble.c:1081`: without the g17p guard the pass strips
   ACCESS_CAN_SPECULATE from every main-shader load on AGX2 soft-fault devices. Fix: skip loads
   that already carry it in has_speculative_load_candidate() and allow_speculative_load().
2. `src/asahi/vulkan/hk_pack.c:66`: (uint32_t *) cast of a 1-byte-aligned buffer is
   misaligned-store UB. Fix: pack into a local uint32_t array and memcpy.

**Checked:** §1 §3 §4 §6 pass, §2 fail (above), §5 A/B + CTS on G13X–G17P; CI not run at this head.

<details><summary>Evidence</summary> read set_speculate() (agx_compile.c:10644) ...; nits: ... </details>
```

**Issue** (linux#2627, bug form):

```markdown
What happens: `sudo cat /sys/module/aurora/parameters/g17p_diag_knobs` oopses on any Mac
that is not G17P; reading a module parameter should never touch firmware memory.
Mac and build: MacBook Air M2 (J413), main e00fb9a8 / 7.3.0-aurora-fleet76
How to reproduce: run the command above with aurora.ko loaded. Every time.
Logs and evidence: (folded) Oops 0000000096000143 in diag_get+0x208; cause: diag_get() in
g18/compat/timing_buffer.rs probes fixed G17P firmware addresses whatever GPU is bound.
```

The bot is wrong? Say so on the PR, decide by the policy, and open an issue in [`aurora-silicon/.github`](https://github.com/aurora-silicon/.github/issues).
