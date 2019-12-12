{ pkgs ? (import ./pkgs.nix) }:

(import ./package-set.nix {inherit pkgs;}).devShell
