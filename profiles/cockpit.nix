{ config, lib, pkgs, ... }:

{
  services.cockpit = {
    enable = true;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = "true";
      };
    };
  };
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
}
