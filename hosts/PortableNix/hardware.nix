{
  nix.settings.system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "uas" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4a5f9903-bca6-46e6-ae33-56494b15016c";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-c05dea80-c718-46cf-85b8-9f3c6aeca86c".device = "/dev/disk/by-uuid/c05dea80-c718-46cf-85b8-9f3c6aeca86c";

  swapDevices = [{device = "/dev/disk/by-uuid/bef52767-f7fc-405f-9423-d7b576e79c86";}];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-c05dea80-c718-46cf-85b8-9f3c6aeca86c".keyFile = "/crypto_keyfile.bin";
  # Enable swap on luks
  boot.initrd.luks.devices."luks-90dc3598-b566-4723-8c36-ba6110d2bd98".device = "/dev/disk/by-uuid/90dc3598-b566-4723-8c36-ba6110d2bd98";
  boot.initrd.luks.devices."luks-90dc3598-b566-4723-8c36-ba6110d2bd98".keyFile = "/crypto_keyfile.bin";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
