# Aurora Silicon agent guidelines

Policies for every Aurora Silicon repository, followed by human and agent contributors from every provider. No tool or model is mandated: the rules apply to the output.

## Status

| Document | Status |
| --- | --- |
| [`pre-pr-checklist.md`](pre-pr-checklist.md) | **IN USE** (since 2026-11-21). Aurora's review agents check exactly these items. Anyone may use it before opening a PR. |
| [`policy/branching-and-releases.md`](policy/branching-and-releases.md), [`policy/governance-and-roles.md`](policy/governance-and-roles.md), [`policy/merge-policy.md`](policy/merge-policy.md), [`policy/hotfix.md`](policy/hotfix.md) | **IN USE** (since 2026-11-24). Enforced on `aurora-silicon/linux` by rulesets. |
| [`policy/pr-structure.md`](policy/pr-structure.md), [`policy/pr-review.md`](policy/pr-review.md), [`policy/issue-structure.md`](policy/issue-structure.md) | **IN USE** (since 2026-11-25). One short PR, review and issue format for everyone; the PR's Tested and Risk lines are checked in CI. |
| [`docs/MAINTAINER-HANDBOOK.md`](docs/MAINTAINER-HANDBOOK.md) | The 15-minute daily routine for everyone who reviews and merges. |
| [`docs/ONBOARDING-MAINTAINERS.md`](docs/ONBOARDING-MAINTAINERS.md) | Day-one guide for Maintainers. |
| [`AGENTS.md`](AGENTS.md) | DRAFT |
| the rest of [`policy/`](policy/) | DRAFT |
| [`templates/`](templates/) | IN USE |

Drafts are not in force yet. They are published so contributors can see where the rules are heading and comment. Open an issue or a PR against this repo to propose a change.

## What this is

One set of policies for every Aurora Silicon repository. It replaces rules that were scattered across internal notes and the in-repo stub that exists only in `aura` today.

Every rule is one of two kinds:

- **Hard rules** protect safety, legality and other people's work. Never deviate.
- **Defaults** exist so everyone works the same way. If a default gets in the way of a better solution, deviate, state the reason in the PR, and propose a change to the default.

The aim is to keep everyone in sync, not to stop innovation.

## How it attaches to every repo (proposed)

`aura` already has the mechanism: `.github/aurora/AGENTS.md` is the source, and the `aurora-agent-policy` workflow copies it to `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` and `.github/copilot-instructions.md` and restores them if anything overwrites them.

1. The policies in `policy/` live here, in `aurora-silicon/agent-guidelines`.
2. Each repo's `.github/aurora/AGENTS.md` carries the pre-PR checklist and, once approved, this repo's `AGENTS.md`: the hard rules inline, the main defaults in one line each, a glossary, links to the policies, and a short per-repo notes section.
3. The sync workflow is rolled out to every repo that lacks it: linux, mesa, u-boot, fedora-aurora, alarm-aurora, nixos-aurora, speakerguardd, aurora-installer, aurora-platform, aurora-diag, aurora-bless, aurora-sep-userspace, and the website.
4. PR and issue templates are served to every repo from [`aurora-silicon/.github`](https://github.com/aurora-silicon/.github); see [`templates/README.md`](templates/README.md).

## The documents

| File | Kind | Purpose |
| --- | --- | --- |
| `pre-pr-checklist.md` | hard + one default | The checks a PR must pass before review. **In use.** |
| `AGENTS.md` | both | Hard rules, main defaults, glossary, index. Inlined into every repo. |
| `policy/ip-and-tainted-data.md` | hard | Public vs tainted, RE scope, licensing, upstreaming. |
| `policy/tracing-guidelines.md` | hard | What a trace may contain; hardware safety. macOS-under-HV and self-trace procedures are not covered yet. |
| `policy/commits-and-performance.md` | defaults + hard commit rules | Proper fixes; improvements on by default, selected by hardware; commit rules. |
| `policy/pr-structure.md` | hard sections + defaults | **In use.** PR: What / Tested / Risk / Not yet, detail folded, no AI attribution. |
| `policy/branching-and-releases.md` | hard + defaults | **In use.** Single trunk `main`, branch prefixes, edge/nightly/stable channels, stable regression gate, upstream updates. |
| `policy/governance-and-roles.md` | hard | **In use.** Owners, Core, Maintainers: what each may do, and how GitHub enforces it. |
| `policy/merge-policy.md` | hard + defaults | **In use.** CI green + hardware row at head + one non-author review, then merge the same hour. |
| `policy/hotfix.md` | hard | **In use.** When and how a stable release gets a hotfix; forward-port to `main`. |
| `policy/pr-review.md` | hard format + defaults | **In use.** Review: verdict at the head SHA, blockers, checked; comment conventions. |
| `policy/issue-structure.md` | forms + defaults | **In use.** Bug / regression / bring-up forms; diagnosing and writing up. |
| `policy/device-bringup-ladder.md` | defaults | Order and exit criteria for bringing up a new Mac. |
| `policy/mesa-performance-claims.md` | defaults | Evidence for GPU performance claims. |
| `templates/` | defaults | The review template, and where the PR and issue templates live ([`aurora-silicon/.github`](https://github.com/aurora-silicon/.github)). |
| `docs/MAINTAINER-HANDBOOK.md` | guide | Daily routine: ready-to-merge queue, review queue, saved searches, examples. |
| `docs/ONBOARDING-MAINTAINERS.md` | guide | Day one for Maintainers. |

## Decided

- **RE scope (2026-11-19):** understanding Apple hardware by reverse engineering is fine, with any tool or model. RE output stays private. Published code is clean-room.
- **Attribution (2026-11-19):** commits carry human identity only. Agents never co-author, sign off or co-commit, and commits carry no `Assisted-by`. **Superseded 2026-11-24:** no AI attribution anywhere, PR text included ([`policy/pr-structure.md`](policy/pr-structure.md), rule 3). PR bodies are short prose plus collapsible blocks for detail.
- **Hard vs default (2026-11-21):** "fix the cause, no hacks", "default command line only" and "no chip/board/firmware gates" are hard rules (see the pre-PR checklist). "Prove on hardware before merge" stays a default with a high bar. "Public text describes the code, not internal process" is a default. No AI attribution and the PR's `Tested:` and `Risk:` lines are hard rules (checked in CI); the rest of the body shape is a default. "Never merge or deploy the website without the designated owners" is hard.
- **Safety values (2026-11-21):** limits that protect hardware come from the machine (ADT/DT, its own firmware or tuning bundle, driver-reported ranges), never from per-model tables or constants in code.
- **Naming (2026-11-21):** the Vulkan driver is Borealis (`libvulkan_borealis.so`, prefix `brl_`, [aurora-silicon/mesa#591](https://github.com/aurora-silicon/mesa/issues/591)). Asahi and m1n1 names are being retired in favour of Aurora names and paths.
- **Where the set lives (2026-11-21):** a central `aurora-silicon/agent-guidelines` repo (this one), with the checklist and hard rules inlined into each repo.

- **Single trunk and releases (2026-11-24):** `aurora-silicon/linux` has one long-lived branch, `main` (renamed from `integration/aurora`). Releases: `aurora-edge` (every push), `aurora-nightly` (daily), stable `v*` tags cut from a nightly that passed the regression gate on all seven lab Macs, never held for unfinished work. Hotfixes only for boot failure, data loss, security or hardware risk. See [`policy/branching-and-releases.md`](policy/branching-and-releases.md).
- **Merge policy (2026-11-24):** merge as soon as CI is green, a hardware row ran at the PR head, and one non-author review found nothing blocking. See [`policy/merge-policy.md`](policy/merge-policy.md).
- **Roles (2026-11-24):** Owners (Ryan, Dj), Core, Maintainers (Omarchy Mac maintainers, GitHub `maintain`). See [`policy/governance-and-roles.md`](policy/governance-and-roles.md).

## Open questions

1. The `aura` source file has two variants: a short one, and a longer one that adds testing and collaboration items (end-to-end first, isolate agents, delete low-signal unit tests). Which is authoritative? The draft folds the testing items in as defaults.
2. **Licensing:** licensing is stated as GPL-2.0-only for all Aurora contributions. Is that right for repos whose base licence differs (mesa is MIT, u-boot is GPL-2.0-or-later)?
3. **Kernel upstreaming:** answered 2026-11-24 (Ryan): no AI tags in our commits or PR text; patches sent upstream follow the same rule.
4. **Undefined terms:** speaker protection is a hard rule with one line. Does it need detail (what counts as weakening protection)? ("Shared branches" is now defined in [`policy/branching-and-releases.md`](policy/branching-and-releases.md).)
5. **Dead-man:** the example is macOS-side (`shutdown -r +N`, `caffeinate`, `pmset`). What is the required dead-man for a Linux or bare aura test boot?
6. **Firmware pin:** the firmware pin (macOS 27.2) has no linked decision document.
7. **Safety's home:** hardware safety lives in `policy/tracing-guidelines.md`, which is an odd place for it. Should it move to its own page?
8. **Asahi naming:** the Borealis rename is decided; the rename of the remaining Asahi/m1n1-derived names (for example the `m1n1` repo) is still in progress.
9. **Glossary:** the Stage 1/2, 1TR, stub, proxyclient and fleet-kernel entries need a check by someone who owns the boot chain.

## Licence

The text in this repository is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Reuse and adapt it in your own projects; please credit Aurora Silicon.
