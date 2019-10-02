{ pkgs ? import <nixpkgs> {}}:

pkgs.writeScriptBin "my-app" ''
  #!${pkgs.runtimeShell}
  set -euo pipefail
  SECRET=''${1:-}

  [[ -n $SECRET ]] || (echo "Usage: $0 SECRET_FILE" && exit 1)

  echo "Running with secret: $(cat $SECRET)"
''
