{ pkgs, lib, ... }:
let
  imports = lib.our.rakeThisProfileFolder ./.;
in
{
  inherit imports;
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
}
