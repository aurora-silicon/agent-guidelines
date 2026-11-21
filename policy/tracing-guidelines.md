# Tracing Guidelines

> **Status: DRAFT. Not in force yet.** The [pre-PR checklist](../pre-pr-checklist.md) is in use today; where this draft and the checklist differ, the checklist wins.

Kind: **hard rules**. This page covers two things only: what a trace may contain, and the safety rules for hardware. See the glossary in [`AGENTS.md`](../AGENTS.md). *(Open question: should hardware safety move to its own page?)*

## What a trace may contain

- **Public: our own captures.** dtrace, log streams, ioreg, timings, our own macOS and Linux measurements, our own compiled outputs. They may be published and cited in public PRs.
- **Tainted and private: Apple-derived material.** Reverse-engineering (RE) output from Apple binaries, firmware blobs, Apple tuning values. They stay in private, tainted storage. Refer to them in public work; never quote them. Nothing from a tainted trace reaches a public repo, PR, issue or channel.

The full public/tainted line is in [`ip-and-tainted-data.md`](ip-and-tainted-data.md).

## Not covered yet

Procedures for running macOS under the aura hypervisor and for self-tracing are still being worked out. They will be added once proven. Until then, such work follows the rules on this page.

## Safety on hardware

- **Dead-man on every test boot.** Before you start, arm an automatic reboot or recovery (for example `shutdown -r +N`) so the machine returns to a known-good system by itself. Assume you will lose the session. On macOS also keep the machine awake (`caffeinate`, `pmset sleep 0`) and mute it. *(Open question: the required dead-man for a Linux or bare aura test boot.)*
- **Tether where the board has one.** A tether is a debug console over USB-C (VDM). If a tethered board does not come back and the tether also fails, escalate to the machine's owner at once. Before any USB-C VDM or HPM reset, confirm which Mac is on the far end of the cable.
- **Read before write.** Probe registers (MMIO) read-only first. No writes to registers you do not understand.
- **Safety limits come from the machine.** Limits that protect hardware are read from the ADT/DT, the machine's own firmware or tuning bundle, or driver-reported ranges, never from per-model tables or constants in code. No value, no feature: it stays off or muted.
- **No Stage 1 or boot-object change without the machine's owner.** A bad Stage 1 needs a person at the machine to repair.
- **Never weaken or bypass speaker protection.** Speakers can be physically destroyed. *(Open question: what exactly counts as weakening.)*
- **Tracing machinery ships disabled.** It is a lab development path, not a product feature.
- **Restore the baseline when you finish**: ESP contents, boot policy, boot selection.
