{config, ...}: {
  boot = {
    zfs = {
      forceImportAll = false;
      forceImportRoot = false;
    };
    supportedFilesystems = {
      zfs = true;
    };
  };
  networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
  };
}
