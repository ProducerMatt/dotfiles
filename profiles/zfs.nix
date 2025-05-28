{
  boot.zfs.enabled = true;
  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
  };
}
