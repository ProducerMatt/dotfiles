{...}: {
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
  services = {
    syncthing = {
      enable = true;
      user = "matt";
      group = "users";
      dataDir = "/home/matt";
      configDir = "/home/matt/.config/syncthing";
      overrideDevices = false; # overrides any devices added or deleted through the WebUI
      overrideFolders = false; # overrides any folders added or deleted through the WebUI
      guiAddress = "0.0.0.0:8384";
    };
  };
}
