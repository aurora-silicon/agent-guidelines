# Access Tiers

> **Status: IN USE** (since 2026-11-24). Applied by [`tools/gh-access-apply.sh`](../tools/gh-access-apply.sh).

Kind: hard rules. Which GitHub team gets which role on which repository, and which rulesets every public product repository carries. What each role may do under policy is [`governance-and-roles.md`](governance-and-roles.md); how to review and merge is the [review and merging handbook](review-and-merge-handbook.md).

## 1. The three teams

| Team | Who they are | What they do here |
| --- | --- | --- |
| **Core** (`@aurora-silicon/core`) | the Owners plus the core developers | review and merge everywhere; the only ruleset bypass actor (through pull requests only) |
| **Omarchy Mac** (`@aurora-silicon/omarchy-m`) | the Omarchy Mac maintainers | review and merge on the repositories Omarchy ships or consumes |
| **Aurora Dev** (`@aurora-silicon/aurora-dev`) | Aurora developers | develop fast: branches, PRs, CI, lab rows, reviews; they do not merge into default branches |

Everyone, in every team, is bound by the same rules: the [merge policy](merge-policy.md), the [pre-PR checklist](../pre-pr-checklist.md) and the [IP and tainted-data policy](ip-and-tainted-data.md). Owners and agents included.

## 2. Roles per repository class

| Repository class | Core | Omarchy Mac | Aurora Dev |
| --- | --- | --- | --- |
| **Omarchy product repos**: linux, mesa, aura, m1n1, u-boot, aurora-installer, aurora-platform, alarm-aurora, omarchy-aurora, speakerguardd, alsa-ucm-conf-asahi, asahi-audio, gpubench, agent-guidelines | admin | **maintain** (review + merge) | write |
| **Other public product repos**: aurora-distributions, fedora-aurora, nixos-aurora, aurora-diag, aurora-sep-userspace, camera-denoise, kbd-light, upower, xserver, pipewire, FFmpeg, libva-v4l2_request, fex, macvdmtool, tuxvdmtool, aurora-bless, mil-hwx-compiler, splash, aurora-steam-native, aurora-lily, aurora-xart, aurora-neo-platform-config, avd-fw, capture-ns, .github, aurora-silicon.github.io | admin | (public read; PRs from a fork are welcome) | write |
| **Other public repos** (archives, mirrors, stale forks) | admin where an Owner grants it | public read | public read |
| **Private repos** (tainted or internal) | per repo, decided by an Owner | **never** | none by default; an Owner grants per repo |

A repository is a product repo when it is live (pushed in the last two months, not archived) and something we ship or build from. Adding a repo to a class is a PR to this page and to `tools/gh-access-apply.sh`.

In `agent-guidelines` itself every PR also needs an Owner's review (CODEOWNERS): Maintainers open and review policy PRs, Owners sign them off.

## 3. Rulesets on every public product repo

The same three repository rulesets, on the repo's **default branch** whatever it is called (`main`, or `aurora-wip` on mesa until its trunk cutover):

| Ruleset | Rules | Bypass |
| --- | --- | --- |
| `default branch: reviewed PRs` | no deletion, no force push; changes by PR with **1 approving review**, approval after the last push, stale approvals dismissed, **code-owner review** | Owners and Core, **through a pull request only** |
| `default branch: mergers only (Core, Omarchy Mac)` | restrict updates: only bypass actors may update the branch, which includes merging a PR | Owners, Core, and Omarchy Mac where they hold maintain; **through a pull request only** |
| `release tags: v* aurora-* (owners only)` | `v*` and `aurora-*` tags cannot be created, moved or deleted | Owners |

Each repo carries `.github/CODEOWNERS` with `* @aurora-silicon/core @aurora-silicon/omarchy-m` (Core only where Omarchy Mac has no role). With code-owner review on, the one approval that counts must come from **Core or Omarchy Mac**. An Aurora Dev review is welcome and is read, but it does not satisfy the requirement alone.

What that means in practice:

- **Aurora Dev** push `feat/`, `fix/` and `wip/` branches, open PRs, re-run CI and review. GitHub refuses their merge button on a default branch.
- **Omarchy Mac** (on their repos) and **Core** merge a PR once the [merge policy](merge-policy.md) holds and a Core or Omarchy Mac member other than the author has approved it.
- **Nobody** pushes straight to a default branch, force-pushes it or deletes it. Owners and Core bypass the review requirement only by merging a pull request, and only when the merge policy holds (for example: an agent's PR reviewed by an independent agent, which cannot press GitHub's approve button on the same account).
- The kernel (`linux`) has stricter rulesets on top: merge commits only, owner-only `hotfix/` and `archive/` branches, retired branch names locked. See [`governance-and-roles.md`](governance-and-roles.md), section 3.

## 4. Repos not fully covered yet

Some repos run workflows that push to the default branch or create release tags with the workflow token. GitHub does not let that token bypass a repository ruleset, so those rulesets are deferred until the workflow moves to a pull request or a deploy key:

| Repo | Deferred | Why |
| --- | --- | --- |
| aurora-distributions | branch rulesets, tag ruleset | adoption workflows push to `main`; payload workflow creates release tags |
| fedora-aurora, alarm-aurora | branch rulesets, tag ruleset | the Firefox tracker merges its proposal into `main`; publish workflows create release tags |
| .github | branch rulesets | the Discord sync workflow pushes to `main` |
| aurora-installer, nixos-aurora, omarchy-aurora | tag ruleset | publish workflows create release tags |

Until then the policy still applies there: Aurora Dev do not merge into the default branch.

Repos whose default branch is not `main` yet (protected as they are, trunk cutover pending): mesa (`aurora-wip`), FFmpeg, pipewire, aurora-bless (`master`), libva-v4l2_request (`avd-fixes`). `recovery-ssh` (`j813`, idle since September) is treated as an archive.

## 5. Limits of the free plan

The organisation is on GitHub's free plan:

- rulesets and branch protection work only on **public** repositories; private repos have none, so access to them is kept narrow;
- there are no organisation-wide rulesets, so `tools/gh-access-apply.sh` writes the same rulesets into each repo.

A paid organisation plan would add organisation rulesets (one place, new repos covered automatically) and protection on private repos. That is an Owner decision.

## 6. Changing access

- Owners add and remove people and teams, and run `tools/gh-access-apply.sh` (dry run first; it logs every change).
- An Aurora Dev member who has reviewed and landed work well over time can be proposed for Core or a maintainer role by any Core member; Core decides, an Owner applies it.
- New repositories are created by Owners (recommended organisation setting: members cannot create repositories).
