# Hotfixes

> **Status: IN USE** (since 2026-11-24).

Kind: hard rules. How a broken stable release (`v*`) is fixed. Everything not covered here is fixed forward on `main` and ships in the next release ([`branching-and-releases.md`](branching-and-releases.md)).

## When

A hotfix is allowed only for a problem **in a published stable release** that causes:

- a boot failure,
- data loss or filesystem corruption,
- a security vulnerability, or
- a risk of hardware damage (for example speaker protection or thermal limits not applied).

A missing feature, a performance regression or a cosmetic bug is never a hotfix. An Owner decides whether a case qualifies.

## How

1. **Branch.** An Owner creates `hotfix/v<X.Y.Z>` from the stable tag `v<X.Y.Z>` being fixed. Only Owners can create `hotfix/` branches (enforced).
2. **Fix.** The fix goes in as a PR into `hotfix/v<X.Y.Z>` and meets the [merge policy](merge-policy.md): CI, a hardware row on the affected Mac **and** the stable regression gate on all seven lab Macs (it becomes a stable release), and a non-author review; an Owner merges it. Prefer cherry-picking a fix that is already on `main` (`git cherry-pick -x`); otherwise write the smallest fix.
3. **Tag.** An Owner tags `v<X.Y.Z+1>` on the hotfix branch and pushes the tag. CI builds and publishes it as the new stable release. CI accepts a stable tag that is not on `main` only from a `hotfix/` branch.
4. **Forward-port.** The same fix goes to `main` by a normal PR within one working day, unless it was cherry-picked from `main` in step 2. Each forward-ported commit carries a `Forward-port: <sha>` trailer naming the hotfix commit.
5. **Clean up.** Delete the hotfix branch once the forward-port PR has merged. The tag keeps the history.

## Security

Security problems are reported privately ([`SECURITY.md`](https://github.com/aurora-silicon/.github/blob/main/SECURITY.md)). Do the fix in a private fork or a draft security advisory, not in a public PR, until the fixed release is published. Upstream stable updates that carry security fixes are merged into `main` at once ([`branching-and-releases.md`](branching-and-releases.md), 2.2) and, if a stable release is affected, shipped as a hotfix.
