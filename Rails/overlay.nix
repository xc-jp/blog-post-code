self: super:

let

  buildTar = name: path:
    super.runCommand (name + ".tar.gz") {} ''
      cd ${path}
      tar -czf $out .
    '';

  rubySource = ./example;

  defaultBuildInputs = with self; [
    bundix
    bundler
    nixops
    nodejs
    ruby
    sqlite
    yarn
  ];

  mkShell = args:
    let
      newArgs = args // {
        buildInputs = args.buildInputs ++ defaultBuildInputs;
        NIX_PATH="nixpkgs=${self.pkgs.path}";
        NIXOPS_DEPLOYMENT="example";
      };
    in
    super.mkShell newArgs;

in

{

  rubySrcTarball = buildTar "rails-blog-example" rubySource;

  rubyEnv = dir: super.bundlerEnv {
    name = "example-ruby-env";
    inherit (self) ruby;
    gemfile = dir + /Gemfile;
    lockfile = dir + /Gemfile.lock;
    gemset = dir + /gemset.nix;
  };

  railsApp = super.writeShellScriptBin "start-app" ''
    set -e -u -o pipefail
    export APP_PATH="''${APP_PATH:-$(mktemp -p /tmp -d rb.XXXXXX)}"

    cd $APP_PATH

    tar -xzf ${self.rubySrcTarball}
    chmod -R u+w $APP_PATH

    export PATH=$PATH:${self.yarn}/bin
    ${self.rubyEnv rubySource}/bin/rails server --binding 0.0.0.0 --port 3000
  '';

  initShell = mkShell { buildInputs = [
    (self.rubyEnv ./.)
  ];};

  devShell = mkShell { buildInputs = [
    (self.rubyEnv rubySource)
  ];};

}
