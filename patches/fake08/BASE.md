# fake-08 (PICO-8) — provenance

| Field | Value |
|---|---|
| Upstream | `https://github.com/jtothebell/fake-08` |
| Pinned base commit | `814991a` |
| License | **MIT** |
| Role in SuperMuseum | PICO-8 core (128 carts). Not a hardware emulator — a PICO-8 fantasy-console VM. |

Patches: `pmem()` plus Lua `-DLUA_USE_LONGJMP` (coroutine unwinding escapes uncaught
under Emscripten and kills the main loop), cartdata/userData persistence for multicart
handoff, and test-harness fixes so the native rig actually prints diagnostics.

**Scope note:** only the files listed below are museum changes. The upstream tree also
carries 160+ `.p8.png` test-cart fixtures under `test/`; those are upstream/onboarding
material and are deliberately NOT part of this series.

## Patch series (3)

1. `0001-MUSEUM-FIX-2026-08-22-pmem-Lua-longjmp-for-the-emscr.patch`
2. `0002-MUSEUM-FIX-2026-08-22-2026-08-23-cartdata-persistenc.patch`
3. `0003-MUSEUM-FIX-2026-08-22-2026-08-23-test-harness-fixes-.patch`

Apply in order against the pinned base commit:

```bash
git clone https://github.com/jtothebell/fake-08
cd fake-08
git checkout 814991a
for p in *.patch; do git am "$p" || git am --3way "$p"; done
```

`git am` rather than `patch`, so the series preserves one logical fix per commit and
the provenance recorded in each commit message survives.

## Files touched (11)

- `platform/libretro/Makefile`
- `platform/libretro/libretro.cpp`
- `source/PicoRam.h`
- `source/p8GlobalLuaFunctions.h`
- `source/picoluaapi.cpp`
- `source/picoluaapi.h`
- `source/vm.cpp`
- `source/vm.h`
- `test/customLuaTests.cpp`
- `test/nooplogger.cpp`
- `test/vmtests.cpp`
