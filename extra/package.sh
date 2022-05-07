#!/bin/bash

set -xeu -o pipefail

export WINEARCH="win32"
export WINEDEBUG="-all"
extra_dir="$(realpath extra)"
bin_dir="$extra_dir/bin"
dat2a="wine $bin_dir/dat2.exe a -1"
file_list="$(realpath file.list)"
release_dir="$(realpath release)"
appearance_dir=$(realpath appearance)
trans_dir=$(realpath data/text)
mod_name="hero_appearance"

# package filename
short_sha="$(git rev-parse --short HEAD)"
version="git$short_sha"
if [[ ! -z "${GITHUB_REF-}" ]]; then
  if echo "$GITHUB_REF" | grep "refs/tags"; then # tagged
    version="$(echo $GITHUB_REF | sed 's|refs\/tags\/||')"
  fi
fi
zip="${mod_name}_${version}.zip"

zip="${mod_name}_${version}.zip"
zip_non_canon="${mod_name}_non_canon_${version}.zip"
non_canon="hfr01s00 hmr03s00"

mkdir -p "$release_dir/appearance"
cd "$appearance_dir"
languages=$(ls $trans_dir | grep -v "^po$")
for a in $(ls); do
  for lang in $languages; do
    mkdir -p text/$lang/game
    cp $trans_dir/$lang/$a/* text/$lang/game/
  done
  dat="$a.dat"
  cd "$a"
  find . -type f | sed -e 's|^\.\/||' -e 's|\/|\\|g' | sort >"$file_list"
  $dat2a "$release_dir/appearance/$dat" @"$file_list"
  cd ..
done

cd "$release_dir"
for a in $non_canon; do
  zip -r "$zip_non_canon" "appearance/$a.dat"
  rm -f "appearance/$a.dat"
done
mv "$zip_non_canon" ..

zip -r "$zip" appearance
mv "$zip" ..
