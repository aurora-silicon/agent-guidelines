# PR Structure

> **Status: DRAFT. Not in force yet.** The [pre-PR checklist](../pre-pr-checklist.md) is in use today; where this draft and the checklist differ, the checklist wins.

Kind: defaults, except lines marked **Hard rule**. See "Two kinds of rule" and the glossary in [`AGENTS.md`](../AGENTS.md). Commit rules are in [`commits-and-performance.md`](commits-and-performance.md).

A reviewer should understand the problem, the change and the evidence from the PR alone.

## Body

Four short prose sections that a person can read in a minute. The skeleton is [`templates/PULL_REQUEST_TEMPLATE.md`](../templates/PULL_REQUEST_TEMPLATE.md).

- **Problem**: what is wrong or missing and how it shows up. Link the issue (`Fixes #NNN`).
- **Change**: what you changed and why it is the proper fix. Say which chips and boards it affects. If it is gated, give the hardware reason. If you deviated from a default, say which one and why.
- **Testing**: the hardware you ran on and the result. Use a table for A/B or regression runs. Name the suite and give the counts (0 AVC, meaning SELinux denials; 0 failed units; 0 new kernel errors) and any performance change.
- **Still to run**: what is not covered yet, and on which hardware.

Leave a section out only when it truly does not apply. Keep the text about the code: no internal chat, reviews, holds or orchestration.

## Collapsible detail

Put the full detail a reviewer (human or agent) may need below the prose, in collapsible blocks:

```html
<details>
<summary>Full test results (deqp-vk, 3 reps, J616s + M1 Pro)</summary>

...tables, per-case lists, timings...
</details>
```

Use them for long code, full result tables, summarised dmesg excerpts (never raw private logs) and reviewer context such as the call graph or alternatives you tried.

The problem, the change and any regression are never hidden inside a collapsed block.

## Agent disclosure

**Hard rule.** When an agent helped, the last line of the PR body is exactly one line:

```
Assisted-by: LLM (Claude:Opus 5.5)
```

- Format: `Assisted-by: LLM (<Vendor>:<Model>)`, for example `(DeepSeek:4.1 Flash)` or `(Codex:GPT-6.2)`.
- Several agents: comma-separated inside one pair of parentheses.
- No "Generated with" line, no emoji, no links or session URLs.
- Leave the line out when no agent helped.
- This line never goes in a commit.

## Credit

Credit the people who reported, suggested or tested: `Reported-by:`, `Suggested-by:` or `Tested-by:` trailers, a `Link:` to their issue or message, and a plain thank-you in the PR body.

## Scope

- One coherent change per PR. For stacked PRs, state the base and the order.
- Kernel changes are batched into one fleet candidate, not booted one PR at a time ([`pr-review.md`](pr-review.md)).
- If the change touches a shared path, say which machines you verified are unaffected.

## Evidence

Link the public trace or analysis (a public repo, release asset or gist). Tainted evidence stays private: refer to it, never quote it ([`ip-and-tainted-data.md`](ip-and-tainted-data.md)).
