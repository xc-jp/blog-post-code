#!/usr/bin/env bash

set -e -u -o pipefail

cd "$(dirname $0)"

./update_gemset_nix.sh ./Gemfile

nix-shell package-set.nix -A initShell --run "rails new example --skip-bundle --skip-bootsnap --skip-webpack-install"

./update_gemset_nix.sh ./example/Gemfile

cd example

nix-shell ../package-set.nix -A devShell --run "rails webpacker:install"
