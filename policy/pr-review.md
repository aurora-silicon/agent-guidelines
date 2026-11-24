# PR Review Format

> **Status: IN USE** (since 2026-11-25). Every review in every Aurora Silicon repository, from anyone. When a PR may merge: [`merge-policy.md`](merge-policy.md). Template: [`templates/REVIEW_TEMPLATE.md`](../templates/REVIEW_TEMPLATE.md).

Verdict first, short, the rest folded. Whoever merges next should know from the first three lines what was decided, at which commit, and what blocks it.

```markdown
**Verdict:** MERGE | FINISH, then merge | HOLD | CLOSE (superseded by #NNN) at `<head sha>`
**Blockers:** none, or numbered: `path/file.c:123`: what's wrong, and what fixes it
**Checked:** §1–§6 of the pre-PR checklist, the rows at this head, CI

<details><summary>Evidence</summary> what you ran or read </details>
```

## Rules

1. **One verdict** (hard rule):
   - **MERGE**: meets the merge policy now. Approve on GitHub.
   - **FINISH, then merge**: right approach, needs the listed blockers fixed or a row added; after that it merges without a full re-review. Request changes (or comment if only a row is missing).
   - **HOLD**: blocked outside the PR (a dependency, a decision, hardware). Name it and who owns it; add the `hold` label.
   - **CLOSE (superseded by #NNN)**: replaced by another PR or commit.
2. **At the head SHA** you reviewed (hard rule). A review of an older head does not count for a newer one; after new commits, re-check only what changed and your blockers ("1. fixed in abc1234").
3. **Blockers are only**: a crash, hang, data loss, boot fallback or security problem; a regression on any Mac; a hard-rule break (tainted data, AI attribution, a chip/board/firmware gate, a parameter a feature needs, a hardcoded safety limit); a missing row or one not at the head. Everything else is a nit: put it in the folded block or a follow-up issue; nits never hold a merge.
4. **Checked** cites the [pre-PR checklist](../pre-pr-checklist.md) sections (`§1–§4 pass`, `§5 row J616s at head`) in one line.
5. **Comments** in PRs and issues follow the same conventions: about the code and the evidence, specific (`file:line`, a SHA, a link), one batched review per pass, no internal process, no AI attribution, no serial numbers.

Filled example: [maintainer handbook](../docs/MAINTAINER-HANDBOOK.md#examples).
