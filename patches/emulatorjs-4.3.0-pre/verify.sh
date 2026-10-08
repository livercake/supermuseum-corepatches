#!/usr/bin/env bash
# Verify the EmulatorJS Corresponding Source round-trip.
#
# Proves: upstream 4.3.0-pre bytes  ->  apply src.diff  ->  byte-for-byte
# reproduces the vendored emulator.js that SuperMuseum ships.
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

UPSTREAM_URL="https://cdn.emulatorjs.org/4.3.0-pre/data/src/emulator.js"
UPSTREAM_SHA="182aa14dd0f874b308220fbaa8aad66eff4a83fe4dae4163543adebfa21f9ed9"
VENDORED_SHA="afa64e8ffb6f88d29a49fb4ef16bdf3380f45f3761613aabc2adac67d876af0d"

VENDORED="$REPO/public/emulatorjs/data/src/emulator.js"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "==> 1/4  fetching upstream 4.3.0-pre baseline"
curl -fsSL "$UPSTREAM_URL" -o "$WORK/upstream.js" \
  || fail "could not fetch $UPSTREAM_URL (offline? CDN moved?)"

got="$(sha256sum "$WORK/upstream.js" | cut -d' ' -f1)"
[ "$got" = "$UPSTREAM_SHA" ] \
  || fail "upstream hash changed!
       expected $UPSTREAM_SHA
       got      $got
     The 4.3.0-pre CDN directory appears to have been re-published.
     Re-audit before trusting this patch (see BASE.md)."
echo "    baseline sha256 OK"

echo "==> 2/4  applying src.diff"
mkdir -p "$WORK/src"
cp "$WORK/upstream.js" "$WORK/src/emulator.js"
patch -p1 -d "$WORK" --silent < "$HERE/src.diff" \
  || fail "patch did not apply cleanly — upstream changed under us"
echo "    applied cleanly, no rejects"

echo "==> 3/4  comparing against vendored file"
got="$(sha256sum "$WORK/src/emulator.js" | cut -d' ' -f1)"
want="$(sha256sum "$VENDORED" | cut -d' ' -f1)"
[ "$got" = "$want" ] \
  || fail "patched upstream != vendored
       patched:  $got
       vendored: $want
     The vendored tree has drifted from src.diff. Re-audit Patches A-I
     (AGENTS.md 'EmulatorJS Vendored Patches')."
echo "    byte-for-byte match with public/emulatorjs/data/src/emulator.js"

echo "==> 4/4  confirming vendored file still parses as an ES module"
node --input-type=module --check < "$VENDORED" 2>/dev/null \
  || fail "vendored emulator.js does not parse"
echo "    parses OK"

echo
echo "PASS — EmulatorJS Corresponding Source is reproducible."
echo "      upstream 4.3.0-pre + src.diff == what SuperMuseum ships"
