# Beetle Saturn — provenance

| Field | Value |
|---|---|
| Upstream | `https://github.com/libretro/beetle-saturn-libretro` |
| Pinned base commit | `1382b85` |
| License | **GPL-2.0** |
| Role in SuperMuseum | Saturn core, platform default since 2026-09-10. |

Patches: WorkRAM descriptors for RetroAchievements, and CHD header diagnostics — the logging that drove the 2026-09-06 `err=27` investigation.

## Patch series (2)

1. `0001-MUSEUM-FIX-2026-09-15-expose-WorkRAM-descriptors-for.patch`
2. `0002-MUSEUM-DIAG-distinguish-CHD-header-corruption-from-c.patch`

Apply in order against the pinned base commit:

```bash
git clone https://github.com/libretro/beetle-saturn-libretro
cd <repo>
git checkout 1382b85
for p in *.patch; do git am "$p" || git am --3way "$p"; done
```

`git am` rather than `patch`, so the series preserves one logical fix per commit and
the provenance recorded in each commit message survives.

## Files touched

- `libretro.c`
- `mednafen/cdrom/CDAccess_CHD.c`
