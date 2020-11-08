#!/bin/bash

set -xeu -o pipefail

bin_dir="$(realpath $bin_dir)"
dat2a="wine $bin_dir/dat2.exe a -1"
file_list="$(realpath file.list)"
release_dir="$(realpath $release_dir)"
# release?
if [ -n "$TRAVIS_TAG" ]; then # tag found: releasing
  export version="$TRAVIS_TAG"
else
  export version="git$TRAVIS_COMMIT"
fi
zip="hero_appearance_${version}.zip"
zip_non_canon="hero_appearance_non_canon_${version}.zip"
non_canon="hfr01s00 hmr03s00"

mkdir -p "$release_dir/appearance"
cd "$appearance_dir"
for a in $(ls); do
  dat="$a.dat"
  cd "$a"
  find . -type f | sed -e 's|^\.\/||' -e 's|\/|\\|g' | sort > "$file_list"
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
