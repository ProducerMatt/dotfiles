{ config, lib, pkgs, ... }:

{
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
