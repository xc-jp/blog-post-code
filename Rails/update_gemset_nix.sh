#!/usr/bin/env bash

set -e -u -o pipefail

GEMFILE="${1:-}"

[[ -n $GEMFILE ]] || (echo "Usage: $0 GEMFILE"; exit 1)

[[ -e $GEMFILE ]] || (echo "Couldn't find $GEMFILE"; exit 1)

[[ $(basename $GEMFILE) == Gemfile ]] || \
  (echo "$GEMFILE doesn't look like a Gemfile"; exit 1)

NIXPKG_FILE="$(dirname $(readlink -f $0))/package-set.nix"

cd $(dirname $GEMFILE)

nix run -f "$NIXPKG_FILE" bundler -c bundler lock

rm -f gemset.nix

nix run -f "$NIXPKG_FILE" bundix -c bundix
