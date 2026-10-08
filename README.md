# supermuseum-corepatches — Corresponding Source for SuperMuseum's emulator cores

SuperMuseum is a browser museum that runs games through emulators. Several of those
emulators are **GPL-licensed and modified by us**. When we distribute a modified GPL
binary, the GPL requires us to convey its *Corresponding Source* — the upstream it was
derived from, **plus our patches**, at no charge.

That is what this repository is.

It exists so that anyone can answer: *"what exactly are you running, and what did you
change?"* — for every core, without asking us.

---

## What SuperMuseum is, in GPL terms

SuperMuseum is **not** an emulator and does not claim to be. It is a Vue 3 web
application that loads unmodified or lightly-patched libretro cores compiled to
WebAssembly, presents them as cartridges in a 3D gallery, and hosts the ROMs.

The emulators themselves are the work of other people. We:

- select and configure cores per platform,
- **patch a small number of them** for WebAssembly and RetroAchievements support,
- publish the resulting binaries.

Those patches are the thing GPL requires us to publish. They are here.

---

## The patch sets

Every set is a `git format-patch` series against a **pinned upstream commit**, so it
applies cleanly and reproducibly.

| Directory | Upstream | Base commit | License | Role |
|---|---|---|---|---|
| [`retroarch-harness/`](retroarch-harness/) | [EmulatorJS/RetroArch](https://github.com/EmulatorJS/RetroArch) | `170ffa71` | GPL-3.0 | Build harness linking every self-built core |
| [`mame0.243/`](mame0.243/) | [libretro/mame](https://github.com/libretro/mame) | `0070092b` | GPL-3.0 + BSD 3rdparty | Arcade core (20 games) |
| [`mame2015-libretro/`](mame2015-libretro/) | [libretro/mame2015-libretro](https://github.com/libretro/mame2015-libretro) | `7adbf440` | GPL-3.0 | Arcade core (4 games) |
| [`fake08/`](fake08/) | [jtothebell/fake-08](https://github.com/jtothebell/fake-08) | `814991a` | MIT | PICO-8 core (128 carts) |
| [`mednafen-saturn/`](mednafen-saturn/) | [libretro/beetle-saturn-libretro](https://github.com/libretro/beetle-saturn-libretro) | `1382b85` | GPL-2.0 | Saturn core (default) |
| [`mednafen-psx/`](mednafen-psx/) | [libretro/beetle-psx-libretro](https://github.com/libretro/beetle-psx-libretro) | `4e608ad5` | GPL-2.0 | PSX core (sole) |
| [`bsnes/`](bsnes/) | [EmulatorJS/bsnes-libretro](https://github.com/EmulatorJS/bsnes-libretro) | `4b34474` | GPL-3.0 | Optional "deluxe" SNES core |
| [`yabause/`](yabause/) | [EmulatorJS/yabause](https://github.com/EmulatorJS/yabause) | `10d64eaf` | GPL-2.0 | Saturn fallback core |
| [`emulatorjs-4.3.0-pre/`](emulatorjs-4.3.0-pre/) | [EmulatorJS/EmulatorJS](https://github.com/EmulatorJS/EmulatorJS) | `4.3.0-pre` | GPL-3.0 | The frontend every game runs through |

Each directory has a `BASE.md` with full provenance, the patch list, and the files
touched. Read those first.

### License verification

Licenses were verified against **source**, not against a metadata field. Four cores
listed an empty `license` in the upstream manifest; all four were checked:

| Core | In use? | Verified license | How verified |
|---|---|---|---|
| `mupen64plus_next` | **yes** — 12 games | **GPL-2.0** | Read directly: upstream `LICENSE` (18,092 bytes), "GNU GENERAL PUBLIC LICENSE Version 2, June 1991" |
| `parallel_n64` | **yes** — N64 platform default | **GPL-2.0** | By ancestry: its README is titled `mupen64plus-libretro`; Mupen64Plus-Core's own `LICENSES` states "licensed under the GNU General Public License version 2" with the full text at `doc/gpl-license`. `EmulatorJS/parallel-n64` itself ships **no** license file |
| `fbalpha2012_cps1` | **no** — 0 games, not a default | *not verifiable* | No license file, no README, no source header. MAME-derived code, but nothing declares a license |
| `fbalpha2012_cps2` | **no** — 0 games, not a default | *not verifiable* | As above |

The two cores actually in use are both GPL-2.0, verified. The two that cannot be
verified are unreachable — no game in the collection runs on them — so they fall under
the blanket statement above rather than requiring a claim we cannot support.

### Unmodified cores

These ship as-is from EmulatorJS and are **not patched by us**, so their Corresponding
Source is simply the upstream source at the shipped version:

`snes9x`, `gambatte`, `mgba`, `nestopia`, `fbneo`, `fbalpha2012_cps1`,
`fbalpha2012_cps2`, `genesis_plus_gx`, `picodrive`, `mednafen_pce`, `ppsspp`,
`mednafen_ngp`, `mame2003_plus`, `fbneo`, and the remaining stock cores listed in
SuperMuseum's `public/emulatorjs/data/cores/cores.json`.

We also ship `EmulatorJS` itself (the frontend), which **is** patched — see
`emulatorjs-4.3.0-pre/`.

> **Unmodified cores are redistributed as built and published by EmulatorJS, whose
> source for each is public at the project linked in that project's own metadata.
> SuperMuseum patches only the cores marked in the table above.** This blanket
> statement covers the stock cores we ship but never launch — including several whose
> upstream repositories declare **no license file at all** (notably the FinalBurn Alpha
> ports `fbalpha2012_cps1` / `fbalpha2012_cps2`, whose source carries MAME-derived code
> but no license notice). No game in the collection runs on those; they are retained
> only as build-system fallbacks, and we make no license claim on their behalf.

---

## Applying a patch set

Each directory is a self-contained series against its pinned base:

```bash
git clone https://github.com/libretro/beetle-psx-libretro
cd beetle-psx-libretro
git checkout 4e608ad50694777150eb868c0d97e4e27dbf0a8e
for p in /path/to/patches/*.patch; do git am "$p" || git am --3way "$p"; done
```

`git am` rather than `patch`, so one logical fix stays one commit and the provenance
recorded in each message survives.

**Verification status (2026-10-07):** all 22 patches across all 9 sets were applied to
a pristine checkout of their pinned upstream commit. **Zero rejects.**

---

## Why the RetroArch harness matters most

[`retroarch-harness/`](retroarch-harness/) is not a shipped binary, but its patches are
required to **rebuild any self-built core**. `retroarch.c` and `Makefile.emulatorjs`
carry the `ejs_get_memory_map` export that the RetroAchievements memory-descriptor path
depends on. If you are trying to reproduce a SuperMuseum core build and the link fails
with a missing `ejs_get_memory_map`, that is why — apply this series first.

---

## Building the actual `.wasm.data` cores

Publishing the *source* is what GPL requires and what this repo provides. Reproducing the
exact **binaries** additionally requires the SuperMuseum build harness (emscripten
version, link flags, per-core quirks) which is documented in the project's
`AGENTS.md` and is **not** fully captured here. Several SuperMuseum binaries were linked
at non-default optimisation levels to fit available memory, and the exact command lines
are not all preserved.

If you need bit-identical binaries, open an issue and ask. We would rather help than
have you guess.

---

## License

The patches in this repository are ours to license and are released under the
**GPL-3.0**, matching the cores they patch. Each upstream project retains its own
copyright and license — see that project's own LICENSE file. Full license texts are in
[`licenses/`](licenses/).

Nothing here supersedes or re-licenses upstream work.
