# Beetle PSX (software) — provenance

| Field | Value |
|---|---|
| Upstream | `https://github.com/libretro/beetle-psx-libretro` |
| Pinned base commit | `4e608ad5` |
| License | **GPL-2.0** |
| Role in SuperMuseum | PSX core, sole core since 2026-09-30. |

Patch: `sthread_get_core_topology` stub. The EJS harness ships an older rthreads predating the Sep-2026 topology API, so Beetle's HD-texture prefetch pool aborts at startup without it. Returns `false`, selecting the historical 4-worker default consoles also take.

## Patch series (1)

1. `0001-MUSEUM-FIX-2026-09-29-stub-sthread_get_core_topology.patch`

Apply in order against the pinned base commit:

```bash
git clone https://github.com/libretro/beetle-psx-libretro
cd <repo>
git checkout 4e608ad5
for p in *.patch; do git am "$p" || git am --3way "$p"; done
```

`git am` rather than `patch`, so the series preserves one logical fix per commit and
the provenance recorded in each commit message survives.

## Files touched

- `museum_sthread_topology_stub.c`
