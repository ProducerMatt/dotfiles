{ config, lib, pkgs, ... }:

let
  getSnippet = lib.our.getPkgSnippet pkgs;
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
  home.packages = getSnippet "git";
}
