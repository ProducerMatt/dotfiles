{ pkgs, inputs, ... }:
#flake-utils.lib.eachDefaultSystem (system:
let
  # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
  inherit (pkgs) system;
  inherit (inputs) poetry2nix;
  inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication mkPoetryEnv defaultPoetryOverrides poetry;
  appSettings = {
    projectDir = ./.;
    python = pkgs.python311;
    overrides = defaultPoetryOverrides.extend
      (self: super: {
        discord-py = super.discord-py.overridePythonAttrs
          (
            old: {
              buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools ];
            }
          );
      });
  };
  #app = mkPoetryApplication appSettings;
  shell = (mkPoetryEnv appSettings).env.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = [ pkgs.poetry ];
  })
  ;
in
shell
