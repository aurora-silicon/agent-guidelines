---
name: Device bring-up
about: Track bringing a subsystem up on a Mac/chip
labels: bringup
---

<!-- DRAFT template. See policy/device-bringup-ladder.md in https://github.com/aurora-silicon/agent-guidelines. -->

## Machine

<!-- Chip/board (e.g. T6040 / J616s), kernel/build, firmware (pinned version). -->

## Ladder rung

<!-- CPU and clocks / SMP and MMU / memory controller / USB RAM boot / HV RAM boot /
     display / device roster: <which> / power and idle. -->

## Current status

<!-- QUALIFIED (proven) or UNQUALIFIED (and what is missing). -->

## Exit criterion

<!-- What "qualified" means for this rung, and the evidence that will prove it. -->

## Cross-generation

<!-- Is it built from ADT/DT fields and chip-wide facts so it carries to other machines?
     Any board gate needs a documented hardware reason. -->

## Reference / tracing

<!-- If this needs a reference trace, link the plan. Safety rules (dead-man, tether,
     read before write) are in policy/tracing-guidelines.md. -->
