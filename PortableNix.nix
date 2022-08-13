{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./PortableNix-hw.nix
    ];

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  programs.apeloader.enable = true;
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
  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-c05dea80-c718-46cf-85b8-9f3c6aeca86c".keyFile = "/crypto_keyfile.bin";
  # Enable swap on luks
  boot.initrd.luks.devices."luks-90dc3598-b566-4723-8c36-ba6110d2bd98".device = "/dev/disk/by-uuid/90dc3598-b566-4723-8c36-ba6110d2bd98";
  boot.initrd.luks.devices."luks-90dc3598-b566-4723-8c36-ba6110d2bd98".keyFile = "/crypto_keyfile.bin";

  networking = {
    hostName = "PortableNix";
    networkmanager.enable = true;
    nameservers = [ "192.168.1.61" "192.168.1.16" ]; # TODO change depending on network
    wireguard.interfaces = import secrets/wg-PortableNix.nix;
    firewall.allowedTCPPorts = [ 8080 ]; # dev servers gotta dev
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = import ./modules/fonts.nix pkgs;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
    };
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matt = {
    isNormalUser = true;
    description = "Matt";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfK6c9SiwYYRxy10EMVh1sctDgy6JN/fMyzsO1hACnN ProducerMatt login key"
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true; # required for vendor distributions of autocomplete, etc.

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    mosh
    nano

    config.nur.repos.ProducerMatt.pledge
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "matt" ];
      substituters = [ "https://cache.nixos.org" "https://cache.nixos.org/"
                       "https://producermatt-nur.cachix.org"
                       "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                              "producermatt-nur.cachix.org-1:vwAYMzXLtFGCQZf9HpyrncxXQ/Qk5yGjt2CeM7/neIs="
                               "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
