{ lib, profiles, ... }:

{
  deployment = {
    targetHost = "192.168.1.10";
    targetUser = "matt";
  };

  imports = with profiles; [
      core
      nixsettings
      openssh
      earlyOOM
      adminAccess
      jellyfin
      intelQSV
      mysyncthing
      myNetwork
    ];

  nix = {
    buildMachines = [
      {
        hostName = "PortableNix.local";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        sshUser = "nixremote";
        sshKey = "/home/matt/.ssh/id_nixremote_ed25519";
        maxJobs = 16;
        speedFactor = 8;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];
    distributedBuilds = true;
    #sshServe = {
    #  enable = "true";
    #  write = true;
    #  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHR4G/Vse74jiFwpKYagAEMlfqYs/HdXzSkXgd/6cIKk" ];
    #  protocol = "ssh-ng";
    #};
  };

  networking = {
    hostName = "BabyDell";
    interfaces = {
      "enp0s31f6" = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.1.10";
            prefixLength = 16;
          }
        ];
      };
    };
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

  users.mutableUsers = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d957b5e6-fbd4-42da-bf5d-b15be331ef98";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/5613-4E94";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/bf374d2e-41b7-461a-9a83-3100fd1c3774"; }];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "balanced";
  hardware.cpu.intel.updateMicrocode = false;

  system.stateVersion = "22.11"; # Did you read the comment?
}
