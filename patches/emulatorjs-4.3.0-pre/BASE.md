# EmulatorJS — base revision and content hashes

## Provenance

| Field | Value |
|---|---|
| Project | [EmulatorJS/EmulatorJS](https://github.com/EmulatorJS/EmulatorJS) — "A web-based frontend for RetroArch" |
| License | **GPL-3.0** |
| Base version | `4.3.0-pre` |
| Upstream source | `https://cdn.emulatorjs.org/4.3.0-pre/data/src/emulator.js` |
| CDN `Last-Modified` | `Sun, 17 May 2026 16:54:42 GMT` |
| CDN ETag | `"10708492"` |

`4.3.0-pre` is a **pre-release**. Per upstream CHANGES.md: *"This is a PRE RELEASE. It is
not marked as stable for a reason... Cores are not inter-changeable between versions."*

## Content hashes — pin by content, not by label

The `4.3.0-pre/` CDN directory could in principle be re-published. These SHA-256 values
are the stable identity; the version label alone is not sufficient.

### Upstream baseline (what the patch applies to)

| File | SHA-256 |
|---|---|
| `4.3.0-pre/data/src/emulator.js` | `182aa14dd0f874b308220fbaa8aad66eff4a83fe4dae4163543adebfa21f9ed9` |
| `4.3.0-pre/data/emulator.min.js` | `b5f88bdfc57c11b76e20e7393c51e2257efde7637e48565be702e0d6590fb5ea` |

### SuperMuseum vendored (what ships)

| File | SHA-256 |
|---|---|
| `public/emulatorjs/data/src/emulator.js` | `afa64e8ffb6f88d29a49fb4ef16bdf3380f45f3761613aabc2adac67d876af0d` |
| `public/emulatorjs/data/emulator.min.js` | `8980d343fedf95f496f86cb18de334354dc17ff5401e9747e5464428f87d5fbf` |

## The patch

`src.diff` — 25 hunks, +287 / −119 lines — is the complete difference between upstream
`4.3.0-pre` and the vendored `src/emulator.js`. It is the Corresponding Source delta
required by GPL-3.0 §6 for the frontend as distributed.

### Provenance audit (2026-10-07)

The vendored tree was diffed against upstream to confirm it is a **clean single-era
build**, not a franken-build of `4.3.0-pre` + `latest`. Result: **all nine documented
patches present, no version interleave, no unreferenced additions.**

| Patch | Signature confirmed |
|---|---|
| A — menu-bar reveal gating | `EJS_MOUSE_GAME` |
| B — `lightgunActive` cursor caveat | *observation, not a code change* (6 occurrences in both trees) |
| C — core report JSON decode | `TextDecoder().decode` |
| D — shader-menu `.glsl` filter | `endsWith(".glsl")` |
| E — per-platform control schemes | `"pico8" === this.getControlScheme()`, `["segaMD","segaCD","sega32x","genesis"]` |
| F — arcade cabinet control scheme | `BUTTON 1` |
| G — sidecar progress + caching | the `attempt` retry wrapper |
| H — input-descriptor audit + touch overlays | `Patch H addendum`, `arcade touch overlay` |
| I — `loadSettings` analog backfill | `PATCH I (2026-09-09)` |

### Applying

```bash
./verify.sh          # from this directory — full round-trip check
```

or manually:

```bash
curl -sL https://cdn.emulatorjs.org/4.3.0-pre/data/src/emulator.js -o upstream.js
sha256sum upstream.js   # must equal the baseline hash above
mkdir -p src && cp upstream.js src/emulator.js
patch -p1 -d . < src.diff
sha256sum src/emulator.js  # must equal the vendored hash above
```

## Note on `emulator.min.js`

`emulator.min.js` is a **faithful minification of the patched source**, not an
independently hand-maintained artifact. Confirmed by:

- identifier counts matching the source exactly (`ejs_menu_bar`: 10 in both trees);
- a statement-level diff against upstream min resolving entirely to minifier variable
  renames (`t.bytes` → `i.bytes`), not logic changes;
- the largest apparent deletion (`-83/+76`) being Patch G's retry wrapper with the
  download logic preserved inside (`onProgress`: 2 occurrences in both trees).

Patches applied to `emulator.min.js` are hand-spliced minified edits. When re-applying
after an upstream update, **diff against `src.diff` first** — it is authoritative and
readable; the minified splices follow from it.
