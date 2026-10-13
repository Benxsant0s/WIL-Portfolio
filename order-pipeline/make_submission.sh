#!/bin/sh
# Builds ../<sha256>.zip, where <sha256> is the lowercase SHA-256 of the ZIP bytes.
# Re-run this EVERY time you change any file: the hash (and so the name) changes.
# Usage (from inside the project folder):  sh make_submission.sh
set -e
proj=$(basename "$PWD")
cd ..
tmp="$(mktemp -d)/pkg.zip"
rm -rf "$proj/dist-newstyle"
find "$proj" -type f | LC_ALL=C sort | zip -X -q "$tmp" -@
hash=$(sha256sum "$tmp" | cut -d' ' -f1)
mv "$tmp" "./$hash.zip"
echo "Created ../$hash.zip"
