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

**Hard rule (disclosure only; exact model/vendor wording is flexible).** When an agent helped, put a plain `Assisted-by:` line at the end of the PR body naming the model or tool — for example:

```
Assisted-by: LLM (Claude:Opus 5.5)
```

- Any clear plain-text form naming the model or tool is fine (for example `Assisted-by: LLM (Claude Opus 5.5)`, `Assisted-by: LLM (Gemini 4 Neon)`, or `Assisted-by: Codex (GPT-6.2)`). Do not block or nitpick PRs over vendor vs. product naming, colons, or parentheses.
- Several agents can be listed together on the same line.
- No "Generated with ..." footer, no emoji, no links or session URLs.
- Leave the line out when no agent helped.
- This line never goes in a commit.

## Credit

Credit the people who reported, suggested or tested: `Reported-by:`, `Suggested-by:` or `Tested-by:` trailers, a `Link:` to their issue or message, and a plain thank-you in the PR body.

## Scope

- One coherent change per PR. For stacked PRs, state the base and the order.
- Kernel PRs target `main` from a `feat/` or `fix/` branch ([`branching-and-releases.md`](branching-and-releases.md)). They may be proven in a batched fleet candidate that contains their head commits ([`merge-policy.md`](merge-policy.md)).
- If the change touches a shared path, say which machines you verified are unaffected.

## Evidence

Link the public trace or analysis (a public repo, release asset or gist). Tainted evidence stays private: refer to it, never quote it ([`ip-and-tainted-data.md`](ip-and-tainted-data.md)).
