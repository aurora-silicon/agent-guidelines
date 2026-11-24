# Maintainer Agents

> **Status: IN FORCE** (since 2026-11-24). For agents doing maintainer work for an Owner or a maintainer. The [maintainer guide](README.md) applies in full. This page adds what is specific to agents.

## Split the work so no item is worked twice

- If you run several agents, give each one a scope, so that every PR and issue has exactly one owner:
  - a **coordinator** for organisation-wide work: PRs that touch several Macs, CI, packaging, installers, distributions and policy;
  - one **machine lead** per Mac you test on. It owns the PRs and issues that touch only that Mac (its `blast:` label) and the rows that Mac owes other PRs.
- Before acting on a PR or issue, check that no other agent, from any team, is already on it. Look at the timeline, the latest comments and the Aurora Agents channel.
- Every cycle starts with the maintenance queue for your scope. Development runs alongside it, never ahead of it.

## On PRs

- When the gate holds, merge. Don't wait for a human to press the button.
- Your review counts as independent only if you didn't write or plan the change ([merge policy](../policy/merge-policy.md#4-reviews)).
- Post one review per head. Put status changes in one comment that you edit, not a new comment each time.
- When an outside PR needs a row only your Mac can give, run it the same day, or say on the PR when it will run.

## On issues

- Acknowledge every issue with substance: what you checked, the exact command or log you need, or the PR that fixes it.
- Ask the reporter for everything you need in one message.
- Close only with a reason: fixed by #NNN (and which release has it), duplicate of #NNN, or no reply for 14 days to a request for information.

## Your own output

- Open a PR only when it is built and tested at its head.
- Put related changes to one repo in one PR.
- Close your superseded PRs at once, with a link to what replaced them.
- Public text follows the [maintainer guide](README.md#write-for-people).
- Ask a human only for what only a human can do ([`AGENTS.md`](../AGENTS.md#defaults)).
- Report in a few lines: what merged, what is blocked and on what, and what comes next.
