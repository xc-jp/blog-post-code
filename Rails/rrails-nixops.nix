{
  network.description = "Example";

  example =
    { pkgs, ... }:

    {

      nixpkgs.overlays = [
        (import ./overlay.nix)
      ];

      environment.systemPackages = [
        pkgs.railsApp
      ];

      networking.firewall.allowedTCPPorts = [ 3000 ];

    };
}
