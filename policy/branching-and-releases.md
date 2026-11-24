# Branching and Releases

> **Status: IN USE** (since 2026-11-24). Applies to `aurora-silicon/linux` now. Other repos (aura, mesa, u-boot, distribution repos) move to the same model one at a time; until a repo has moved, its README says which branch to target.

Kind: hard rules where marked, otherwise defaults. Roles are defined in [`governance-and-roles.md`](governance-and-roles.md); the merge gate is [`merge-policy.md`](merge-policy.md); the hotfix path is [`hotfix.md`](hotfix.md). A repo's own `RELEASES.md` (for the kernel: [`linux/RELEASES.md`](https://github.com/aurora-silicon/linux/blob/main/RELEASES.md)) adds the build details for that repo and links back here for the rules.

## 1. One trunk: `main`

- **Hard rule.** `main` is the only long-lived branch and the only branch work lands in. There are no release branches, no `next`/integration branches and no per-platform or per-team tracks.
- **Hard rule.** `main` changes only by a merged pull request. No direct pushes, no force pushes, no deletion, no rebasing `main` in place. This is enforced by a ruleset.
- `integration/aurora` was renamed to `main` on 2026-11-24 (same history). It and the old `aurora-wip` are retired: pushes to them are blocked. Target `main`.

## 2. Branch names

| Prefix | Use | Who creates it | Lifetime |
| --- | --- | --- | --- |
| `feat/<topic>` | new work, opened as a PR into `main` | anyone with write access | until merged, then deleted |
| `feat/<area>-<name>` | topic branch for a large feature that needs several PRs (see 2.1) | anyone with write access, agreed in the tracking issue | until it lands on `main` as one PR, then deleted |
| `fix/<topic>` | a fix, opened as a PR into `main` | anyone with write access | until merged, then deleted |
| `wip/<topic>` | parked work with no PR yet; never merged from directly | anyone with write access | open a `feat/`/`fix/` PR when ready; idle more than 7 days moves to `archive/` |
| `archive/<name>` | old branches kept for their history | Owners only (ruleset) | permanent, read-only |
| `rebase/v<version>` | the one branch for an upstream version upgrade (see 2.2) | Owners or Core | until merged, then deleted |
| `hotfix/v<X.Y.Z>` | a stable hotfix (see [`hotfix.md`](hotfix.md)) | Owners only (ruleset) | until the forward-port merges, then deleted |

- Work from a fork is welcome and follows the same rules; the PR targets `main`.
- Name branches after the change, not the person or the tool (`fix/dcp-hpd-race`, not `alice/wip2`).
- Merged branches are deleted. Start new work from a fresh branch off `main`; never reuse a merged branch.
- **Hard rule.** Never delete, rename or push to another person's branch without their agreement. (Owners may archive idle branches; nothing is lost, see `archive/`.)
- **Hard rule. No force pushes to shared branches.** Shared means `main`, `archive/`, `hotfix/`, `rebase/`, any topic branch, and any branch that has an open PR, a review or work stacked on it. Fix review findings with new commits. A branch only you have ever seen may be rewritten before you push it.

### 2.1 Large features

A feature that needs several PRs uses a `feat/<area>-<name>` topic branch. The parts are reviewed as PRs into the topic branch, the whole is regression-tested there, and it lands on `main` as **one** PR that meets the merge policy. The topic branch is then deleted. Keep it short-lived: merge `main` into it (do not rebase it) when it falls behind.

Do not build long chains of PRs stacked on each other. If you must stack, retarget the stacked PRs to `main` before their base merges (deleting a merged base branch closes PRs still stacked on it).

### 2.2 Upstream updates

- **Stable point releases** of the current upstream base (for example `7.3.y`) are merged into `main` weekly through a PR, and at once when they carry security fixes.
- **A new upstream version** (for example 7.4) is done on one branch, `rebase/v7.4`, opened as a PR into `main`. It is built and fleet-tested like any other change and merged when it passes. Only fixes needed for the rebase itself go on that branch; nobody stacks other work on it. `main` is never rebased in place.

## 3. Release channels

Every release is built by CI from a commit on `main` (hotfix tags are the one exception, see [`hotfix.md`](hotfix.md)). Every release body names the exact commit it was built from.

| Channel | Ref | Built when | Mutable? | For |
| --- | --- | --- | --- | --- |
| **edge** | prerelease tag `aurora-edge` | every push to `main` (a newer push cancels a running build) | tag and assets replaced every build | testing what just merged; lab Macs |
| **nightly** | prerelease tag `aurora-nightly` | once a day, if `main` moved since the last nightly | replaced every night | the candidate pool for the next stable tag |
| **stable** | `v<X.Y.Z>` tags, GitHub Release (`releases/latest`) | a `v*` tag is pushed | **never**: a stable release is not rebuilt, edited or re-tagged | what distributions ship by default |

- **Hard rule.** Only CI moves `aurora-edge` and `aurora-nightly`. Only Owners create `v*` tags. Nobody moves or deletes a `v*` tag. Enforced by a tag ruleset.
- Packages pin a tag **and** its commit SHA: `linux-aurora` follows the latest `v*`, `linux-aurora-nightly` follows `aurora-nightly`, `linux-aurora-edge` follows `aurora-edge`.
- Lab Macs run edge (the merged tips). A lab build that is not from a merged tip is temporary proof only; the change lands as a PR and the Mac goes back to edge.

## 4. Cutting a stable release

Stable releases are time-boxed, not feature-boxed.

1. Take the commit an `aurora-nightly` was built from.
2. **Regression gate.** It boots and passes the lab regression suite on all seven lab Macs (M1 Pro, M2 Air, M2 mini, M3 Air, M4 Air, M4 Pro, Neo) with **no new failures** compared with the previous stable release. The gate looks for regressions only.
3. An Owner tags it (`git tag -a vX.Y.Z -m 'Aurora vX.Y.Z' <sha>`) and pushes the tag. CI builds and publishes the release.

- **Hard rule. Never hold a `v*` tag for unfinished work.** Unfinished work is simply not on `main` yet; it ships in the next release. A tag waits only for a regression found by the gate.
- Version numbers: `X.Y.Z` with Y bumped for a regular release and Z for a hotfix. A new upstream base is a minor bump at least.

## 5. Other repos

The same model (one trunk `main`, `feat/`/`fix/` PRs, three channels, `v*` tags cut by Owners) is the target for aura, mesa (whose working branch is `aurora-wip` today), u-boot and the distribution repos. Until a repo moves, target the default branch shown on GitHub. Tag every shipped build in aura and mesa as well, so a release can name the exact bootloader and Mesa it was tested with.
