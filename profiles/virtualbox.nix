{
  virtualisation.virtualbox.host = {
    enable = true;
    #  enableWebService = true;
    enableExtensionPack = true;
  };
  #networking.firewall.allowedTCPPorts = [ 18083 ];
  users.extraGroups.vboxusers.members = ["matt"];
}
