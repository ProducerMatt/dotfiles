{
  config,
  lib,
  pkgs,
  myLib,
  ...
}: let
  getSnippet = myLib.getPkgSnippet pkgs;
in {
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      init = {defaultBranch = "main";};
      pull = {rebase = false;}; # setting to true was a mistake
    };
  };
  home.packages = getSnippet "git";
}
