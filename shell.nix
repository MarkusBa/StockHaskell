with (import <nixpkgs> {}).pkgs;
let pkg = haskellngPackages.callPackage
            ({ mkDerivation, base, monad-logger, persistent
             , persistent-postgresql, persistent-sqlite, persistent-template
             , resourcet, stdenv, text, time, transformers, yesod
             }:
             mkDerivation {
               pname = "StockGameHaskell";
               version = "0.1.0.0";
               src = /home/markus/git/haskell/StockHaskell;
               isLibrary = false;
               isExecutable = true;
               buildDepends = [
                 base monad-logger persistent persistent-postgresql
                 persistent-sqlite persistent-template resourcet text time
                 transformers yesod
               ];
               license = stdenv.lib.licenses.mit;
             }) {};
in
  pkg.env
