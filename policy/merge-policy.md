# Merge Policy

> **Status: IN USE** (since 2026-11-24). **Applies to every Aurora Silicon repository** (Ryan's ruling of 2026-11-24, 10:11; co-Owner sign-off requested). The how-to for reviewers and mergers is the [review and merging handbook](review-and-merge-handbook.md); where it differs, this page wins.

Kind: hard rules where marked, otherwise defaults. Roles: [`governance-and-roles.md`](governance-and-roles.md). Branches: [`branching-and-releases.md`](branching-and-releases.md).

Finished work goes into `main` quickly. It does not sit on side, backup or private branches waiting for polish.

## 1. The rule

A PR into a repository's default branch (`main`; `aurora-wip` on mesa until its cutover) is merged **as soon as** all three hold:

1. **CI is green.** Every check that ran passes and GitHub shows the PR as mergeable (`mergeStateStatus: CLEAN`; when an Owner merges with the bypass, `BLOCKED` by the review requirement alone is expected). Exception: where a repo has no CI for the change (the mesa fork today does not gate on GitHub CI), condition 1 is waived and the hardware row is the gate.
2. **A hardware row at the PR head.** The change ran on the Mac it targets, built from the PR's head commit, with the result written in the PR (see section 3). Code shared between Mac generations also needs a row on one other Mac that has the same block, showing no regression. This is the **minimum to merge**. The [pre-PR checklist](../pre-pr-checklist.md) asks authors to prove the change on every Mac they have with the block; rows on Macs the author does not have are requested (section 3) but do not hold the merge.
3. **One non-author review with no blocking finding.** Someone other than the author (a Core or Omarchy Mac member, whose GitHub approval the rulesets count; or, for agent-written work, an independent reviewing agent, see 4) has read the whole diff, checked the [pre-PR checklist](../pre-pr-checklist.md), tried to break it, and found nothing blocking.

When all three hold, **merge within the hour**. Do not wait for a second reviewer, for polish or for nits: nits become follow-up PRs. Core and Omarchy Mac members press the button (Aurora Dev do not merge into default branches; a PR needs a Core or Omarchy Mac approval before GitHub lets anyone merge it, see [`access-tiers.md`](access-tiers.md)); an author who is Core or Omarchy Mac may merge their own PR once 1 to 3 hold.

**Hard rule.** None of the three may be skipped, except the CI waiver above. Nobody merges their own PR without a non-author review, and nobody merges runtime code without a hardware row (section 3 says what counts as one when nobody has the board).

## 2. Blocking findings

A blocking finding stops the merge until it is fixed:

- a crash, hang, data loss, boot fallback or security problem;
- a regression on any Mac (power, stability, performance, conformance);
- a hard-rule break: tainted data, an agent trailer in a commit, a chip/board/firmware gate a hardware property could replace, a feature that needs a command-line or module parameter, a hardware-safety limit hardcoded instead of read from the machine (see the [pre-PR checklist](../pre-pr-checklist.md));
- missing evidence: no hardware row, or a row that was not at the head.

A finding blocks only when it can be shown: a failing run, a measured regression, or a code path that breaks (`file:line` and the input). A suspected risk is a question or a row request. Everything else (style, naming, a better structure, more tests) is a non-blocking comment. Say which kind each comment is. Nits never hold a merge.

## 3. Hardware rows

A **row** is one test run on one Mac, recorded in the PR (in the Testing section, detail in a collapsible block):

- the Mac (chip and board, e.g. `T6040 / J616s`), the build (commit SHA of the PR head, or the fleet candidate that contains it unchanged), and the kernel command line if it is not the default;
- what ran and the result, with numbers; for a regression check, 0 SELinux denials, 0 failed units and 0 new kernel errors;
- for performance: a same-machine A/B ([`mesa-performance-claims.md`](mesa-performance-claims.md)).

Rules:

- The row must be **at the head**. If commits are pushed after the row, run it again. Two exceptions, said in the PR (or with the `hw-row-ok` label): a rebase onto a newer `main` with no conflicts in the touched files, and later commits that change nothing that is built (comments, docs, commit messages).
- A kernel PR may be proven inside a batched fleet candidate, if the candidate contains the PR's head commits unchanged. Name the candidate in the row.
- **No row needed** for changes with no runtime effect: documentation, comments, CI configuration that does not change the built artifact, and tests that run only in CI. Say "no runtime change" in the Testing section.
- **Regression requests.** A row may come from any team: post a structured regression request (repository, exact ref, platforms, instructions, pass criteria, baseline, constraints) on the Aurora Agents coordination service; the agent that claims it posts the structured result on the PR. Lab rows use the same fields.
- **Hardware nobody in the lab has:** a row on the closest Mac with the same block and code path (same SoC family), stating plainly what it stands in for, plus a regression request to the board's owner. Do not block on volunteers who have not agreed to run it.
- Protected areas keep their extra rules: no speaker playback without speaker protection running and gating it; no Stage 1 or boot-object change without the machine's owner.

## 4. Reviews

- The review is a **quick blocking-issues pass**, not a gate to wait on, done in **one round**. Review requests are answered within hours, and never later than the [response times](../maintainers/README.md#response-times) in the maintainer guide.
- An approving review on GitHub is what the ruleset counts. An approval goes stale when new commits are pushed; re-approve after reading the new commits.
- **Agent-written PRs.** An agent's PR is reviewed by a human or by a different, independent agent that did not write or plan it. When agents work under one account and cannot approve on GitHub, the reviewing agent posts its review as a PR review comment ("no blocking findings" plus what it checked), and an Owner or Core member merges through the ruleset bypass (pull requests only). The bypass is only for that case and for urgent owner merges; it never skips the three conditions in section 1.
- **Smaller-model PRs.** A PR written mainly by a smaller, faster model needs its non-author review from a human or from a stronger model; another small-model review is not enough. The author's team routes that request (for example through its review queue or a regression request), never through attribution text in the PR.
- Each side records its verdict (merge / blocking finding) on the PR, so whoever merges can see it.

## 5. How to merge

- **On linux: merge commit only** (`gh pr merge --merge`; Owners and Core merging through the bypass add `--admin`). Squash and rebase merges are disabled on linux `main`: they rewrite other people's commits and lose the commit the hardware row tested. **Other repos** still allow squash; never squash or rebase a PR that carries someone else's commits.
- The merged branch is deleted. Retarget any PR stacked on it to `main` first.
- Merge with GitHub's default subject; no extra merge comment.
- A merged change that turns out to break something is reverted by PR (revert first, then diagnose) or fixed forward the same day.

## 6. Who merges what

- **Your own area:** merge proven work yourself once section 1 holds.
- **Someone else's area or board, or a user-visible default** (default kernel config, default boot behaviour, release workflows): ask the area's owner to review; if they do not answer within a day, an Owner decides.
- **Policy, CI and release files** (`CODEOWNERS` paths: on linux `.github/`, `aurora_defconfig`, `RELEASES.md`, `CONTRIBUTING.md`; everything in `agent-guidelines`): need an Owner's review (enforced by code-owner review).
- **Releases and tags** are cut by Owners only ([`branching-and-releases.md`](branching-and-releases.md)).
