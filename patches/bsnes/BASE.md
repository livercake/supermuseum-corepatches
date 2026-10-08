# bsnes (SNES deluxe) — provenance

| Field | Value |
|---|---|
| Upstream | `https://github.com/EmulatorJS/bsnes-libretro` |
| Pinned base commit | `4b34474` |
| License | **GPL-3.0** |
| Role in SuperMuseum | Optional 'deluxe' SNES core; the default is snes9x. Higher accuracy, far too heavy for default. |

Patch: Justifier input support. Stock `pollInputDevices()` had a SuperScope case but none for Justifier, so every Justifier input was silently dropped despite `set_controller_ports` connecting the device. Also fixes `latch()` to honor absolute/relative pointer mode.

## Patch series (1)

1. `0001-MUSEUM-FIX-2026-09-09-add-Justifier-input-support-to.patch`

Apply in order against the pinned base commit:

```bash
git clone https://github.com/EmulatorJS/bsnes-libretro
cd <repo>
git checkout 4b34474
for p in *.patch; do git am "$p" || git am --3way "$p"; done
```

`git am` rather than `patch`, so the series preserves one logical fix per commit and
the provenance recorded in each commit message survives.

## Files touched

- `bsnes/sfc/controller/justifier/justifier.cpp`
- `bsnes/target-libretro/program.cpp`
