#!/usr/bin/env bash
# Verify the EmulatorJS Corresponding Source round-trip.
#
# Proves: upstream 4.3.0-pre bytes  ->  apply src.diff  ->  byte-for-byte
# reproduces the vendored frontend files that SuperMuseum ships
# (src/emulator.js + src/gamepad.js).
#
# This is the GPL-3.0 §6 "produce an equivalent binary" check for the
# frontend. Run it after any EmulatorJS update, before re-applying patches.
#
# Usage:  ./verify.sh
#
# See BASE.md for provenance. Part of arties/GPL-Source-Preservation-Plan.md.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# .../arties/licenses/patches/emulatorjs-4.3.0-pre  ->  repo root is 4 levels up
REPO="$(cd "$HERE/../../../.." && pwd)"

UPSTREAM_EMULATOR_URL="https://cdn.emulatorjs.org/4.3.0-pre/data/src/emulator.js"
UPSTREAM_EMULATOR_SHA="182aa14dd0f874b308220fbaa8aad66eff4a83fe4dae4163543adebfa21f9ed9"
UPSTREAM_GAMEPAD_URL="https://cdn.emulatorjs.org/4.3.0-pre/data/src/gamepad.js"
UPSTREAM_GAMEPAD_SHA="85fd777a46e9aa10a09a24f8c6455dc5ca0c5e2f1b2fbf66cf87e297b101b1ae"

VENDORED_EMULATOR="$REPO/public/emulatorjs/data/src/emulator.js"
VENDORED_GAMEPAD="$REPO/public/emulatorjs/data/src/gamepad.js"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "==> 1/5  fetching upstream 4.3.0-pre baselines"
curl -fsSL "$UPSTREAM_EMULATOR_URL" -o "$WORK/upstream-emulator.js" \
  || fail "could not fetch $UPSTREAM_EMULATOR_URL (offline? CDN moved?)"
curl -fsSL "$UPSTREAM_GAMEPAD_URL" -o "$WORK/upstream-gamepad.js" \
  || fail "could not fetch $UPSTREAM_GAMEPAD_URL (offline? CDN moved?)"

got="$(sha256sum "$WORK/upstream-emulator.js" | cut -d' ' -f1)"
[ "$got" = "$UPSTREAM_EMULATOR_SHA" ] \
  || fail "upstream emulator.js hash changed!
       expected $UPSTREAM_EMULATOR_SHA
       got      $got
     The 4.3.0-pre CDN directory appears to have been re-published.
     Re-audit before trusting this patch (see BASE.md)."
got="$(sha256sum "$WORK/upstream-gamepad.js" | cut -d' ' -f1)"
[ "$got" = "$UPSTREAM_GAMEPAD_SHA" ] \
  || fail "upstream gamepad.js hash changed!
       expected $UPSTREAM_GAMEPAD_SHA
       got      $got
     The 4.3.0-pre CDN directory appears to have been re-published.
     Re-audit before trusting this patch (see BASE.md)."
echo "    baseline sha256 OK (both files)"

echo "==> 2/5  applying src.diff"
mkdir -p "$WORK/src"
cp "$WORK/upstream-emulator.js" "$WORK/src/emulator.js"
cp "$WORK/upstream-gamepad.js" "$WORK/src/gamepad.js"
patch -p1 -d "$WORK" --silent < "$HERE/src.diff" \
  || fail "patch did not apply cleanly — upstream changed under us"
echo "    applied cleanly, no rejects"

echo "==> 3/5  comparing against vendored files"
got="$(sha256sum "$WORK/src/emulator.js" | cut -d' ' -f1)"
want="$(sha256sum "$VENDORED_EMULATOR" | cut -d' ' -f1)"
[ "$got" = "$want" ] \
  || fail "patched upstream emulator.js != vendored
       patched:  $got
       vendored: $want
     The vendored tree has drifted from src.diff. Re-audit Patches A–L
     (AGENTS.md 'EmulatorJS Vendored Patches')."
got="$(sha256sum "$WORK/src/gamepad.js" | cut -d' ' -f1)"
want="$(sha256sum "$VENDORED_GAMEPAD" | cut -d' ' -f1)"
[ "$got" = "$want" ] \
  || fail "patched upstream gamepad.js != vendored
       patched:  $got
       vendored: $want
     The vendored tree has drifted from src.diff. Re-audit Patches A–L
     (AGENTS.md 'EmulatorJS Vendored Patches')."
echo "    byte-for-byte match with public/emulatorjs/data/src/{emulator,gamepad}.js"

echo "==> 4/5  confirming vendored files still parse as ES modules"
node --input-type=module --check < "$VENDORED_EMULATOR" 2>/dev/null \
  || fail "vendored emulator.js does not parse"
node --input-type=module --check < "$VENDORED_GAMEPAD" 2>/dev/null \
  || fail "vendored gamepad.js does not parse"
echo "    both parse OK"

echo "==> 5/5  confirming minified bundle still parses as an ES module"
node --input-type=module --check < "$REPO/public/emulatorjs/data/emulator.min.js" 2>/dev/null \
  || fail "vendored emulator.min.js does not parse"
echo "    parses OK"

echo
echo "PASS — EmulatorJS Corresponding Source is reproducible."
echo "      upstream 4.3.0-pre + src.diff == what SuperMuseum ships"
