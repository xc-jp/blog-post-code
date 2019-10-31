{ pkgs ? (import ./pkgs.nix) }:

import pkgs { overlays = [ (import ./overlay.nix) ]; }
