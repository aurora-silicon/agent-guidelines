# PR Structure

> **Status: IN FORCE** (since 2026-11-24). Change it by PR here.

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

## No AI attribution

**Hard rule.** PR titles, bodies, comments and reviews name no model or tool: no `Assisted-by:`, `Co-Authored-By` naming a tool, "Generated with" footer, model names or session links. A PR is judged on its content and evidence, whoever or whatever typed it. Commits carry the human author and `Signed-off-by` only ([`commits-and-performance.md`](commits-and-performance.md)). The `pr-text` check flags attribution lines; delete them and it passes.

## Credit

Credit the people who reported, suggested or tested: `Reported-by:`, `Suggested-by:` or `Tested-by:` trailers, a `Link:` to their issue or message, and a plain thank-you in the PR body.

## Scope

- One coherent change per PR. For stacked PRs, state the base and the order.
- Kernel PRs target `main` from a `feat/` or `fix/` branch ([`branching-and-releases.md`](branching-and-releases.md)). They may be proven in a batched fleet candidate that contains their head commits unchanged ([`merge-policy.md`](merge-policy.md)).
- If the change touches a shared path, say which machines you verified are unaffected.

## Evidence

Link the public trace or analysis (a public repo, release asset or gist). Tainted evidence stays private: refer to it, never quote it ([`ip-and-tainted-data.md`](ip-and-tainted-data.md)).
