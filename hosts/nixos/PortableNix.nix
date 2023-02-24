{ config, pkgs, lib, modulesPath, profiles, suites, age, modules, ... }:

{
  age.secrets."wg-PortableNix.key".file =
    ../../secrets/wg-PortableNix.key.age;
  age.secrets."wg-apu4VPN-preshared.key".file =
    ../../secrets/wg-apu4VPN-preshared.key.age;

  users.mutableUsers = true;

  imports =
    suites.base ++
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      profiles.fonts
      profiles.containers
      profiles.ML_Nvidia
      profiles.backuppc
      profiles.mysyncthing
      profiles.guix
      profiles.sicp
      profiles.homeNetwork
      profiles.earlyOOM
      profiles.crosscompile
      profiles.virtualbox
    ];

  services.mattsDesktop = {
    enable = true;
    sound = true;
    printing = true;
    displayLink = true;
    desktop = "gnome";
    autoStart = true;
    autoLogin = true;
  };

  services.hardenedUnbound.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  services.xserver.videoDrivers = [ "nvidia" ];

  services.mattsRemoteAccess = {
    enable = true;
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/4a5f9903-bca6-46e6-ae33-56494b15016c";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-c05dea80-c718-46cf-85b8-9f3c6aeca86c".device = "/dev/disk/by-uuid/c05dea80-c718-46cf-85b8-9f3c6aeca86c";

  swapDevices =
    [{ device = "/dev/disk/by-uuid/bef52767-f7fc-405f-9423-d7b576e79c86"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  #programs.apeloader.enable = true;
  ## APE helper (not ape loader)
  #boot.binfmt.registrations = {
  #  "APE" = {
  #    recognitionType = "magic";
  #    magicOrExtension = "MZqFpD";
  #    interpreter = "${pkgs.bash}/bin/sh";
  #  };
  #};

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

  networking = {
    hostName = "PortableNix";
    networkmanager.enable = true;
    wireguard.interfaces =
      import ../../secrets/wg-PortableNix.nix {
        privateKeyPath =
          config.age.secrets."wg-PortableNix.key".path;
        apuKeyPath =
          config.age.secrets."wg-apu4VPN-preshared.key".path;
      };
    firewall.allowedTCPPorts = [
      8080
      7860
      7861 # dev servers gotta dev
      3389
    ];
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
