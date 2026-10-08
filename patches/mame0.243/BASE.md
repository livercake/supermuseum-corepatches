# MAME 0.243 — provenance

| Field | Value |
|---|---|
| Upstream | `https://github.com/libretro/mame` |
| Pinned base commit | `0070092b03` |
| License | **GPL-3.0** (MAME) + bundled BSD-licensed 3rdparty |
| Role in SuperMuseum | Arcade core. 20 games: Steep Slope Sliders, Final Fight Revenge, Cotton 2/BM, Daytona USA, Sega Rally, Time Crisis, Point Blank, Lethal Enforcers, Virtua Cop, Tekken, and others. |

Patches: force the SH interpreter (the DRC recompiler hangs under WASM), the `__LIBRETRO__` build guard, ST-V reinit suppression + post-state video nudge, m2comm in-memory loopback for Model 2 networking, and emscripten build fixes for sol2/genie/retro.

## Patch series (5)

1. `0001-MUSEUM-FIX-2026-08-10-guard-emscripten_set_running_m.patch`
2. `0002-MUSEUM-FIX-2026-08-10-force-the-plain-SH-interpreter.patch`
3. `0003-MUSEUM-FIX-2026-08-10-2026-08-13-ST-V-reinit-suppres.patch`
4. `0004-MUSEUM-FIX-2026-08-10-in-memory-loopback-for-m2comm-.patch`
5. `0005-MUSEUM-FIX-emscripten-build-compatibility-for-sol2-g.patch`

Apply in order against the pinned base commit:

```bash
git clone https://github.com/libretro/mame
cd <repo>
git checkout 0070092b03
for p in *.patch; do git am "$p" || git am --3way "$p"; done
```

`git am` rather than `patch`, so the series preserves one logical fix per commit and
the provenance recorded in each commit message survives.

## Files touched

- `3rdparty/sol2/sol/sol.hpp`
- `scripts/genie.lua`
- `scripts/src/osd/retro.lua`
- `src/devices/cpu/sh/sh2.cpp`
- `src/emu/machine.cpp`
- `src/mame/machine/m2comm.cpp`
- `src/mame/machine/m2comm.h`
- `src/osd/libretro/libretro-internal/libretro.cpp`
