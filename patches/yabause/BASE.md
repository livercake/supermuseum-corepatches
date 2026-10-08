# Yabause (Saturn fallback) — provenance

| Field | Value |
|---|---|
| Upstream | `https://github.com/EmulatorJS/yabause` |
| Pinned base commit | `10d64eaf4dc4aec66cc60a4a9cd0d1255493f6a6` |
| License | **GPL-2.0** |
| Role in SuperMuseum | Saturn fallback for titles that fail on Beetle. Jan-2024 vintage pinned — newer yabause regresses Radiant Silvergun with age. |

Exposes the console's internal 64KB backup RAM (`BupRam`) on `RETRO_MEMORY_SAVE_RAM`
so battery saves persist through the museum's standard SRAM pipeline. Without it, Saturn
games have no save mechanism at all on this core.

## Patch series (1)

1. `0001-MUSEUM-FIX-expose-BupRam-on-RETRO_MEMORY_SAVE_RAM.patch`

Apply against the pinned base commit:

```bash
git clone https://github.com/EmulatorJS/yabause
cd yabause
git checkout 10d64eaf4dc4aec66cc60a4a9cd0d1255493f6a6
git am *.patch
```

Net effect: **1 file changed, 16 insertions** (`yabause/src/libretro/libretro.c`),
verified to apply cleanly to a pristine checkout.

## Note on the collapsed series

The development history for this patch was apply → revert → re-apply: an initial
commit, a revert after a bad rebuild wiped the source tree, and a re-apply as
`23e749df`. That history is preserved in the build tree at
`~/core-builds/source/yabause-2401`, but **not** published here.

A fix/revert/reapply series is confusing for anyone auditing what we actually changed,
and the net result is identical to a single patch. The published series is therefore
collapsed to the net diff. This is the only set where the published series does not
match the commit-by-commit history one-for-one.

## Files touched

- `yabause/src/libretro/libretro.c`
