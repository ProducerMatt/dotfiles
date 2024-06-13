{
  networking = {
    defaultGateway = "192.168.1.1";
    nameservers = [
      "192.168.1.16"
      "192.168.1.61"
    ];
    hosts = {
      "192.168.1.3" = ["PherigoNAS.local"];
      "192.168.1.5" = ["PortableNix.local"];
    };
  };
  fileSystems = {
    "/mnt/PublicNAS" = {
      device = "PherigoNAS.local:/mnt/PherigoRAID/Public";
      fsType = "nfs";
      options = [
        "nfsvers=4"
        "noatime"
        "noexec"
      ];
    };
    "/mnt/MattNAS" = {
      device = "PherigoNAS.local:/mnt/PherigoRAID/Matt";
      fsType = "nfs";
      options = [
        "nfsvers=4"
        "noatime"
        "noexec"
      ];
    };
  };
}
