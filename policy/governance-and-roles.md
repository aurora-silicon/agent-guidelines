# Governance and Roles

> **Status: IN USE** (since 2026-11-24).

Kind: hard rules. Who may do what in `aurora-silicon` repositories, and how GitHub enforces it. The merge gate itself is [`merge-policy.md`](merge-policy.md); branches and releases are [`branching-and-releases.md`](branching-and-releases.md).

Aurora Silicon is the only home of this work. Collaborating projects and distributions consume our releases and contribute through pull requests; nothing moves to another organisation.

## 1. Roles

| Role | Who | GitHub role |
| --- | --- | --- |
| **Owner** | Ryan Murray (`@RyanTheTide`) and Dj (`@DjDeveloperr`) | organisation owner, repo admin |
| **Core** | members of the `core` and `aurora-dev` teams | `core`: repo admin on the kernel; `aurora-dev`: write |
| **Maintainer** | members of the `omarchy-m` team (Omarchy Mac maintainers) | maintain |
| **Contributor** | anyone else | read; works from a fork |

Owners are the final decision-makers for policy, releases, repository settings and disputes. Policy changes are made by PR to this repo and merged by an Owner.

## 2. What each role may do

Everyone follows [`AGENTS.md`](../AGENTS.md), the [pre-PR checklist](../pre-pr-checklist.md) and [`merge-policy.md`](merge-policy.md). On top of that:

**Maintainers may:**

- review, approve and merge pull requests **that meet the merge policy** (including Core's and Owners' PRs);
- triage issues and PRs: labels, milestones, assignees, closing duplicates, requesting reviews;
- push `feat/`, `fix/` and `wip/` branches in the repository;
- run, re-run and cancel workflows;
- open `rebase/` or upstream-stable PRs when an Owner or Core member asks.

**Maintainers may not** (whether or not GitHub would allow it):

- change repository settings, rulesets, branch protection, webhooks, deploy keys, collaborators, Actions settings, secrets or variables;
- push or force-push to `main`, or push to `archive/` or `hotfix/` branches;
- create, move or delete `v*` or `aurora-*` tags, or create, edit or delete their releases;
- delete or rename other people's branches;
- merge their own PR without an approving review from someone else, or approve a PR they pushed to last;
- merge a PR without the hardware row the merge policy asks for;
- add tainted data anywhere ([`ip-and-tainted-data.md`](ip-and-tainted-data.md)).

**Core** may do everything a Maintainer may, plus open `rebase/` PRs and run the stable regression gate. Core members with admin access do not change settings or rulesets without an Owner's agreement.

**Owners** may do everything, and alone may: cut `v*` tags and hotfixes, create `archive/` and `hotfix/` branches, change settings and rulesets, add or remove people. Owners follow the merge policy too; their ruleset bypass exists so they can merge reviewed work quickly, not to skip review (see [`merge-policy.md`](merge-policy.md), section 4).

## 3. What GitHub's roles allow vs what policy allows

GitHub's `maintain` role is broader than the Maintainer policy. The gap is closed by rulesets where GitHub can enforce it, and by this policy plus the audit log where it cannot. Current state of `aurora-silicon/linux`:

| Action | GitHub `maintain` can? | Policy | Enforced by |
| --- | --- | --- | --- |
| Push to / force-push / delete `main` | no (ruleset) | no | ruleset `main: single trunk` |
| Merge a PR into `main` with no approval, or approved before the last push | no (ruleset) | no | ruleset: 1 approval, last-push approval, stale approvals dismissed |
| Approve own PR | no (GitHub never allows it) | no | GitHub |
| Squash- or rebase-merge into `main` | no (ruleset) | no (preserves authorship) | ruleset: merge commits only |
| Change files listed in `CODEOWNERS` (`.github/`, `aurora_defconfig`, `RELEASES.md`, `CONTRIBUTING.md`) without an Owner's review | no (ruleset) | no | ruleset: code-owner review |
| Create / move / delete `v*` or `aurora-*` tags | no (ruleset) | no | tag rulesets |
| Create or push to `hotfix/`, `archive/` branches; delete them | no (ruleset) | no | ruleset `owner-only branches` |
| Push to `integration/aurora`, `aurora-wip` | no (ruleset) | no | ruleset `retired` |
| Merge a PR whose CI is red or still running | **yes** (no required status checks yet) | no | policy (reviewers and mergers check); required checks are added to the `main` ruleset once the release workflow is on `main` |
| Change rulesets, branch protection, environments, webhooks, deploy keys, collaborators, visibility; delete the repo | no (admin only) | no | GitHub role |
| Create, overwrite or delete repository Actions secrets (values cannot be read back) | **yes** (write and maintain both can) | no | policy + audit log; release credentials live only in the admin-managed `release` environment |
| Edit description, topics and social card; enable wiki or discussions; configure PR merge settings; set the Pages source; limit interactions | **yes** | no | policy + audit log (the `main` ruleset still allows only merge commits) |
| Create, edit or delete a release on a non-protected tag; edit or delete the release object of a `v*` tag | **yes** | no | policy + audit log (the `v*` tag itself cannot be moved) |
| Delete or rename someone else's unprotected branch | **yes** | no | policy + audit log |
| Merge a PR that has no hardware row | **yes** | no | policy (reviewers check) |
| Push a branch whose workflow asks for a write token and publishes a release under some other tag name | **yes** | no | policy + audit log (release tags themselves are protected) |
| Add tainted data | **yes** | no, never | policy; reviewers check the whole diff |

Owners bypass the `main` ruleset only through a pull request (`bypass_mode: pull_request`): even an Owner cannot push directly to `main`. The tag and owner-only branch rulesets are bypassed by Owners and, for `aurora-*` tags only, by deploy keys with write access (only admins add deploy keys; the release workflow's key lives in the admin-managed `release` environment, restricted to `main`). GitHub does not let `GITHUB_TOKEN` bypass a repository ruleset, so a workflow on any other branch cannot move release tags. Core admins who are not organisation owners do not bypass.

The rulesets are the source of truth for what is enforced; this table is updated whenever they change.

## 4. Raising problems

- Code questions: comment on the PR or issue.
- A policy question or a disagreement with a review: open an issue in this repo, or ask an Owner. An Owner decides.
- Security reports: privately, see [`SECURITY.md`](https://github.com/aurora-silicon/.github/blob/main/SECURITY.md). Never in a public issue.
- A rule seems wrong for your case: stop and ask an Owner (hard rules), or deviate and say why in the PR (defaults).

## 5. Changing roles

Owners add and remove people. A Maintainer who repeatedly breaks a hard rule loses the role; a single honest mistake is fixed (revert, follow-up PR) and explained, not punished.
