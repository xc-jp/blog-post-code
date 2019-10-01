{
  network.description = "Example";

  example =
    { pkgs, ... }:
    { environment.systemPackages = with pkgs; [ pkgs.dhall ];
    };
}
