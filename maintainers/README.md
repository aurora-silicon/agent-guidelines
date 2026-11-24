# Maintainers

> **Status: IN FORCE** (since 2026-11-24). For the people who review, merge and triage (Owners, Core, Omarchy Mac) and the agents that do it for them. Contributors don't need this folder.

What may merge is set by the [merge policy](../policy/merge-policy.md). This page sets how fast we answer and how we work with contributors. Mechanics: [daily routine](daily-routine.md) (labels, queues, examples), [review handbook](../policy/review-and-merge-handbook.md). Agents doing this work: [agents.md](agents.md). New maintainers: [onboarding](onboarding.md).

Contributors have less time than we do. Every day a PR or issue waits on us is a day they lose.

## Maintain first

Clear the queue before your own development, in this order:

1. **Merge what's ready.** Do this when the gate holds, even if the bot hasn't caught up.
2. **Unblock members' PRs.** Review them, get the missing row, and fix the small stuff yourself.
3. **Answer new issues.**
4. **Outside contributors' PRs.**
5. Then your own work.

**Members** are everyone in the `aurora-silicon` organisation, whatever their team (Core, Omarchy Mac, Aurora Dev). **Outside contributors** are everyone else.

## Response times

| | Target |
| --- | --- |
| New issue acknowledged | 24 hours |
| First review of a member's PR | 24 hours (aim for the same day) |
| First reply on an outside PR; its first review | 24 hours; 48 hours |
| Re-check after the author fixes the blockers | 24 hours |
| Merge once the gate holds | within the hour |

An acknowledgement says something real: a label plus what happens next and who has it, a question, or a close with the reason. "Thanks, we'll look" doesn't count.

Being requested on a PR doesn't make it yours. Once the time is up, any maintainer takes it.

## Members and outside contributors

**Members: trust them.**

- Review for blockers only. Take their `Tested:` line as true for the head it names, and don't ask them to re-run what they reported.
- Don't re-argue a design that works. Suggest the alternative as a follow-up.

**Outside contributors: welcome them, then check more.**

- Thank them, and tell them exactly what happens next.
- Read the whole diff: CI workflows, scripts, build files, binaries and download URLs too. Approve their CI runs (`action_required`) only after reading it.
- Before merging anything that sets a hardware-safety value, touches a boot path or writes registers, run a row yourself or have one run.
- Credit them with a thank-you on merge, and a `Reported-by:` or `Tested-by:` trailer on the fix commit (leave their own commits unchanged).

## No ping-pong

Every round trip costs the author a day.

1. **One round.** Put every blocker in your first review. After that, re-check only those blockers and the new commits. You may raise a new blocker later only for what the new commits or a new row show, or for a crash, data loss, or a safety or hard-rule problem you missed.
2. **A blocker is a problem you can show:** a failing run, a measured regression, a code path that breaks (`file:line` and the input), a hard-rule break, or a missing row. A risk you suspect but haven't shown is a question or a row request, not a blocker. Style, structure, naming and more tests are nits: never send a PR back for them.
3. **Fix small things yourself.** This covers the PR body format, a `Tested:` or `Risk:` line the PR already answers, attribution in the body, a typo, and a stale base (`gh pr update-branch`). Maintainers can edit any PR body. "Allow edits by maintainers" counts as agreement to push fix commits to the branch.
4. **Get rows yourself.** If a row is missing, run it or post the regression request; don't send the author to chase it. The gate needs a row on the targeted Mac, plus one same-block row for shared code ([merge policy](../policy/merge-policy.md#1-the-rule)). Rows beyond that are checks after the merge, with a revert ready.
5. **Finish stalled work.** If the author is silent for 7 days after your FINISH, finish it on top of their commits (their authorship stays), or close it with thanks and the reason.
6. **Never close and reopen a PR to re-run CI.** Use `gh run rerun --failed` or `gh pr update-branch`.
7. **The bot is a helper, not a gate.** A wrong label never blocks a merge. Fix the body, set `hw-row-ok`, or merge on the policy, then report the bug in [`aurora-silicon/.github`](https://github.com/aurora-silicon/.github/issues).

## Write for people

- Say what is wrong and how to fix it, in plain words, at `file:line`. Never cite a rule by its number: "§5 violation" means nothing to a contributor. If a rule helps, link it after the sentence.
- Put the verdict first and post one comment per pass, with the detail folded. If a person can't read it in a minute, it is too long.
- Skip the preambles ("adversarial review against …") and the internal process.

## AI attribution: there is nothing to add

The rule is **no AI attribution anywhere** ([`AGENTS.md`](../AGENTS.md#hard-rules)): never ask anyone to add it.

- In a PR body or a comment, delete it yourself.
- In commits, list it in the same review as everything else, and paste the fix below. The author may rewrite their own PR branch for this ([branching](../policy/branching-and-releases.md#2-branch-names)).
  - Human co-authors and sign-offs stay.
  - Use the PR's base branch: `main`, or `aurora-wip` on mesa.
  - Then set `hw-row-ok`: the hashes change, but the tested code does not.

```sh
git fetch origin
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --msg-filter "grep -viE '^(assisted-by:|(co-authored-by|signed-off-by):.*(claude|copilot|codex|gemini|cursor|openai|anthropic)|[^a-z]*generated with)' | git stripspace" origin/main..HEAD
git push --force-with-lease
```

## Keep the queue small

- Your own PRs are part of the queue. When a PR is superseded, close it right away with a link. Keep one PR per topic, and push to the open PR instead of opening a new one.
- When two PRs do the same thing, close the later one with a link. If both are active, ask the authors which one carries on.
- Finish or close your own drafts once they have been idle for 14 days.

## Escalate, don't wait

Only the Owners change settings, rulesets, secrets or access, cut releases and tags, sign off on policy, and handle private repos. For those, leave one line on the PR mentioning an Owner and move to the next item. Decide everything else yourself.
