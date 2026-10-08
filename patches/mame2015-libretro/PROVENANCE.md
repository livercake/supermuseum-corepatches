# mame2015-libretro — provenance

## Re-derivation record (2026-10-07)

The original build workspace `~/mame2015-web/` was deleted after compiling.
This tree was reconstructed from upstream and the documented patch re-applied.

### The repo was renamed, not deleted

An initial audit concluded the upstream was gone. That was **wrong** — a name
mismatch. The three versioned libretro MAME forks all now return "Not Found"
under their old names because libretro renamed them:

| Old name (404) | Current name | Status |
|---|---|---|
| `libretro/mame2015` | **`libretro/mame2015-libretro`** | live, 397 MB, pushed 2026-09-06 |
| `libretro/mame0.243` | `libretro/mame0243-libretro` (assumed) | n/a — local source exists |
| `libretro/mame2003-plus` | `libretro/mame2003-plus-libretro` | live |

The full current roster of libretro MAME repos:

```
hbmame-libretro      mame2000-libretro    mame2003-libretro
mame2003-plus-libretro  mame2003_midway   mame2009-libretro
mame2010-libretro    mame2015-libretro    mame2016-libretro
mame (rolling master)
```

**Lesson recorded:** a GitHub 404 on a remembered repo URL is not proof of
deletion. Query `https://api.github.com/orgs/libretro/repos` before concluding
anything is gone. Software Heritage
(`archive.softwareheritage.org/api/1/origin/search/<owner>/<repo>/`) is a
useful second source — it surfaced the correct `-libretro` name here.

### Base

| Field | Value |
|---|---|
| Upstream | `https://github.com/libretro/mame2015-libretro` |
| Commit | `7adbf440d5f554097f58f8c6ebb673adc4320a31` |
| Upstream description | "Late 2014/Early 2015 version of MAME (0.160-ish) for libretro. Compatible with MAME 0.160 sets." |
| Base commit (this repo) | `47e1b6a` — pristine upstream, 11,461 files |
| Museum patch commit | `cc8ef76` |

Note AGENTS.md describes this core as "MAME 0.159"; upstream self-describes as
"0.160-ish". Consistent for a late-2014 tree; the discrepancy is upstream's
own labelling, not a reconstruction error.

## The patch

Exactly **one** source patch, 13 added lines, no deletions:

```
src/osd/retro/retromain.c | 13 +++++++++++++
```

`Add_Option("-nodrc")` in `Set_Default_Option()` — forces the SH-2 off the DRC
recompiler, which hangs under WebAssembly.

AGENTS.md's "three critical build gotchas" are **not three source patches**:

| Gotcha | Actually is |
|---|---|
| 1. `-nodrc` in `retromain.c` | **the one real source patch** |
| 2. ST-V zips need `version_needed <= 20` | a **ROM-asset** requirement, not source — ROMs live on R2 and are unaffected |
| 3. "surgical archive" linking | a **link procedure**; its recipe lived in the deleted `~/mame2015-web/` build logs |

So the source-side delta was one line of intent. The patch was re-derived from
AGENTS.md's description and verified against the actual source: the cited
symptom line exists verbatim at `src/emu/cpu/sh2/sh2.c:186`
(`m_isdrc = mconfig.options().drc() ? true : false;`).

Note this vintage uses the **older** MAME CPU layout (`src/emu/cpu/sh2/`), not
the `src/devices/cpu/sh/` path used by mame0.243. AGENTS.md's mame0.243 patch
reference does not apply to this tree.

## What is NOT recovered

The **link recipe** (gotcha 3) remains unrecorded. It was: link from a surgical
archive = the stale flat `libretro_emscripten.a` + replaced exception-critical
objects (those importing `__cxa_begin_catch`, e.g. `machine.o` with 18
`invoke_*` imports) taken from the freshly-built `.bc`, plus a recompiled
`retromain.o`. Full nested `.bc` archives are rejected by wasm-ld. Compile/link
runs must clear poisoned `CFLAGS`/`CXXFLAGS` env vars and go through `emmake`.

**Consequence:** a from-scratch rebuild is not yet reproducible from this tree
alone. The *source* is recovered and GPL §3(a)-compliant; the *build procedure*
is not.

## Verification status

| Check | Status |
|---|---|
| Patch applies to pristine upstream | ✅ verified |
| Symptom line cited by AGENTS.md exists in this vintage | ✅ `sh2.c:186` |
| Rebuild reproduces `staging/cores/mame2015/MD5SUMS.txt` | ❌ **not attempted** |
| Compiles | ❌ **not attempted** |

The shipped binaries survive with known hashes:

```
c90a2bb6b2cc168deb834b11fbe2c0a8  mame2015-legacy-wasm.data
ba7c3045352f89f30eec9fbbdcb33b55  mame2015-wasm.data
```

An MD5 match after rebuild would prove the reconstruction complete. A mismatch
would be ambiguous — ordinary build nondeterminism and a wrong commit look the
same from here.

## Games

AGENTS.md's list for this core is **stale**. Live `public/json/arcade.json`:

- **mame2015 (4):** `espgal2` (Espgaluda II), `rsgun` (Radiant Silvergun),
  `diehard` (Die Hard Arcade), `kov2p` (Knights of Valour 2 Plus)
- **mame0.243 (20):** includes `sss` and `ffreveng`, which migrated away

Of the remaining four, only `rsgun` is documented as needing `-nodrc`
(`espgal2` runs SH3-interpreter regardless). `diehard` and `kov2p` are
undocumented in AGENTS.md's mame2015 context.
