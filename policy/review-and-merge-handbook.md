# PR Review and Merging Handbook

> **Status: IN USE** (since 2026-11-24). For **Core** and **Omarchy Mac** members, the people who review and merge. The rule itself is [`merge-policy.md`](merge-policy.md); this page is how to apply it. Where they differ, `merge-policy.md` wins.

You can merge. This page is here so you can do it confidently and quickly, without asking anyone first.

## 1. What you can do

On the repos where you hold maintain (Omarchy Mac) or admin (Core), see [`access-tiers.md`](access-tiers.md):

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
3. **One approving review** from a Core or Omarchy Mac member who is not the author, with no blocking finding.

Then merge **within the hour**. Nits never hold a merge; they become follow-up PRs.

## 3. How to review

Read the whole diff. Your job is to try to break it, quickly.

1. **Clean-room (hard).** Nothing derived from Apple binaries, firmware or tuning values anywhere in the diff (source, tools, tests, kits). Bare hex tables that look like firmware words are a stop. ADT/DT values read from a machine are hardware facts and fine. [`ip-and-tainted-data.md`](ip-and-tainted-data.md)
2. **No gates, no hacks (hard).** No `if chip == …`, board or firmware-version checks where a DT/ADT property, compatible or capability bit can decide. No new command-line or module parameters, sleeps over races, magic depths or "set X=1 to enable". [Pre-PR checklist](../pre-pr-checklist.md), items 1 and 2.
3. **Safety (hard).** Limits that protect hardware come from the machine, never from constants. Speaker changes keep protection running and gating. No boot-object (Stage 1) change without the machine's owner.
4. **Commits (hard).** Human identity and a human `Signed-off-by` on every commit; no agent trailers; third-party commits unchanged. The PR body may end with one `Assisted-by:` line (never nitpick its wording).
5. **Evidence.** The hardware row is at the PR head (compare the SHA), on the Mac the change targets, plus one other Mac with the same block for shared code. The numbers are in the PR. A rebase with no conflicts in the touched files keeps the row valid; anything else needs a new row.
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

Use GitHub's review states, in the format Aurora's review waves use:

- **Approve**: "No blocking findings." plus one line on what you checked (for example "clean-room, gates, row at `abc1234` on J616s + regression on J413").
- **Request changes**: a numbered list of **blocking** findings, each with the file/line, what is wrong and what would fix it. Then a separate **Non-blocking** list. Say which is which; a reviewer who mixes them holds merges for nits.
- **Comment**: questions, or a partial review.

A blocking finding is: a crash, hang, data loss, boot fallback or security problem; a regression on any Mac; a hard-rule break (tainted data, an agent trailer, a gate or parameter, a hardcoded safety limit); missing or stale evidence. Everything else is non-blocking.

Comment on the code, not on people or internal process. If you hold a PR for a reason outside the code, keep the public note neutral.

## 6. Merging

- Press **Merge** (merge commit). On `linux` only merge commits are allowed; elsewhere use the repo's usual method, but never squash or rebase someone else's multi-commit PR (it rewrites their authorship and loses the commit the row tested).
- After merging: the branch is deleted. **Retarget** any PR stacked on it to the default branch **first**: deleting a base branch closes the PRs stacked on it.
- A merge that turns out to break something is **reverted by PR first**, then diagnosed, or fixed forward the same day.

## 7. Special cases

| PR | What changes |
| --- | --- |
| **Aurora Dev PR** | Normal gate. Aurora Dev cannot merge; once it meets the gate, a Core or Omarchy Mac member merges it. Don't leave a ready Aurora Dev PR waiting: merging it is the point of your role. |
| **Your own PR** | You may merge it yourself once someone else (Core or Omarchy Mac) approved it and the gate holds. GitHub never lets you approve your own PR. |
| **Agent-written PR** | Reviewed by a human or by an independent agent that did not write or plan it. When the agent and the author share one account, the reviewing agent posts its verdict as a PR review comment and an Owner or Core member merges through the PR bypass (`gh pr merge --merge --admin`); the bypass never skips the gate. |
| **Smaller-model PR** (its `Assisted-by:` names a small or fast model, today Gemini 4 Neon) | Its non-author review comes from a human or from a stronger model (Claude Opus). Another small-model review is not enough. |
| **Someone else's area or board, or a user-visible default** (default config, boot behaviour, release workflows) | Ask the area's owner to review; if they do not answer within a day, an Owner decides. |
| **CODEOWNERS paths** (`.github/`, release configuration, policy files) | Need an Owner's review (enforced). |
| **Stable hotfix** | Into `hotfix/v<X.Y.Z>`, not `main`. Owners create the branch and tag the release; you may review. [`hotfix.md`](hotfix.md) |
| **Upstream rebase** (`rebase/v<version>`) | One PR, fleet-tested like any change; nobody stacks other work on it. [`branching-and-releases.md`](branching-and-releases.md) |
| **Security fix** | Never in a public PR before the fixed release is out. [`SECURITY.md`](https://github.com/aurora-silicon/.github/blob/main/SECURITY.md) |

## 8. Triage outcomes

Sort every open PR into one outcome and say it on the PR:

- **MERGE**: meets the gate now.
- **FINISH-then-MERGE**: correct, but missing evidence or a small fix. Name what it needs.
- **CLOSE-as-superseded**: replaced by another PR or commit. Say which.
- **HOLD**: blocked on a dependency, a decision or hardware. Name the blocker and who owns it.

## 9. Reviewer rotation

Code owners are requested automatically (`.github/CODEOWNERS` in each repo routes PRs to Core and Omarchy Mac). To keep the queue moving:

- Each day one Core and one Omarchy Mac member are **first responders**: they sweep open PRs in their repos, review what is ready and merge what meets the gate. The rotation is kept in the [maintainer onboarding page](../docs/ONBOARDING-MAINTAINERS.md#reviewer-rotation).
- A review request should be answered within hours. If you cannot, say so on the PR so someone else picks it up.
- GPU (`drivers/gpu/drm/asahi`, Mesa `src/asahi`): ask Dj for a review when the change is non-trivial.
