let
  nixpkgs_src =
    builtins.fetchTarball {
      # nixos-18.09
      url = "https://github.com/NixOS/nixpkgs/archive/a7e559a5504572008567383c3dc8e142fa7a8633.tar.gz";
      sha256 = "16j95q58kkc69lfgpjkj76gw5sx8rcxwi3civm0mlfaxxyw9gzp6";
    };
  fixedpkgs = import nixpkgs_src {};
in

{
  network.description = "Example";

  example =
    { pkgs, ... }:
    { environment.systemPackages = with pkgs; [ fixedpkgs.dhall ];
    };
}
