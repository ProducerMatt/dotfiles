{ config, lib, pkgs, ... }:

let
  cfg = config.services.mattsDesktop;
in
{
  options.services.mattsDesktop = with lib; {
    enable = mkEnableOption "Use Matt's Desktop settings";
    sound = mkEnableOption "Enable sound systems";
    printing = mkEnableOption "Enable printing systems";
    displayLink = mkEnableOption "Enable DisplayLink support";
    desktop = mkOption {
      description = "Which type of desktop to set up.";
      type = with types; nullOr (enum [ "plasma" "sway" "gnome" ]);
      default = "plasma";
    };
    autoLogin = mkEnableOption "Autologin to the Desktop";
  };
  config = with lib; mkIf cfg.enable (mkMerge [
    (mkIf (cfg.desktop == "plasma") {
      # Enable the X11 windowing system.
      services.xserver = {
        enable = true;
        autorun = cfg.autoLogin;
      };

      # Enable the KDE Plasma Desktop Environment.
      services.xserver.displayManager.sddm.enable = true;
      services.xserver.desktopManager.plasma5.enable = true;

      # Configure keymap in X11
      services.xserver = {
        layout = "us";
        xkbVariant = "";
      };

      environment.systemPackages = with pkgs; [
        kdeplasma-addons

        # graphics debug tools
        xorg.xdpyinfo
        glxinfo
        vulkan-tools
        libsForQt512.qt5.qttools.bin # qdbus
      ];
      # Enable touchpad support (enabled default in most desktopManager).
      services.xserver.libinput.enable = true;
    })
    (mkIf ((cfg.desktop == "plasma") && cfg.displayLink) {
      boot.extraModulePackages = with config.boot.kernelPackages; [
        evdi
      ];
      services.xserver.videoDrivers = [
        "modesetting"
        "displaylink"
        "evdi"
      ];
      services.xserver.displayManager.setupCommands =
        "${pkgs.displaylink}/bin/DisplayLinkManager &";
      environment.systemPackages = with pkgs; [
        displaylink
      ];
    })
    (mkIf (cfg.desktop == "gnome") {
      # Enable the X11 windowing system.
      services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        autorun = cfg.autoLogin;
      };

      # Configure keymap in X11
      services.xserver = {
        layout = "us";
        xkbVariant = "";
      };

      environment.systemPackages = with pkgs; [
        # graphics debug tools
        xorg.xdpyinfo
        glxinfo
        vulkan-tools
        libsForQt512.qt5.qttools.bin # qdbus
      ];
      # Enable touchpad support (enabled default in most desktopManager).
      services.xserver.libinput.enable = true;
    })
    (mkIf ((cfg.desktop == "gnome") && cfg.displayLink) {
      boot.extraModulePackages = with config.boot.kernelPackages; [
        evdi
      ];
      services.xserver.videoDrivers = [
        "modesetting"
        "displaylink"
        "evdi"
      ];
      services.xserver.displayManager.setupCommands =
        "${pkgs.displaylink}/bin/DisplayLinkManager &";
      environment.systemPackages = with pkgs; [
        displaylink
      ];
    })
    (mkIf (cfg.desktop == "sway") {
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
      };
    })
    (mkIf ((cfg.desktop == "sway") && cfg.displayLink) {
      boot.extraModulePackages = with config.boot.kernelPackages; [
        evdi
      ];
      #services.xserver.videoDrivers = [
      #  "modesetting"
      #  "displaylink"
      #  "evdi"
      #];
      programs.sway.extraSessionCommands = ''
        ${pkgs.displaylink}/bin/DisplayLinkManager &
      '';
      environment.systemPackages = with pkgs; [
        displaylink
      ];
    })
    (mkIf cfg.sound {
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
    })
    (mkIf cfg.printing {
      # Enable CUPS to print documents.
      services.printing.enable = true;
    })
  ]);
}
