{ config, lib, pkgs, ... }:

{
  virtualisation.virtualbox.host = {
    enable = true;
    enableWebService = false;
    enableExtensionPack = true;
  };
  #networking.firewall.allowedTCPPorts = [ 18083 ];
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
}
