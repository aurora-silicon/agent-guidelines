# Templates

| What | Where | Rule |
| --- | --- | --- |
| PR template | [`aurora-silicon/.github` `.github/PULL_REQUEST_TEMPLATE.md`](https://github.com/aurora-silicon/.github/blob/main/.github/PULL_REQUEST_TEMPLATE.md) | [`policy/pr-structure.md`](../policy/pr-structure.md) |
| Issue forms: bug, regression, bring-up | [`aurora-silicon/.github` `.github/ISSUE_TEMPLATE/`](https://github.com/aurora-silicon/.github/tree/main/.github/ISSUE_TEMPLATE) | [`policy/issue-structure.md`](../policy/issue-structure.md) |
| Review | [`REVIEW_TEMPLATE.md`](REVIEW_TEMPLATE.md) (here) | [`policy/pr-review.md`](../policy/pr-review.md) |
| Readiness comment and labels | [`aurora-silicon/.github` `.github/workflows/pr-readiness.yml`](https://github.com/aurora-silicon/.github/blob/main/.github/workflows/pr-readiness.yml) | [`maintainers/daily-routine.md`](../maintainers/daily-routine.md) |

The PR and issue templates exist once, in `aurora-silicon/.github`. GitHub serves them to every repository that has no `.github/PULL_REQUEST_TEMPLATE.md` or `.github/ISSUE_TEMPLATE/` of its own, so repositories should not carry their own copies. Change them by PR there; change the rule they implement by PR here.
