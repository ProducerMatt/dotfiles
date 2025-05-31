{overrides ? {}}: {
  lib,
  profiles,
  ...
}:
{
  imports = with profiles; [
    ./hardware.nix
    core
    cachix
    nixsettings
    openssh
    earlyOOM
    adminAccess
    jellyfin
    intelQSV
    mysyncthing
    myNetwork
    portablenix_builder
    myNetwork
  ];

  #nix = {
  #  sshServe = {
  #    enable = "true";
  #    write = true;
  #    keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHR4G/Vse74jiFwpKYagAEMlfqYs/HdXzSkXgd/6cIKk" ];
  #    protocol = "ssh-ng";
  #  };
  #};

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
  };

  users.mutableUsers = true;

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
}
// overrides
