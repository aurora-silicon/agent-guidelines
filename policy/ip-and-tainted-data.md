# IP and Tainted Data

> **Status: IN FORCE** (since 2026-11-24). Change it by PR here.

Kind: **hard rules**. This page keeps Apple's copyrighted material out of our public work while welcoming reverse-engineering contributions. When in doubt, ask in the PR. See the glossary in [`AGENTS.md`](../AGENTS.md).

## Public

Goes in repos and may be cited in PRs:

- **Our own traces, captures and measurements**: dtrace, log streams, ioreg, timings, mic and rig recordings of our own tests.
- **Our own compiled outputs**: compiled shaders, and ANE (neural engine) compiler output (decoded task words, reference JSONs, constant sections, generated `*Templates.inc`) built from our own programs and weights or from our own captures of public models. Review these for code quality, not for taint.
- **Interface facts and hardware truths**: register setup, bus and QoS configuration, and other facts that are the same on every Mac with that chip, written clean-room into the driver or devicetree.
- **ADT values are hardware facts**, from any source (a live machine, an m1n1 dump, an IPSW's device tree): read them, cite them in PRs and rows. Drivers still read them from the DT at runtime rather than copying them into per-board tables ([pre-PR checklist](../pre-pr-checklist.md), item 1).

## Never in public: Apple's own material

Public repos, PRs, issues, gists and channels never contain Apple's copyrighted material itself:

- Verbatim Apple code, and decompiled or disassembled listings.
- Apple strings or symbol dumps copied beyond the names needed to interoperate.
- Apple files: firmware blobs, tuning sets, calibration bundles. The installer extracts what a Mac needs from the IPSW, on that Mac ([`AGENTS.md`](../AGENTS.md), hard rule 2).
- Per-unit calibration values and device secrets. They stay on the device.

RE byproducts (raw listings, addresses, symbol tables, dumps) live only in private storage marked as tainted. Public work may refer to them and never quotes them.

## Reverse-engineering contributions are welcome

Reverse-engineering (RE) Apple hardware and firmware is how this project works, with any tool or model. The rule protects us from shipping Apple's copyrighted code; it does not stop RE work from landing.

- **Welcome in public:** drivers, firmware-interface layouts (structs, message formats, queues), register and protocol descriptions, and the constants needed to interoperate, written as **our own code** with named, commented fields.
- **Not welcome:** a pasted listing, a translated function body, or a table copied wholesale from a binary with no explanation of what its fields mean.

**The test:** is this our own description of how the hardware or interface works, with named fields a reviewer can follow? Then it belongs in public. Is it Apple's code or data copied across? Then it stays private.

Where a hardware value comes from, in order of preference:

1. The ADT provides it and aura copies it into the DT at boot. No value in source.
2. It is a fact common to the chip. Write it clean-room.
3. It is per-model firmware data (tuning sets, DSP tables). The installer extracts it from the matching IPSW, on the user's Mac.
4. It is per-unit (calibration, keys). It is read from the machine at runtime and never leaves it.

Reviewers check the whole diff for copied Apple material before merge ([handbook](review-and-merge-handbook.md)).

## Licensing

- Aurora contributions: GPL-2.0-only. Inherited `aura` code: MIT. Mixed files: `MIT AND GPL-2.0-only`. *(Open question: repos whose base licence differs, such as mesa (MIT) and u-boot (GPL-2.0-or-later).)*
- Every commit has a human `Signed-off-by` (DCO). Agents do not sign off ([`commits-and-performance.md`](commits-and-performance.md)).

## Upstreaming

Never upstream to anti-AI projects: Asahi Linux, NT-for-ASi, upstream Mesa, FEX, or similar. The upstream Linux kernel is fine.
