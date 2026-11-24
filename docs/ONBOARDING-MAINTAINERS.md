# Welcome, Maintainers

You have the **maintain** role on [`aurora-silicon/linux`](https://github.com/aurora-silicon/linux). This page is what you need on day one. The full rules are in this repo; where this page is short, they win.

## Day 1 checklist

1. Read [`AGENTS.md`](../AGENTS.md) (hard rules, 5 minutes) and the [pre-PR checklist](../pre-pr-checklist.md). They apply to humans and agents alike.
2. Read [`policy/merge-policy.md`](../policy/merge-policy.md) and [`policy/governance-and-roles.md`](../policy/governance-and-roles.md), section 2 (what you may and may not do).
3. `git fetch --prune` and base everything on **`main`**. `integration/aurora` was renamed to `main`; pushes to the old name are blocked.
4. Point packages at the release channels, not at a branch (below).

## Working on the kernel

- **Target `main`**, always, from a short-lived branch: `feat/<topic>` or `fix/<topic>`. Park unfinished work on `wip/<topic>`. Large multi-PR features use a `feat/<area>-<name>` topic branch. Details: [`policy/branching-and-releases.md`](../policy/branching-and-releases.md).
- **No force pushes** to `main` or to any branch with an open PR or review. Fix review findings with new commits.
- **Commits:** a human `Signed-off-by` on every commit. No agent trailers in commits (`Co-Authored-By`, `Assisted-by`, agent sign-offs). If an agent helped, end the PR body with one `Assisted-by:` line.
- **No hacks, no gates:** features work on the default kernel command line on every Mac with the hardware, selected by DT/ADT properties, never by chip/board/firmware checks. Safety limits come from the machine.
- **Clean-room only:** nothing derived from Apple binaries, firmware or tuning values in any public repo, PR or issue.

## Merging

A PR into `main` merges as soon as it has:

1. green CI,
2. a **hardware row at the PR head**: the change ran on the Mac it targets (plus one other Mac with the same block for shared code), with the result written in the PR,
3. **one approving review from someone other than the author**, with no blocking finding.

Then merge it that same hour (merge commit; squash and rebase are disabled). Nits become follow-up PRs. You may review, approve and merge anyone's PR that meets this, including ours. You may not merge your own PR without someone else's approval, merge without a hardware row, or push to `main`.

Changes to `.github/`, `arch/arm64/configs/aurora_defconfig`, `RELEASES.md` or `CONTRIBUTING.md` need an Owner's review (CODEOWNERS).

## Hardware rows

If you have the Mac, run it there and post the row. If you don't, ask in the PR or on Discord for a row on our lab Macs (M1 Pro, M2 Air, M2 mini, M3 Air, M4 Air, M4 Pro, Neo); we run them. For a board nobody has, a row on the closest Mac with the same SoC family is accepted when the PR says what it stands in for.

## Releases (what to ship)

| Channel | Ref | Use |
| --- | --- | --- |
| stable | latest `v*` release (`releases/latest`) | `linux-aurora`: what users get by default |
| nightly | `aurora-nightly` prerelease | `linux-aurora-nightly`: testers |
| edge | `aurora-edge` prerelease | `linux-aurora-edge`: every merge to `main` |

Pin the tag **and** the commit SHA from the release body. Stable tags are cut by the Owners from a nightly that passed the regression gate on all seven lab Macs; they never wait for unfinished features. A stable release is never changed: a serious bug in one (boot failure, data loss, security, hardware risk) gets a hotfix release ([`policy/hotfix.md`](../policy/hotfix.md)); everything else is fixed on `main` and ships next time.

Bug reports from your users: issues in `aurora-silicon/linux`, one issue per Mac, with the release tag they installed.

## Who to ask

- Code: comment on the PR or issue.
- Policy, permissions, releases, anything blocking you: the Owners, Ryan (`@RyanTheTide`) and Dj (`@DjDeveloperr`), on Discord or in an issue here.
- Security: privately, never in a public issue ([`SECURITY.md`](https://github.com/aurora-silicon/.github/blob/main/SECURITY.md)).

Welcome aboard.
