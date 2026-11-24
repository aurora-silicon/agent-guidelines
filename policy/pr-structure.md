# PR Structure

> **Status: IN USE** (since 2026-11-25). Every PR in every Aurora Silicon repository, from anyone (people and every team's agents). Template: [`aurora-silicon/.github`](https://github.com/aurora-silicon/.github/blob/main/.github/PULL_REQUEST_TEMPLATE.md), served to every repository.

A person reads the visible part in under a minute. Everything an agent or a deep reviewer needs goes in the folded blocks below it.

```markdown
**What:** one or two sentences: the change and why. Fixes #NNN
**Tested:** Macs at the head SHA + result.
**Risk:** one-way | two-way door · which Macs it can affect
**Not yet:** what is still untested, or "nothing"

<details><summary>Details</summary> how it works, design choices </details>
<details><summary>Evidence</summary> commands, result tables, logs, CI runs, exact SHAs </details>
```

## Rules

1. **Tested** names the Macs, the head commit and the result, so a reader (and the readiness bot) can see the row is current: `J413 M2 Air at 3f2a9c1: boots, 0 failed units`. Docs, comments or CI only: `no runtime change`. **Hard rule:** CI checks the line is there; the readiness bot checks it has the head SHA, a Mac and a result (else `needs-hw-row`).
2. **Risk** gives the door and the Macs. **Two-way**: a plain revert undoes it. **One-way**: a revert does not (on-disk or firmware state, UAPI or DT binding, a default users see, a release, a migration). Macs: `M1`…`M5`, `Neo`, boards or chips, `all Macs`, or `none`. **Hard rule, checked in CI.**
3. **No AI attribution** in titles, bodies, comments or reviews: no `Assisted-by:`, no `Generated with` footer, no model signatures or session links. Commits carry the human author and `Signed-off-by` only. **Hard rule, checked in CI** (title, body, the author's own commits).
4. The problem, the change and any regression are never hidden in a folded block.
5. Public text is about the code and the evidence: no internal chat, schedules or holds, no serial numbers, nothing derived from Apple binaries, firmware or tuning values ([`ip-and-tainted-data.md`](ip-and-tainted-data.md)).
6. Title: `<area>: <what changes>`, like the repository's commit subjects. One topic per PR; a stacked PR names its base.
7. Credit reporters and testers (`Reported-by:`, `Tested-by:` trailers, a thank-you in the body).

The `pr-text` check ([reusable workflow](https://github.com/aurora-silicon/.github/blob/main/.github/workflows/pr-text.yml); running on linux and wired into mesa, then every repository as it adds the caller) fails new PRs that break 1 to 3 and says exactly what to add or delete. PRs opened before 2026-11-25 and drafts get warnings only.

Filled example: [maintainer handbook](../docs/MAINTAINER-HANDBOOK.md#examples).
