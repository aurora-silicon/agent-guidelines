# Device Bring-up Ladder

> **Status: IN FORCE** (since 2026-11-24). Change it by PR here.

Kind: defaults. The hardware-safety and tainted-data items are hard rules; they are linked where they apply. See "Two kinds of rule" and the glossary in [`AGENTS.md`](../AGENTS.md).

The order for bringing a new Mac or chip up on Linux. Each rung has an exit criterion. Do not climb until the rung below is **qualified**: proven by a test, not "seems to work".

## Baseline

- M1/M2/M3 boot behaviour, and the behaviour of proxyclient (the host-side tool that drives aura over USB), is the implementation standard. A new chip (Neo/J700, M4 Pro/J616s) must reach feature parity with it.
- Every generation restarts its coprocessors at each boot layer. No hot hand-offs.
- Firmware is pinned to the supported version: currently macOS 27.2 for the Linux stub (the small macOS-side install that supplies firmware and the boot object). *(Open question: the pin has no linked decision document yet.)*

## The ladder

1. **CPU and clocks**: cores up, clock tree, power manager (PMGR). Exit: cores run at the expected frequencies, measured and not only reported.
2. **SMP and MMU**: secondary CPUs, page tables, exceptions. Exit: all cores online, stable.
3. **Memory controller**: DRAM config, carve-outs. Exit: memory map correct, no corruption.
4. **USB RAM boot**: boot a kernel over the USB cable through aura. Exit: repeatable.
5. **HV RAM boot** (where applicable): boot under the aura hypervisor. Exit: guest runs.
6. **Display (DCP, the display coprocessor)**: panel and external outputs. Exit: panel lights, modeset stable, external DP/HDMI where present, no PHY faults.
7. **Device roster**: bring up each device and mark it qualified or unqualified: SIO, AOP, audio (headset, headphone, speaker), input (keyboard, trackpad, MTP), SEP, ISP/camera, SuperSpeed/USB4, NVMe, Wi-Fi/BT, CPU and GPU P-states. Exit: every device has a stated status.
8. **Power and idle**: runtime PM, s2idle and deep sleep, platform profiles. Exit: idle and sleep power at or below macOS for the same content, reliable resume.

## Working rules

- **State every subsystem's status.** "Unqualified" is honest and useful. A silent assumption is not.
- **Hardware safety applies on every rung**: dead-man, read before write, no Stage 1 change without the owner, speaker protection intact ([`tracing-guidelines.md`](tracing-guidelines.md)).
- **Write for every generation from the start.** Build hardware setup from named ADT/DT fields and facts common to the chip so the rung carries to the next machine. A board gate needs a hardware reason ([`commits-and-performance.md`](commits-and-performance.md)).
- **Reference traces**: if a rung needs a macOS reference or a self-trace, the content and safety rules in [`tracing-guidelines.md`](tracing-guidelines.md) apply. The procedures are not written yet.
- **Record the machine's ladder state** in its bring-up issue so the next person starts from the real rung.
