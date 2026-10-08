# RetroArch harness (EJS link layer) — provenance

| Field | Value |
|---|---|
| Upstream | `https://github.com/EmulatorJS/RetroArch` |
| Pinned base commit | `170ffa7170` |
| License | **GPL-3.0** |
| Role in SuperMuseum | Build harness linking every self-built core. Not shipped as a binary — the patches here are required to **rebuild any self-built core**. |

**Highest-value set in this directory.** `retroarch.c` + `Makefile.emulatorjs` carry the `ejs_get_memory_map` and `ejs_threads` exports that the RA memory-descriptor path depends on for every self-built core. Lose these and no self-built core can be rebuilt at all.

## Patch series (6)

1. `0001-MUSEUM-FIX-2026-09-13-export-ejs_get_memory_map-for-.patch`
2. `0002-MUSEUM-FIX-2026-09-29-wrap-osd_message-for-Beetle-PS.patch`
3. `0003-MUSEUM-SPIKE-2026-09-06-add-filestream_get_mapped_pt.patch`
4. `0004-MUSEUM-FIX-rename-chd-symbols-for-internal-use-MAME-.patch`
5. `0005-MUSEUM-FIX-noCHD-largeStack-largeHeap-no7Zip-arrays-.patch`
6. `0006-MUSEUM-ignore-packed-core-artifacts-wasm.data.patch`

Apply in order against the pinned base commit:

```bash
git clone https://github.com/EmulatorJS/RetroArch
cd <repo>
git checkout 170ffa7170
for p in *.patch; do git am "$p" || git am --3way "$p"; done
```

`git am` rather than `patch`, so the series preserves one logical fix per commit and
the provenance recorded in each commit message survives.

## Files touched

- `.gitignore`
- `Makefile.common`
- `Makefile.emulatorjs`
- `emulatorjs/build-emulatorjs.sh`
- `libretro-common/streams/file_stream.c`
- `museum_osd_wrap.c`
- `retroarch.c`
