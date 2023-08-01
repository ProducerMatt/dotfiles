{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = import ./font-list.nix pkgs;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
    };
  };
}
