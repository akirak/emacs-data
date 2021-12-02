{
  description = "Generate data about Emacs releases";

  outputs =
    inputs @ { nixpkgs
    , flake-utils
    , pre-commit-hooks
    , ...
    }:
    {
      lib = import ./nix/builtinLibraries.nix
        (builtins.path {
          path = ./data/libraries;
          filter = path: _type:
            with builtins;
            match ".+\\.txt" (baseNameOf path) != null;
        });
    } //
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        apps.generate = flake-utils.lib.mkApp {
          drv = pkgs.callPackage ./nix/generateLibraryLists.nix { } {
            logFile = ./log.txt;
            sources = pkgs.lib.attrVals
              [
                "emacs-git"
                "emacs-28"
                "emacs-26.1"
                "emacs-26.2"
                "emacs-26.3"
                "emacs-27.1"
                "emacs-27.2"
              ]
              inputs;
          };
        };
        defaultApp = apps.generate;

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              nix-linter.enable = true;
            };
          };
        };
        devShell = pkgs.mkShell {
          inherit (checks.pre-commit-check) shellHook;
        };
      });

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.flake-utils.follows = "flake-utils";
  };

  # Unstable Emacs versions
  inputs.emacs-git = {
    url = "github:emacs-mirror/emacs/master";
    flake = false;
  };
  inputs.emacs-28 = {
    url = "github:emacs-mirror/emacs/emacs-28";
    flake = false;
  };

  # Stable Emacs releases
  inputs."emacs-26.1" = {
    url = "github:emacs-mirror/emacs/emacs-26.1";
    flake = false;
  };
  inputs."emacs-26.2" = {
    url = "github:emacs-mirror/emacs/emacs-26.2";
    flake = false;
  };
  inputs."emacs-26.3" = {
    url = "github:emacs-mirror/emacs/emacs-26.3";
    flake = false;
  };
  inputs."emacs-27.1" = {
    url = "github:emacs-mirror/emacs/emacs-27.1";
    flake = false;
  };
  inputs."emacs-27.2" = {
    url = "github:emacs-mirror/emacs/emacs-27.2";
    flake = false;
  };
}
