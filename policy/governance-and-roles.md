# Governance and Roles

> **Status: IN USE** (since 2026-11-24).

Kind: hard rules. Who may do what in `aurora-silicon` repositories, and how GitHub enforces it. Team-to-repository roles are in [`access-tiers.md`](access-tiers.md); the merge gate is [`merge-policy.md`](merge-policy.md); how to review and merge is the [handbook](review-and-merge-handbook.md); branches and releases are [`branching-and-releases.md`](branching-and-releases.md).

Aurora Silicon is the only home of this work. Collaborating projects and distributions consume our releases and contribute through pull requests; nothing moves to another organisation.

## 1. Roles

| Role | Who | GitHub |
| --- | --- | --- |
| **Owner** | Ryan Murray (`@RyanTheTide`) and Dj (`@DjDeveloperr`) | organisation owners |
| **Core** | the `core` team | admin on product repos |
| **Omarchy Mac maintainer** | the `omarchy-m` team | maintain on the repos Omarchy ships or consumes |
| **Aurora Dev** | the `aurora-dev` team | write on product repos |
| **Contributor** | anyone else | read; works from a fork |

**Reviewers and mergers** are Core and Omarchy Mac maintainers. **Developers** are Aurora Dev. Owners are the final decision-makers for policy, releases, repository settings and disputes.

## 2. What each role does

Everyone follows [`AGENTS.md`](../AGENTS.md), the [pre-PR checklist](../pre-pr-checklist.md) and the [merge policy](merge-policy.md), humans and agents alike.

**Omarchy Mac maintainers and Core** review and merge. On their repos they:

- review, **approve and merge** PRs that meet the merge policy, from anyone (Owners', Core's, Aurora Dev's, agents'); their approval is the one the rulesets count;
- triage issues and PRs: labels, milestones, assignees, requesting reviews, closing duplicates and superseded PRs;
- push `feat/`, `fix/` and `wip/` branches; open `rebase/` or upstream-stable PRs when an Owner asks;
- run, re-run and dispatch workflows, including an edge or nightly rebuild;
- request lab hardware rows and regression requests;
- propose policy changes by PR to this repo.

Core also runs the stable regression gate and may merge through the ruleset bypass (pull requests only) when the merge policy holds but GitHub cannot record the approval, for example an agent's PR reviewed by an independent agent on the same account.

**Aurora Dev** develop fast. They:

- push `feat/`, `fix/` and `wip/` branches and open PRs; CI runs on them;
- review and comment on any PR (their review is read and counts as a non-author check, but the approval that unlocks a merge comes from Core or Omarchy Mac);
- re-run CI and request lab rows;
- **do not merge** into default branches (enforced). Once their PR meets the gate, a Core or Omarchy Mac member merges it. Graduating to merge rights: see [`access-tiers.md`](access-tiers.md), section 6.

**Owners** may do everything, and alone: cut `v*` tags and hotfixes, create `archive/` and `hotfix/` branches, change settings, rulesets, secrets and access. Owners follow the merge policy too; their bypass exists to merge reviewed work quickly, not to skip review.

**Nobody but Owners** (whatever GitHub's role would allow):

- changes repository settings, rulesets, branch protection, webhooks, deploy keys, collaborators, Actions settings, secrets or variables;
- pushes or force-pushes to a default branch, or pushes to `archive/` or `hotfix/`;
- creates, moves or deletes `v*` or `aurora-*` tags, or creates, edits or deletes their releases;
- touches private repos without an Owner's grant.

**Nobody at all**: deletes or renames someone else's branch without their agreement; merges their own PR without a non-author approval; merges runtime code without a hardware row; adds tainted data ([`ip-and-tainted-data.md`](ip-and-tainted-data.md)).

## 3. What GitHub's roles allow vs what policy allows

GitHub's `maintain` and `write` roles are broader than policy in places. Rulesets close the gap where GitHub can enforce it; policy plus the audit log cover the rest. State on `aurora-silicon/linux` (other product repos: [`access-tiers.md`](access-tiers.md), section 3):

| Action | `write` (Aurora Dev) | `maintain` (Omarchy Mac) | Policy | Enforced by |
| --- | --- | --- | --- | --- |
| Push / force-push / delete `main` | no | no | no | `main: single trunk` (PR only, no force push, no deletion) |
| Merge a PR into `main` | only once a Core or Omarchy Mac member approved it; by policy a merger presses the button | yes, once approved | Core and Omarchy Mac, when the gate holds | code-owner review (the approval must come from Core or Omarchy Mac); no bypass click needed |
| Merge with no approval, or approved before the last push | no | no | no | 1 approval, last-push approval, stale approvals dismissed |
| Approval that counts | no (advisory) | yes | Core or Omarchy Mac, not the author | code-owner review, `.github/CODEOWNERS` |
| Approve own PR | no | no | no | GitHub |
| Squash- or rebase-merge into `main` | no | no | no (preserves authorship) | merge commits only |
| Change `.github/`, `aurora_defconfig`, `RELEASES.md`, `CONTRIBUTING.md` without an Owner's review | no | no | no | code-owner review |
| Create / move / delete `v*` or `aurora-*` tags | no | no | no | tag rulesets |
| Create or push `hotfix/`, `archive/` | no | no | no | `owner-only branches` |
| Push to `integration/aurora`, `aurora-wip` | no | no | no | `retired` |
| Merge with CI red or running | **yes**, once approved (no required checks yet) | **yes** (no required checks yet) | no | policy; required checks follow the release workflow on `main` |
| Merge without a hardware row | **yes**, once approved | **yes** | no | policy (reviewers check) |
| Change rulesets, protection, environments, webhooks, deploy keys, collaborators, visibility | no | no | no | admin only |
| Create, overwrite or delete Actions secrets (values cannot be read back) | **yes** | **yes** | no | policy + audit log; release credentials live only in the admin-managed `release` environment |
| Edit description and topics, enable wiki or discussions, PR merge settings, Pages source | no | **yes** | no | policy + audit log |
| Create, edit or delete a release on an unprotected tag; edit a `v*` release object | **yes** | **yes** | no | policy + audit log (the `v*` tag itself cannot move) |
| Delete or rename someone else's unprotected branch | **yes** | **yes** | no | policy + audit log |
| Add tainted data | **yes** | **yes** | never | policy; reviewers check the whole diff |

Bypass: the Owners and the Core team bypass the branch rulesets **only through a pull request**; even they cannot push straight to `main`. Omarchy Mac need no bypass: their approval satisfies code-owner review, and their merges go through the normal button. (A restrict-updates ruleset that made every merge a bypass click was tried and disabled on 2026-11-24.) Tag and owner-only branch rulesets are bypassed by Owners (and, for `aurora-*` tags only, by a deploy key in the admin-managed `release` environment). GitHub does not let a workflow token bypass a repository ruleset.

The rulesets are the source of truth for what is enforced; this table is updated whenever they change.

## 4. Changing policy

- Anyone proposes a change by PR to this repo. Maintainers and agents review it like any PR.
- **Owner-level changes** (roles and permissions, the merge gate, release and hotfix rules, access tiers, anything that widens or narrows what a role may do) need a **human Owner's sign-off** on the PR: Ryan or Dj approving it themselves. An agent review, even one posted from an Owner's account, does not stand in for it. A change one Owner made alone is confirmed by the other Owner, or reverted, within a week.
- Wording fixes, links and examples follow the normal merge policy (CODEOWNERS still asks an Owner).

## 5. Raising problems

- Code questions: comment on the PR or issue.
- A policy question or a disagreement with a review: open an issue in this repo, or ask an Owner. An Owner decides.
- Security reports: privately, see [`SECURITY.md`](https://github.com/aurora-silicon/.github/blob/main/SECURITY.md). Never in a public issue.
- A rule seems wrong for your case: stop and ask an Owner (hard rules), or deviate and say why in the PR (defaults).

## 6. Changing roles

Owners add and remove people. Core proposes promotions ([`access-tiers.md`](access-tiers.md), section 6). Someone who repeatedly breaks a hard rule loses the role; a single honest mistake is fixed (revert, follow-up PR) and explained, not punished.
