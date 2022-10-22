{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  services = {
    syncthing = {
      enable = true;
      user = "matt";
      group = "users";
      dataDir = "/home/matt";
      configDir = "/home/matt/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      devices = {
        # Is this considered a secret?
        "Matt-Win10" = {
          id = "IK73VQ4-G4R4JUP-UGHWAVA-L2FEBIZ-LISJOFH-QECOXUI-TZYQ5GB-GXK67AD";
          addresses = [ "192.168.1.2:51820" ];
        };
      };
      folders = {
        "iak23-enrgo" = {
          # Name of folder in Syncthing, also the folder ID
          path = "/home/matt/AIModels"; # Which folder to add to Syncthing
          devices = [ "Matt-Win10" ]; # Which devices to share the folder with
        };
      };
      guiAddress = "0.0.0.0:8384";
    };
  };
}
