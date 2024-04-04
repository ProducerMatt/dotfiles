{ myLib, lib, ... }:
let
  imports = lib.attrValues (myLib.rakeLeaves ./.);
in
{
  inherit imports;
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
}
