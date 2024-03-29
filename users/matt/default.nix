let
  hm = import ./hm.nix;
  nixos = import ./nixos.nix hm;
in
{
  inherit nixos;
  hmOnly = hm;
}
