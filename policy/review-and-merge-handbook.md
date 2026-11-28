# PR Review and Merging Handbook

> **Status: IN USE** (since 2026-11-24). For **Core**, **Omarchy Mac** and **Aurora Maintainers** members, the people who review and merge. The rule itself is [`merge-policy.md`](merge-policy.md); this page is how to apply it. Where they differ, `merge-policy.md` wins.

You can merge. This page is here so you can do it confidently and quickly, without asking anyone first.

## 1. What you can do

On the repos where you hold maintain (Omarchy Mac, Aurora Maintainers) or admin (Core), see [`access-tiers.md`](access-tiers.md):

- **review, approve and merge** any PR that meets the merge policy, including Owners', Core's, Aurora Dev's and agents' PRs. Your approval counts fully;
- **triage**: label, assign, request reviewers, close duplicates and superseded PRs, ask for changes;
- **re-run CI** and dispatch workflows (an edge or nightly rebuild included);
- **ask for hardware rows** on the lab Macs (section 4);
- **propose policy changes** by PR to this repo.

What stays with the Owners is short: repository settings and rulesets, secrets, cutting `v*` releases and moving release tags, pushing or force-pushing a default branch, and private repos.

## 2. The merge gate in one screen

A PR merges as soon as **all three** hold ([`merge-policy.md`](merge-policy.md), section 1):

1. **CI green** on the head commit.
2. **A hardware row at the head**, or "no runtime change" for docs, comments and CI-only changes.
3. **One approving review** from a Core, Omarchy Mac or Aurora Maintainers member who is not the author, with no blocking finding.

Then merge **within the hour**. Nits never hold a merge; they become follow-up PRs.

## 3. How to review

Read the whole diff. Your job is to try to break it, quickly.

1. **No copyrighted Apple material (hard).** No verbatim Apple code, decompiled or disassembled listings, copied symbol dumps, firmware or tuning files anywhere in the diff (source, tools, tests, kits). RE-derived drivers and interface layouts written as our own code with named fields are welcome; a pasted listing or unexplained table copied from a binary is a stop. ADT/DT values read from a machine are hardware facts and fine. [`ip-and-tainted-data.md`](ip-and-tainted-data.md)
2. **No gates, no hacks (hard).** No `if chip == …`, board or firmware-version checks where a DT/ADT property, compatible or capability bit can decide. No new command-line or module parameters, sleeps over races, magic depths or "set X=1 to enable". Pre-PR checklist: [no model gating](../pre-pr-checklist.md#no-model-gating-hard), [no hacks](../pre-pr-checklist.md#no-hacks-hard).
3. **Safety (hard).** Limits that protect hardware come from the machine, never from constants. Speaker changes keep protection running and gating. No boot-object (Stage 1) change without the machine's owner.
4. **Commits (hard).** Human identity and a human `Signed-off-by` on every commit; no agent trailers; third-party commits unchanged. No AI attribution anywhere in commits or PR text (no `Assisted-by`, tool `Co-Authored-By`, "Generated with"): delete it from the PR text yourself; for commits, give the author the fix in the [maintainer guide](../maintainers/README.md#ai-attribution-there-is-nothing-to-add), in the same review.
5. **Evidence.** The hardware row is at the PR head (compare the SHA), on the Mac the change targets, plus one other Mac with the same block for shared code. The numbers are in the PR. Check the [hardware row and regression requirements](merge-policy.md#3-hardware-rows), including two-family smoke coverage where required and proof that a combined build carries the PR unchanged.
6. **Scope.** One topic per PR. No duplicate of someone else's open work: if another PR does the same thing, ask which one carries on.

Then post the verdict.

## 4. Hardware rows

A **hardware row** is one test run on one Mac, built from the PR's head commit, with its result written in the PR. Format: [`merge-policy.md`](merge-policy.md), section 3.

You do not need to own the Mac. Ask for a row:

- **Aurora Agents regression requests** (preferred). Post a `regression_request` on the Aurora Agents coordination service with: repository, exact ref (head SHA), platforms (chip/board), instructions, pass criteria, baseline, constraints. Any team's agent with a volunteered Mac of that kind claims it and posts the structured result on the PR. Ask an Owner for access to the service.
- **On the PR or on Discord**: ask for a row on the lab Macs. Give a fetchable kit (a release asset or a gist), never a path on someone's machine.
- **No Mac of that board anywhere**: a row on the closest Mac with the same block and code path (same SoC family), saying plainly what it stands in for. Do not wait on volunteers who have not agreed to run it.

A row is not needed for documentation, comments, CI configuration that does not change the built artifact, and CI-only tests.

## 5. Writing the review

One format for every review: [`pr-review.md`](pr-review.md) (verdict at the head SHA, numbered blockers, what you checked, evidence folded). Copy-paste text: [`templates/REVIEW_TEMPLATE.md`](../templates/REVIEW_TEMPLATE.md). Map the verdict to GitHub's state: MERGE = Approve; blockers = Request changes; otherwise Comment.

## 6. Merging

- Press **Merge** (merge commit). On `linux` only merge commits are allowed; elsewhere use the repo's usual method, but never squash or rebase someone else's multi-commit PR (it rewrites their authorship and loses the commit the row tested).
- After merging: the branch is deleted. **Retarget** any PR stacked on it to the default branch **first**: deleting a base branch closes the PRs stacked on it.
- Merge one PR at a time per repository and record how to revert. Revert a regression first, then fix it.

## 7. Special cases

| PR | What changes |
| --- | --- |
| **Aurora Dev PR** | Normal gate. Aurora Dev cannot merge; once it meets the gate, a Core, Omarchy Mac or Aurora Maintainers member merges it. Don't leave a ready Aurora Dev PR waiting: merging it is the point of your role. |
| **Your own PR** | You may merge it yourself once someone else (Core, Omarchy Mac or Aurora Maintainers) approved it and the gate holds. GitHub never lets you approve your own PR. |
| **Agent-written PR** | Require independent adversarial review. If App approval cannot satisfy the code-owner requirement, follow the [six conditions for admin merge](merge-policy.md#admin-merge). |
| **Smaller-model PR** (the author's team says it was written mainly by a smaller, faster model; teams route this in their own review queue) | Its non-author review comes from a human or from a stronger model. Another small-model review is not enough. |
| **Someone else's area or board, or a user-visible default** (default config, boot behaviour, release workflows) | Ask the area's owner to review; if they do not answer within a day, an Owner decides. |
| **CODEOWNERS paths** (`.github/`, release configuration, policy files) | Need an Owner's review (enforced). |
| **Stable hotfix** | Into `hotfix/v<X.Y.Z>`, not `main`. Owners create the branch and tag the release; you may review. [`hotfix.md`](hotfix.md) |
| **Upstream rebase** (`rebase/v<version>`) | One PR, fleet-tested like any change; nobody stacks other work on it. [`branching-and-releases.md`](branching-and-releases.md) |
| **Security fix** | Never in a public PR before the fixed release is out. [`SECURITY.md`](https://github.com/aurora-silicon/.github/blob/main/SECURITY.md) |

## 8. Triage outcomes

Every open PR gets one verdict on the PR: **MERGE**, **FINISH, then merge**, **HOLD** or **CLOSE (superseded by #NNN)** ([`pr-review.md`](pr-review.md)). The daily routine and the readiness labels: [daily routine](../maintainers/daily-routine.md).

## 9. Reviewer rotation

Code owners are requested automatically (`.github/CODEOWNERS` in each repo routes PRs to Core, Omarchy Mac and Aurora Maintainers). To keep the queue moving:

- Each day one Core member and one Omarchy Mac or Aurora Maintainers member are **first responders**: they sweep open PRs in their repos, review what is ready and merge what meets the gate. The rotation is kept in the [maintainer onboarding page](../maintainers/onboarding.md#reviewer-rotation).
- A review request should be answered within hours, and never later than the [response times](../maintainers/README.md#response-times). If you cannot, say so on the PR so someone else picks it up.
- GPU (`drivers/gpu/drm/asahi`, Mesa `src/asahi`): ask the GPU code owner (CODEOWNERS) for a review when the change is non-trivial.
