#!/bin/bash
# Reproduce: tlapm proves three false theorems through shared names and rejects three controls; TLC refutes each.
# TLAPS_HOME: a tlapm install root (bin/tlapm, lib/tlapm/stdlib/TLAPS.tla). TLA2TOOLS: tla2tools.jar for TLC.
# Defaults: ../tlaps and ../tla2tools.jar beside this directory; see the top-level README for fetching both.
set -u
here="$(cd "$(dirname "$0")" && pwd)"
TLAPS_HOME="${TLAPS_HOME:-$here/../tlaps}"
TLA2TOOLS="${TLA2TOOLS:-$here/../tla2tools.jar}"
TLAPM="$TLAPS_HOME/bin/tlapm"
[ -x "$TLAPM" ] || { echo "no tlapm at $TLAPM; set TLAPS_HOME" >&2; exit 1; }
[ -f "$TLA2TOOLS" ] || { echo "no tla2tools.jar at $TLA2TOOLS; set TLA2TOOLS" >&2; exit 1; }
STDLIB="$(dirname "$(find "$TLAPS_HOME" -name TLAPS.tla | head -1)")"
cd "$here"; rm -rf .tlacache

echo "== tlapm $("$TLAPM" --version 2>&1), sha256 $(shasum -a 256 "$TLAPM" | cut -c1-16), $(uname -sm)"
echo "== THEOREMs by line:"; grep -n '^THEOREM' NameUnsound.tla | sed 's/==.*//'
echo "== verdict per obligation (line, status, backend):"
"$TLAPM" --toolbox 0 0 --nofp --debug tempfiles NameUnsound.tla 2>&1 | awk '
  /^@!!BEGIN/{blk=""} {blk=blk"\n"$0}
  /^@!!END/{ if (blk ~ /status:(proved|failed)/) {
    match(blk,/loc:[0-9]+/); l=substr(blk,RSTART+4,RLENGTH-4)
    match(blk,/status:[a-z ]+/); s=substr(blk,RSTART+7,RLENGTH-7)
    match(blk,/prover:[a-z0-9]+/); p=substr(blk,RSTART+7,RLENGTH-7)
    printf "  line %-3s %-8s %s\n", l, s, p } }' | sort -u
echo
echo "== names in the backend inputs tlapm wrote (.tlacache):"
for f in .tlacache/NameUnsound.tlaps/tlapm_*.smt; do
  [ -f "$f" ] || continue
  names=$(grep -o 'OPAQUE__h[0-9a-f]*' "$f" | sort | uniq -c | awk '{printf "%s x%s ", $2, $1}')
  echo "  $(basename "$f"): $names"
done
for f in $(ls .tlacache/NameUnsound.tlaps/ | grep -v -E '\.smt|\.thy|fingerprints'); do
  echo "  $f: $(head -c 300 ".tlacache/NameUnsound.tlaps/$f" | tr '\n' ' ')"
done
echo
for part in A B C; do
  echo "== TLC: NameUnsound_$part.cfg, D = {1, 2}"
  java -DTLA-Library="$STDLIB" -cp "$TLA2TOOLS" tlc2.TLC -nowarning -workers 1 -config NameUnsound_$part.cfg NameUnsound.tla 2>&1 \
    | grep -E 'Error|^State|^/\\|^x = |^y = |^w = |Stuttering|Finished in'
done
rm -rf states
