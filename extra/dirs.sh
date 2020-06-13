#!/bin/bash

set -xeu -o pipefail

lang_dir=language
po_dir="$lang_dir/po"
ap_dir=appearance

for lang in $(ls $po_dir | grep "\.po$" | sed 's|\.po$||'); do
  mkdir -p "$lang_dir/$lang"
  for a in $(ls $ap_dir); do
    mkdir -p "$ap_dir/$a/text/$lang/game"
    ln -s ../../"$ap_dir/$a/text/$lang/game" "$lang_dir/$lang/${a}_game"
  done
done
