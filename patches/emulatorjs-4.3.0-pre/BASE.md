# EmulatorJS — base revision and content hashes

## Provenance

| Field | Value |
|---|---|
| Project | [EmulatorJS/EmulatorJS](https://github.com/EmulatorJS/EmulatorJS) — "A web-based frontend for RetroArch" |
| License | **GPL-3.0** |
| Base version | `4.3.0-pre` |
| Upstream source | `https://cdn.emulatorjs.org/4.3.0-pre/data/src/{emulator,gamepad}.js` |
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
| `4.3.0-pre/data/src/gamepad.js` | `85fd777a46e9aa10a09a24f8c6455dc5ca0c5e2f1b2fbf66cf87e297b101b1ae` |
| `4.3.0-pre/data/emulator.min.js` | `b5f88bdfc57c11b76e20e7393c51e2257efde7637e48565be702e0d6590fb5ea` |

### SuperMuseum vendored (what ships)

| File | SHA-256 |
|---|---|
| `public/emulatorjs/data/src/emulator.js` | `cf18efeef1ed076178d39541cddf61304b68e249f7cbc86da4a0db7a364dc775` |
| `public/emulatorjs/data/src/gamepad.js` | `2a60c349f3d7f4f512b7470d3dfe1aab2dc576ebadef3bf83a1c65d4f8553336` |
| `public/emulatorjs/data/emulator.min.js` | `4a107d621fe853ba97d1ccbd5b624164d4fb4f24ee0248f88eb9962164b571f0` |

## The patch

`src.diff` — 34 hunks, +381 / −133 lines — is the complete difference between upstream
`4.3.0-pre` and the vendored `src/emulator.js` + `src/gamepad.js`. It is the
Corresponding Source delta required by GPL-3.0 §6 for the frontend as distributed.

### Provenance audit (2026-10-07)

The vendored tree was diffed against upstream to confirm it is a **clean single-era
build**, not a franken-build of `4.3.0-pre` + `latest`. Result: **all nine documented
patches present, no version interleave, no unreferenced additions.**
(Patches J–L landed after the audit; see the extended table above.)

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
| J — core lock, no visitor switching | `window.EJS_DEBUG_XX` in `getCore` + Core menu condition |
| K — arcade stick/trigger rows + backfill extension | `{id:12,label:this.localization("L2")}`, `...this.analogAxes, 12, 13` |
| L — analog trigger pressure | `analogTriggers`, gamepad `{pressed, value}` + `Math.round(32767*c)` |

### Applying

```bash
./verify.sh          # from this directory — full round-trip check
```

or manually:

```bash
curl -sL https://cdn.emulatorjs.org/4.3.0-pre/data/src/emulator.js -o upstream-emulator.js
curl -sL https://cdn.emulatorjs.org/4.3.0-pre/data/src/gamepad.js -o upstream-gamepad.js
sha256sum upstream-emulator.js upstream-gamepad.js   # must equal the baseline hashes above
mkdir -p src && cp upstream-emulator.js src/emulator.js && cp upstream-gamepad.js src/gamepad.js
patch -p1 -d . < src.diff
sha256sum src/emulator.js src/gamepad.js  # must equal the vendored hashes above
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
