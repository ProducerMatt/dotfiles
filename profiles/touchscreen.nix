{ config, lib, pkgs, overlays, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    evdi
  ];
  services.xserver.videoDrivers = [ "modesetting" "displaylink" ];
  environment.systemPackages = with pkgs; [
    displaylink
  ];
}
