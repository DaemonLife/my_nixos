# just run nix-shell in this directory
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
  ];
  shellHook = ''
    if [ ! -d .venv ]; then
        python -m venv .venv
        source .venv/bin/activate
        pip install -r requirements.txt
    else
        source .venv/bin/activate
    fi
    cli-chess
    exit
  '';
}
