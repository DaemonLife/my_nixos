{ pkgs ? import <nixpkgs> { }
,
}:
pkgs.callPackage
  (
    { mkShell
    , cargo
    , rustc
    , rustPlatform
    , pkg-config
    ,
    }:
    mkShell {
      strictDeps = true;
      nativeBuildInputs = [
        cargo
        rustc
        rustPlatform.bindgenHook
        pkg-config
      ];
      buildInputs = with pkgs; [
        rustfmt
        alsa-lib
        pkg-config
        openssl.dev
        fontconfig.dev
        libclang.dev
        clang
      ];
      shellHook = ''
        CARGO_TARGET_DIR=$PWD/target
        OPENSSL_DIR="`whereis openssl | awk '{print $2}'`"
      '';
      # ...
    }
  )
{ }
