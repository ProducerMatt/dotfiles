{ config, lib, pkgs, ... }:

let
  getSnippet = s: import (builtins.toPath "../../snippets/${s}.nix") pkgs;
in
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      init = { defaultBranch = "main"; };
      pull = { rebase = false; }; # setting to true was a mistake
    };
  };
  home.packages = getSnippet "dev";
}
