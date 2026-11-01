#!/bin/sh
# Copiază jocul web (din rădăcina repo-ului) în aplicație, ca să meargă offline.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/.."
DST="$HERE/PufiStars/WebContent"
mkdir -p "$DST"
cp "$SRC/index.html" "$DST/index.html"
for d in foto imn fotbal; do
  if [ -d "$SRC/$d" ]; then rsync -a --delete "$SRC/$d/" "$DST/$d/"; fi
done
echo "Web game synced to $DST"
