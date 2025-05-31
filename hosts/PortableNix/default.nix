{overrides ? {}}: {
  config,
  lib,
  profiles,
  users,
  modules,
  ...
}: {
  imports = with profiles; [
    ./hardware.nix
    core
    cachix
    nixsettings
    openssh
    earlyOOM
    adminAccess
    containers
    ML_Nvidia
    backuppc
    mysyncthing
    gitRepos.nixpkgs
    adminAccess
    users.nixremote
    qemu
    myNetwork
    disable_sleep
    modules.mattsDesktop
    dualsense_fix
    zfs
  ];

  config =
    {
      users.mutableUsers = true;

      services.mattsDesktop = {
        enable = true;
        sound = true;
        printing = false;
        displayLink = false;
        autoStart = true;
        autoLogin = false;
        remote = {
          enable = true;
          type = "rustdesk";
        };
      };

      networking = {
        hostName = "PortableNix";
        useDHCP = false;
        interfaces = {
          "enp112s0" = {
            useDHCP = false;
            ipv4.addresses = [
              {
                address = "192.168.1.5";
                prefixLength = 16;
              }
            ];
          };
        };
      };

      services.xserver.videoDrivers = ["nvidia"];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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

      powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

      # services.x2goserver.enable = true;

      # programs.virt-manager.enable = true;
    }
    // overrides;
}
