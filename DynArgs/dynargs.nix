{ myApp, secret }:

let
  myAppSrc = builtins.fetchGit {
    url = "git@github.com:xc-jp/blog-post-code.git";
    inherit (myApp) rev ref;
  };
in

{
  network.description = "Example";

  example =
    { pkgs, lib, ... }:
    let
      # This turns a string into an absolute or relative
      # nix path conditional on whether the string begins with a '/'
      toPath = s:
        if lib.hasPrefix "/" s
        then /.  + s
        else ./. + "/${s}";
    in

    {
      environment.systemPackages =
        [ (import "${myAppSrc}/DynArgs" {inherit pkgs;}) ];
      deployment.keys.my-app-secret = {
        text = builtins.readFile (toPath secret);
      };
    };
}
