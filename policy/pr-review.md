# PR Review Format

> **Status: IN FORCE** (since 2026-11-25). Every review in every Aurora Silicon repository, from anyone. When a PR may merge: [`merge-policy.md`](merge-policy.md). Template: [`templates/REVIEW_TEMPLATE.md`](../templates/REVIEW_TEMPLATE.md).

Verdict first, short, the rest folded. Whoever merges next should know from the first three lines what was decided, at which commit, and what blocks it.

```markdown
**Verdict:** MERGE | FINISH, then merge | HOLD | CLOSE (superseded by #NNN) at `<head sha>`
**Blockers:** none, or numbered: `path/file.c:123`: what's wrong, and what fixes it
**Checked:** in words: no Apple material, no gates, safety values from the machine, the row at this head, CI

<details><summary>Evidence</summary> what you ran or read </details>
```

## Rules

1. **One verdict** (hard rule):
   - **MERGE**: meets the merge policy now. Approve on GitHub.
   - **FINISH, then merge**: right approach, needs the listed blockers fixed or a row added; after that it merges without a full re-review. Request changes (or comment if only a row is missing).
   - **HOLD**: blocked outside the PR (a dependency, a decision, hardware). Name it and who owns it; add the `hold` label.
   - **CLOSE (superseded by #NNN)**: replaced by another PR or commit.
2. **At the head SHA** you reviewed (hard rule). A review of an older head does not count for a newer one; after new commits, re-check only what changed and your blockers ("1. fixed in abc1234"). **One round:** every blocker goes in the first review; a later pass adds a new one only for a crash, data loss, or a safety or hard-rule problem you missed.
3. **Blockers are only**: a crash, hang, data loss, boot fallback or security problem; a regression on any Mac; a hard-rule break (tainted data, AI attribution, a chip/board/firmware gate, a parameter a feature needs, a hardcoded safety limit); a missing row or one not at the head. You must be able to show it (a failing run, a measured regression, a code path that breaks at `file:line`); a risk you suspect but have not shown is a question or a row request. Everything else is a nit: put it in the folded block or a follow-up issue; nits never hold a merge.
4. **Plain words.** Blockers and **Checked** say what is wrong or what you checked in words (`no Apple material, no gates, row J616s at head`). Never cite a rule by its number ("§5 violation"): contributors cannot read it. Link the rule after the sentence if it helps.
5. **Comments** in PRs and issues follow the same conventions: about the code and the evidence, specific (`file:line`, a SHA, a link), one batched review per pass, no internal process, no AI attribution, no serial numbers.

Filled example: [daily routine](../maintainers/daily-routine.md#examples).
