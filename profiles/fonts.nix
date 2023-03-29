{ pkgs, ... }:
{
  fonts = {
    enableDefaultFonts = true;
    fonts = import ./font-list.nix pkgs;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
    };
  };
}
