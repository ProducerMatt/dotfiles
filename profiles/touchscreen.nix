{ config, lib, pkgs, overlays, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    evdi
  ];
  services.xserver.videoDrivers = [
    "modesetting"
    "displaylink"
    "evdi"
  ];
  services.xserver.displayManager.setupCommands =
    "${pkgs.displaylink}/bin/DisplayLinkManager &";
  environment.systemPackages = with pkgs; [
    displaylink
  ];
}
