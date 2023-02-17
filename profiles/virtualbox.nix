{ config, lib, pkgs, ... }:

{
  virtualisation.virtualbox.host = {
    enable = true;
    enableWebService = true;
    enableExtensionPack = true;
  };
}
