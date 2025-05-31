{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d957b5e6-fbd4-42da-bf5d-b15be331ef98";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/5613-4E94";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/bf374d2e-41b7-461a-9a83-3100fd1c3774";}];

  system.stateVersion = "22.11"; # Did you read the comment?
}
