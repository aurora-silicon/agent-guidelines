# IP and Tainted Data

> **Status: DRAFT. Not in force yet.** The [pre-PR checklist](../pre-pr-checklist.md) is in use today; where this draft and the checklist differ, the checklist wins.

Kind: **hard rules**. This page keeps the public code clean-room and legally defensible. When in doubt, keep it private and ask. See the glossary in [`AGENTS.md`](../AGENTS.md).

## Public

Goes in repos and may be cited in PRs:

- **Our own traces, captures and measurements**: dtrace, log streams, ioreg, timings, mic and rig recordings of our own tests.
- **Our own compiled outputs**: compiled shaders, and ANE (neural engine) compiler output (decoded task words, reference JSONs, constant sections, generated `*Templates.inc`) built from our own programs and weights or from our own captures of public models. Review these for code quality, not for taint.
- **Interface facts and hardware truths**: register setup, bus and QoS configuration, and other facts that are the same on every Mac with that chip, written clean-room into the driver or devicetree.
- **Values aura copies from the ADT into the DT at boot** (for example PMP tunables). They are interface data. Do not extract them or paste the raw values into source.

## Tainted

Never in a public repo, PR, issue or channel:

- Verbatim Apple code or strings.
- Firmware blobs and anything extracted from them.
- Decompiled or disassembled output, including constants, tables or code lifted from it into our source.
- Apple per-unit tuning and calibration values (for example speaker tuning). These reach a device only through extraction by the installer on that device, never through source.

Tainted material lives only in private storage clearly marked as tainted. Public work may refer to it and never quotes it.

## Reverse-engineering

Reverse-engineering (RE) to understand Apple hardware and firmware is a normal part of bring-up. Publishing the Apple-derived result is what is forbidden.

- RE may use any tool or model. None is mandated.
- RE output is tainted and stays private.
- Published code is clean-room: written from named, commented fields and documented hardware facts, not pasted from RE.

**The test:** could a reviewer who sees only our public source, with no Apple binary, understand every hardware value from its named field and comment? If yes, it is clean-room. If a constant only makes sense because it matches an Apple firmware word, it is tainted.

Where a hardware value comes from, in order of preference:

1. The ADT provides it and aura copies it into the DT at boot. No value in source.
2. It is a fact common to the chip. Write it clean-room.
3. It is a per-unit Apple tuning value. Only the installer extracts it, on the device.

Reviewers check the whole diff for taint before merge ([`pr-review.md`](pr-review.md)).

## Licensing

- Aurora contributions: GPL-2.0-only. Inherited `aura` code: MIT. Mixed files: `MIT AND GPL-2.0-only`. *(Open question: repos whose base licence differs, such as mesa (MIT) and u-boot (GPL-2.0-or-later).)*
- Every commit has a human `Signed-off-by` (DCO). Agents do not sign off ([`commits-and-performance.md`](commits-and-performance.md)).

## Upstreaming

Never upstream to anti-AI projects: Asahi Linux, NT-for-ASi, upstream Mesa, FEX, or similar. The upstream Linux kernel is fine. *(Open question: how this interacts with an upstream AI-disclosure tag requirement.)*
