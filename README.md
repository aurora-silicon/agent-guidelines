# Aurora Silicon agent guidelines

Policies for every Aurora Silicon repository, followed by human and agent contributors from every provider. No tool or model is mandated: the rules apply to the output.

## Status

| Document | Status |
| --- | --- |
| [`pre-pr-checklist.md`](pre-pr-checklist.md) | **IN FORCE** (since 2026-11-21). Aurora's review agents check exactly these items. Anyone may use it before opening a PR. |
| [`AGENTS.md`](AGENTS.md) | **IN FORCE** (since 2026-11-24). The rulebook every agent loads, whoever runs it; every repo's `AGENTS.md`/`CLAUDE.md` points here. |
| [`policy/branching-and-releases.md`](policy/branching-and-releases.md), [`policy/governance-and-roles.md`](policy/governance-and-roles.md), [`policy/access-tiers.md`](policy/access-tiers.md), [`policy/merge-policy.md`](policy/merge-policy.md), [`policy/review-and-merge-handbook.md`](policy/review-and-merge-handbook.md), [`policy/hotfix.md`](policy/hotfix.md) | **IN FORCE** (since 2026-11-24). Enforced by rulesets on every public product repo ([`policy/access-tiers.md`](policy/access-tiers.md)). |
| [`policy/pr-structure.md`](policy/pr-structure.md), [`policy/pr-review.md`](policy/pr-review.md) | **IN FORCE** (since 2026-11-25). One short PR and review format for everyone. |
| [`policy/issue-structure.md`](policy/issue-structure.md) | **IN FORCE** (since 2026-11-24). The issue forms. |
| [`maintainers/`](maintainers/README.md) | **IN FORCE** (since 2026-11-24). For maintainers and their agents only: priorities, response times, no ping-pong; the daily routine and onboarding. |
| the rest of [`policy/`](policy/) and [`templates/`](templates/) | **IN FORCE** (since 2026-11-24). |

Everything here is in force. Propose a change by issue or PR against this repo; Owner-level changes (roles, access, releases) need a human Owner's sign-off.

## What this is

One set of policies for every Aurora Silicon repository. It replaces rules that were scattered across internal notes and the in-repo stub that exists only in `aura` today.

Every rule is one of two kinds:

- **Hard rules** protect safety, legality and other people's work. Never deviate.
- **Defaults** exist so everyone works the same way. If a default gets in the way of a better solution, deviate, state the reason in the PR, and propose a change to the default.

The aim is to keep everyone in sync, not to stop innovation.

## How it attaches to every repo

1. The rules live here, in `aurora-silicon/agent-guidelines`: [`AGENTS.md`](AGENTS.md) (the rulebook) and `policy/`.
2. Every product repo has a root `AGENTS.md` and `CLAUDE.md` whose first lines say: follow `https://github.com/aurora-silicon/agent-guidelines/blob/main/AGENTS.md`, then the repo's own notes. Repos with the `aurora-agent-policy` workflow (aura, mesa, m1n1 and others) carry the same pointer in their source file, `.github/aurora/AGENTS.md`, and the workflow keeps the copies (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`) identical.
3. Every product repo has `.github/CODEOWNERS` routing reviews to Core and Omarchy Mac ([`policy/access-tiers.md`](policy/access-tiers.md)).
4. Org-wide `CONTRIBUTING.md`, `SECURITY.md`, PR and issue templates live in [`aurora-silicon/.github`](https://github.com/aurora-silicon/.github) and apply to every repo that has none of its own; their source is `templates/` here.
5. [`tools/gh-access-apply.sh`](tools/gh-access-apply.sh) applies team roles and rulesets; Owners run it (dry run by default).

## The documents

| File | Kind | Purpose |
| --- | --- | --- |
| `pre-pr-checklist.md` | hard + one default | The checks a PR must pass before review. **In force.** |
| `AGENTS.md` | both | **In force.** The rulebook: hard rules, defaults, how agents join, glossary, index. Every repo points here. |
| `policy/ip-and-tainted-data.md` | hard | Public vs tainted, RE scope, licensing, upstreaming. |
| `policy/tracing-guidelines.md` | hard | What a trace may contain; hardware safety. macOS-under-HV and self-trace procedures are not covered yet. |
| `policy/commits-and-performance.md` | defaults + hard commit rules | Proper fixes; improvements on by default, selected by hardware; commit rules. |
| `policy/pr-structure.md` | defaults + hard no-attribution rule | PR body, collapsible detail, no AI attribution, credit. |
| `policy/branching-and-releases.md` | hard + defaults | **In force.** Single trunk `main`, branch prefixes, edge/nightly/stable channels, stable regression gate, upstream updates. |
| `policy/governance-and-roles.md` | hard | **In force.** Owners, Core, Maintainers: what each may do, and how GitHub enforces it. |
| `policy/merge-policy.md` | hard + defaults | **In force.** CI green + hardware row at head + one non-author review, then merge the same hour. |
| `policy/hotfix.md` | hard | **In force.** When and how a stable release gets a hotfix; forward-port to `main`. |
| `policy/access-tiers.md` | hard | **In force.** Team roles per repository class; the rulesets every public product repo carries. |
| `policy/review-and-merge-handbook.md` | defaults + hard gate | **In force.** How Core and Omarchy Mac review and merge: hardware rows, regression requests, review format, special cases, rotation. Replaces `policy/pr-review.md`. |
| `policy/issue-structure.md` | defaults | Filing, diagnosing and writing up an issue. |
| `policy/device-bringup-ladder.md` | defaults | Order and exit criteria for bringing up a new Mac. |
| `policy/mesa-performance-claims.md` | defaults | Evidence for GPU performance claims. |
| `templates/` | defaults | PR, bug and bring-up skeletons. The org-wide copies live in [`aurora-silicon/.github`](https://github.com/aurora-silicon/.github). |
| `maintainers/README.md` | defaults | Maintain first; response times; members and outside contributors; one review round, plain words. |
| `maintainers/agents.md` | defaults | Agents doing maintainer work: one owner per item, coordinator and machine leads. |
| `maintainers/daily-routine.md` | guide | The 15-minute daily routine on top of the readiness labels, with examples. |
| `maintainers/onboarding.md` | guide | Day one for maintainers, with a starter review queue. |
| `tools/gh-access-apply.sh` | tool | Applies the access tiers and rulesets (Owners only). |

## Decided

*Entries dated 2026-11-24 are Ryan's rulings; Dj's co-Owner sign-off is requested on the PR that recorded them.*

- **RE scope (2026-11-19, refined 2026-11-24):** reverse engineering Apple hardware is welcome, with any tool or model. Public repos never contain Apple's copyrighted material itself (code, listings, firmware, tuning files); RE-derived drivers and interface layouts written as our own code are welcome. See [`policy/ip-and-tainted-data.md`](policy/ip-and-tainted-data.md).
- **No AI attribution (2026-11-24, replaces the 2026-11-19 `Assisted-by` rule):** commits carry the human author and `Signed-off-by` only; commits, PR titles and bodies, comments and reviews name no model or tool. PR bodies are short prose plus collapsible blocks for detail.
- **Hard vs default (2026-11-21):** "fix the cause, no hacks", "default command line only" and "no chip/board/firmware gates" are hard rules (see the pre-PR checklist). "Tested on the affected hardware at the PR head before merge" became a hard rule with the 2026-11-24 merge policy. "Public text describes the code, not internal process" is a default. "No AI attribution" is a hard rule; the body shape is a default. "Never merge or deploy the website without the designated owners" is hard.
- **Safety values (2026-11-21):** limits that protect hardware come from the machine (ADT/DT, its own firmware or tuning bundle, driver-reported ranges), never from per-model tables or constants in code.
- **Naming (2026-11-21):** the Vulkan driver is Borealis (`libvulkan_borealis.so`, prefix `brl_`, [aurora-silicon/mesa#591](https://github.com/aurora-silicon/mesa/issues/591)). Asahi and m1n1 names are being retired in favour of Aurora names and paths.
- **Where the set lives (2026-11-21, changed 2026-11-24):** a central `aurora-silicon/agent-guidelines` repo (this one). Each repo's agent files point here and keep only that repo's own notes; nothing is copied into them, so they cannot go stale.

- **Single trunk and releases (2026-11-24):** `aurora-silicon/linux` has one long-lived branch, `main` (renamed from `integration/aurora`). Releases: `aurora-edge` (every push), `aurora-nightly` (daily), stable `v*` tags cut from a nightly that passed the regression gate on the [gate Macs](policy/branching-and-releases.md#gate-macs), never held for unfinished work. Hotfixes only for boot failure, data loss, security or hardware risk. See [`policy/branching-and-releases.md`](policy/branching-and-releases.md).
- **Merge policy (2026-11-24):** merge as soon as CI is green, a hardware row ran at the PR head, and one non-author review found nothing blocking. See [`policy/merge-policy.md`](policy/merge-policy.md).
- **Roles (2026-11-24):** Owners (Ryan, Dj). Core and Omarchy Mac review and merge; Aurora Dev develop on branches and do not merge into default branches. Enforced per repo by rulesets. See [`policy/governance-and-roles.md`](policy/governance-and-roles.md) and [`policy/access-tiers.md`](policy/access-tiers.md).
- **One rulebook (2026-11-24):** every agent, whoever runs it, loads [`AGENTS.md`](AGENTS.md) here; repos point to it. Owner-level policy changes need a human Owner's sign-off.
- **Maintainers (2026-11-24, Dj's ruling; Ryan's co-Owner confirmation requested):** maintenance comes before development. Members (anyone in the organisation) get a first review within 24 hours and outside contributors within 48; every issue is acknowledged within 24 hours. Reviews take one round, block only on problems that can be shown, use plain words instead of rule numbers, and maintainers fix small things themselves. A row stays valid across commits that change nothing that is built. An author may rewrite their own PR branch to fix commit metadata. See [`maintainers/`](maintainers/README.md).
- **Gate Macs and RC cross-check (2026-11-24):** stable releases pass a release-candidate cross-check on the [gate Macs](policy/branching-and-releases.md#gate-macs), run by every team through regression requests.

## Open questions

1. *(Resolved 2026-11-25.)* The `aura` testing and collaboration notes stay in aura as repo specifics; their general points are rulebook defaults ("Test end to end first").
2. **Licensing:** licensing is stated as GPL-2.0-only for all Aurora contributions. Is that right for repos whose base licence differs (mesa is MIT, u-boot is GPL-2.0-or-later)?
3. **Kernel upstreaming:** if a project we submit to requires an AI-disclosure tag, does its rule override ours for that submission?
4. **Undefined terms:** speaker protection is a hard rule with one line. Does it need detail (what counts as weakening protection)? ("Shared branches" is now defined in [`policy/branching-and-releases.md`](policy/branching-and-releases.md).)
5. **Dead-man:** the example is macOS-side (`shutdown -r +N`, `caffeinate`, `pmset`). What is the required dead-man for a Linux or bare aura test boot?
6. **Firmware pin:** the firmware pin (macOS 27.2) has no linked decision document.
7. **Safety's home:** hardware safety lives in `policy/tracing-guidelines.md`, which is an odd place for it. Should it move to its own page?
8. **Asahi naming:** the Borealis rename is decided; the rename of the remaining Asahi/m1n1-derived names (for example the `m1n1` repo) is still in progress.
9. **Glossary:** the Stage 1/2, 1TR, stub, proxyclient and fleet-kernel entries need a check by someone who owns the boot chain.

## Licence

The text in this repository is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Reuse and adapt it in your own projects; please credit Aurora Silicon.
