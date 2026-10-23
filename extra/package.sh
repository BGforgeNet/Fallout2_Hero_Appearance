#!/bin/bash

set -xeu -o pipefail

MOD_NAME="hero_appearance"
DAT3_VERSION="v0.11.1"
DAT3_URL="https://github.com/BGforgeNet/dat3/releases/download/${DAT3_VERSION}/dat3"
EXTRA_DIR="$(realpath extra)"
DAT3="$EXTRA_DIR/bin/dat3"
# zlib level for every .dat: 6 packs in under half the time of 9, for archives about 1% larger.
DAT3_LEVEL=6
release_dir="$(realpath release)"
appearance_dir="$(realpath appearance)"
trans_dir="$(realpath data/text)"

# Download dat3 tool if it doesn't exist
if [[ ! -f "$DAT3" ]]; then
    mkdir -p "$EXTRA_DIR/bin"
    # Through a temporary name, so an interrupted download is never taken for a complete one.
    wget -q "$DAT3_URL" -O "$DAT3.part"
    chmod +x "$DAT3.part"
    mv "$DAT3.part" "$DAT3"
fi

# package filename
short_sha="$(git rev-parse --short HEAD)"
version="git$short_sha"
if [[ -n "${GITHUB_REF-}" ]]; then
    if echo "$GITHUB_REF" | grep "refs/tags"; then # tagged
        version="$(echo "$GITHUB_REF" | sed 's|refs\/tags\/||')"
    fi
fi
zip="${MOD_NAME}_${version}.zip"
zip_non_canon="${MOD_NAME}_non_canon_${version}.zip"
non_canon="hfr01s00 hmr03s00"

mkdir -p "$release_dir/appearance"
for a_path in "$appearance_dir"/*/; do
    a="$(basename "$a_path")"
    for lang_path in "$trans_dir"/*/; do
        lang="$(basename "$lang_path")"
        [[ "$lang" == "po" ]] && continue
        mkdir -p "$a_path/text/$lang/game"
        cp "$trans_dir/$lang/$a"/* "$a_path/text/$lang/game"/
    done
    "$DAT3" a -c "$DAT3_LEVEL" -C "$a_path" "$release_dir/appearance/$a.dat" '*'
done

cd "$release_dir"
# .dat files are already compressed: storing them is far faster, deflate gains nothing.
for a in $non_canon; do
    zip -0 -r "$zip_non_canon" "appearance/$a.dat"
    rm -f "appearance/$a.dat"
done
mv "$zip_non_canon" ..

zip -0 -r "$zip" appearance
mv "$zip" ..
