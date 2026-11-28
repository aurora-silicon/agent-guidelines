# Welcome, Maintainers

You're maintainers here (Omarchy Mac or Aurora Maintainers; both teams hold the same rights). You review and merge pull requests on the repositories Omarchy ships and consumes: linux, mesa, aura, m1n1, u-boot, aurora-installer, aurora-platform, alarm-aurora, omarchy-aurora, speakerguardd, alsa-ucm-conf-asahi, asahi-audio and gpubench ([access tiers](../policy/access-tiers.md)). Your approval counts fully, and once a PR meets the merge policy you press the button. You don't need to ask anyone first.

This page is day one. The full rules are in this repo; where this page is short, they win.

## Day 1

1. Read [`AGENTS.md`](../AGENTS.md), the rulebook for humans and agents (10 minutes), and the [pre-PR checklist](../pre-pr-checklist.md).
2. Read the [maintainer guide](README.md) (how fast we answer, no ping-pong), the [daily routine](daily-routine.md) (15 minutes a day) and the [PR review and merging handbook](../policy/review-and-merge-handbook.md). All three are written for you.
3. `git fetch --prune` and base everything on **`main`** (mesa: `aurora-wip` until its cutover). On linux, `integration/aurora` was renamed to `main`; pushes to the old name are blocked.
4. Pick one or two PRs from the [starter queue](#starter-queue) below and review them.
5. If your team runs agents, point them at [`AGENTS.md`](../AGENTS.md) and the [Agents: how to join](../AGENTS.md#agents-how-to-join) section.

## What you can do

- **Review, approve and merge** PRs from anyone (Owners, Core, Aurora Dev, agents) once the merge policy holds.
- **Triage**: label, assign, request reviewers, close duplicates and superseded PRs.
- **Push branches**: `feat/<topic>`, `fix/<topic>`, `wip/<topic>`; open PRs into `main`.
- **Re-run CI and dispatch workflows**, including an edge or nightly rebuild.
- **Ask for hardware rows** on any Mac (below).
- **Change the rules** by opening a PR here; Owners sign it off.

Owners keep a short list: repository settings, rulesets and secrets; cutting `v*` releases and moving release tags; pushing or force-pushing `main`; private repos.

## Merging

A PR merges as soon as it has:

1. green CI (mesa has no CI gate; there the hardware row is the gate),
2. a **hardware row at the PR head**: the change ran on the Mac it targets (plus required coverage for shared blocks and two-family smoke where applicable, per the [merge policy](../policy/merge-policy.md)), with the result written in the PR; or "no runtime change" for docs and CI-only changes,
3. **one approving review** from a Core, Omarchy Mac or Aurora Maintainers member other than the author, with no blocking finding.

Merge it that same hour. Nits become follow-up PRs. On linux use a merge commit (squash and rebase are disabled). You may merge your own PR once someone else approved it.

**Aurora Dev PRs:** Aurora Dev members develop on branches and open PRs, but GitHub doesn't let them merge into default branches. A ready Aurora Dev PR waits for you or Core: merging it is the point of the role.

Changes to `.github/`, `arch/arm64/configs/aurora_defconfig`, `RELEASES.md` or `CONTRIBUTING.md` on linux, and every PR in this repo, also need an Owner's review (CODEOWNERS).

## Hardware rows

If you have the Mac, run it there and post the row. If you don't:

- post a **regression request** on the Aurora Agents channel (repository, exact head SHA, platforms, instructions, pass criteria, baseline, constraints); any team's agent with that Mac claims it and posts the result on the PR;
- or ask in the PR or on Discord for a row on the lab Macs (the [gate Macs](../policy/branching-and-releases.md#gate-macs));
- for a board nobody has, a row on the closest Mac with the same SoC family is accepted when the PR says what it stands in for.

## Releases (what to ship)

| Channel | Ref | Use |
| --- | --- | --- |
| stable | latest `v*` release (`releases/latest`) | the default kernel package |
| nightly | `aurora-nightly` prerelease | testers |
| edge | `aurora-edge` prerelease | every merge to `main` |

This is the target. Until the first `v*` release is published, distribution trackers build from a pinned commit on `main` ([branching, section 3](../policy/branching-and-releases.md#3-release-channels)). Pin the tag **and** the commit SHA from the release body. Stable tags are cut by the Owners from a nightly that passed the release-candidate cross-check on the gate Macs, and never wait for unfinished features. A stable release never changes: a serious bug (boot failure, data loss, security, hardware risk) gets a hotfix release ([`hotfix.md`](../policy/hotfix.md)); everything else is fixed on `main` and ships next time.

Bug reports from your users: an issue in the repo concerned, one issue per Mac, with the release tag or commit they installed.

## Reviewer rotation

PRs request Core, Omarchy Mac and Aurora Maintainers reviews automatically (CODEOWNERS). Each day one Core member and one Omarchy Mac or Aurora Maintainers member are first responders: sweep the open PRs in your repos, review what's ready, merge what meets the gate, and say FINISH / HOLD / CLOSE on the rest ([handbook, section 8](../policy/review-and-merge-handbook.md#8-triage-outcomes)). Agree the order in the maintainers' Discord channel; if you can't take a day, swap it there. GPU changes (`drivers/gpu/drm/asahi`, Mesa `src/asahi`): ask the GPU code owner (CODEOWNERS) for a review when the change is non-trivial.

## Starter queue

Open PRs in your repos that need a first review (as of 2026-11-24; check the PR's current state first):

| PR | Area | Why it's a good start |
| --- | --- | --- |
| [alarm-aurora#441](https://github.com/aurora-silicon/alarm-aurora/pull/441) | Arch packaging | the kernel tracker follows linux `main`; core to Omarchy |
| [asahi-audio#35](https://github.com/aurora-silicon/asahi-audio/pull/35) | audio, MacBook Air 15" M4 | community PR: the J715 microphone array |
| [alsa-ucm-conf-asahi#23](https://github.com/aurora-silicon/alsa-ucm-conf-asahi/pull/23) | audio, MacBook Air 15" M4 | community PR: J715 microphones (pairs with the one above) |
| [alsa-ucm-conf-asahi#22](https://github.com/aurora-silicon/alsa-ucm-conf-asahi/pull/22) | audio | community PR: J704 jack and microphones |
| [asahi-audio#37](https://github.com/aurora-silicon/asahi-audio/pull/37) | audio, J415 | small microphone gain change |
| [asahi-audio#36](https://github.com/aurora-silicon/asahi-audio/pull/36) | audio, WirePlumber | let the built-in card power off when unused |
| [mesa#906](https://github.com/aurora-silicon/mesa/pull/906) | rusticl | small: device discovery alias |
| [mesa#877](https://github.com/aurora-silicon/mesa/pull/877) | compiler | Aurora Dev PR: trims unused load channels |
| [mesa#905](https://github.com/aurora-silicon/mesa/pull/905) | Borealis | per-pipeline robustness fix |
| [linux#3055](https://github.com/aurora-silicon/linux/pull/3055) | GPU, M2 | firmware progress checks; CI green |
| [linux#2981](https://github.com/aurora-silicon/linux/pull/2981) | GPU, M5 | CI green |
| [linux#3024](https://github.com/aurora-silicon/linux/pull/3024) | GPU, M5 | CI green |
| [gpubench#24](https://github.com/aurora-silicon/gpubench/pull/24) | benchmarks | dashboard data, no runtime change |

## Who to ask

- Code: comment on the PR or issue.
- Policy, permissions, releases, anything blocking you: the Owners ([governance](../policy/governance-and-roles.md#1-roles)), on Discord or in an issue here.
- Security: privately, never in a public issue ([`SECURITY.md`](https://github.com/aurora-silicon/.github/blob/main/SECURITY.md)).

Welcome aboard. We're glad you're here.
