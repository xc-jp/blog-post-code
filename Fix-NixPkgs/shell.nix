{ config ? {}
, nixpkgs ? null
} :

let

  nixpkgs_src =
    if nixpkgs == null
    then builtins.fetchTarball {
      # nixos-18.09
      url = "https://github.com/NixOS/nixpkgs/archive/a7e559a5504572008567383c3dc8e142fa7a8633.tar.gz";
      sha256 = "16j95q58kkc69lfgpjkj76gw5sx8rcxwi3civm0mlfaxxyw9gzp6";
    }
    else nixpkgs;

  pkgs = import nixpkgs_src { inherit config; };

in

pkgs.mkShell {
  buildInputs = [ pkgs.nixops pkgs.openssl ];
  NIX_PATH = "nixpkgs=" + nixpkgs_src;
  NIXOPS_DEPLOYMENT = "example";
}
