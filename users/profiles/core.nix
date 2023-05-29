{ config, lib, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  ## BUG: https://github.com/NixOS/nixpkgs/issues/196651
  #manual.manpages.enable = false;
}
