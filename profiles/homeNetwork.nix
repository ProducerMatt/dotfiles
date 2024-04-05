{...}: {
  fileSystems."/mnt/PublicNAS" = {
    device = "192.168.1.3:/mnt/PherigoRAID/Public";
    fsType = "nfs";
    options = [
      #      "nfsvers=3"
      "noatime"
    ];
  };
  fileSystems."/mnt/MattNAS" = {
    device = "192.168.1.3:/mnt/PherigoRAID/Matt";
    fsType = "nfs";
    options = [
      #      "nfsvers=3"
      "noatime"
    ];
  };
  networking.nameservers = ["192.168.1.61" "192.168.1.16"]; # TODO change depending on network
}
