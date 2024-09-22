{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.mattsDesktop;
in {
  options.services.mattsDesktop = with lib; {
    enable = mkEnableOption "Use Matt's Desktop settings";
    sound = mkEnableOption "Enable sound systems";
    printing = mkEnableOption "Enable printing systems";
    displayLink = mkEnableOption "Enable DisplayLink support";
    desktop = mkOption {
      description = "Which type of desktop to set up.";
      type = with types; nullOr (enum ["plasma" "sway" "gnome" "pantheon"]);
      default = "plasma";
    };
    autoStart = mkEnableOption "Start the GUI on boot";
    autoLogin = mkEnableOption "Autologin to the Desktop";
    remote = {
      enable = mkEnableOption "Enable remote desktop server";
      type = mkOption {
        description = "Which type of remote desktop service to use.";
        type = with types; uniq (enum ["RDP" "rustdesk"]);
        default = "RDP";
      };
      port = mkOption {
        description = "RDP port to listen on.";
        type = with types; uniq port;
        default = 3389;
      };
    };
  };
  config = with lib;
    mkIf cfg.enable (mkMerge [
      {
        environment.systemPackages = with pkgs; [
          kitty
        ];
      }
      (mkIf (cfg.desktop == "plasma") {
        # Enable the X11 windowing system.
        services.xserver = {
          enable = true;
          autorun = mkForce cfg.autoStart;
        };

        services.displayManager.autoLogin =
          if cfg.autoLogin
          then {
            enable = true;
            user = "matt";
          }
          else {enable = false;};

        # Enable the KDE Plasma Desktop Environment.
        services.displayManager.sddm.enable = true;
        services.displayManager.defaultSession = "plasmax11";
        services.desktopManager.plasma6.enable = true;

        # Configure keymap in X11
        services.xserver = {
          xkb.layout = "us";
          xkb.variant = "";
        };

        environment.systemPackages = with pkgs; [
          kdeplasma-addons

          # graphics debug tools
          xorg.xdpyinfo
          glxinfo
          vulkan-tools
          libsForQt5.qt5.qttools.bin # qdbus
        ];
        # Enable touchpad support (enabled default in most desktopManager).
        services.libinput.enable = true;
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
        services.xserver.displayManager.setupCommands = "${pkgs.displaylink}/bin/DisplayLinkManager &";
        environment.systemPackages = with pkgs; [
          displaylink
        ];
      })
      (
        mkIf
        ((cfg.desktop == "plasma") && cfg.remote.enable)
        (mkMerge [
          (mkIf (cfg.remote.type == "RDP")
            {
              services.xrdp = {
                enable = true;
                audio.enable = true;
                openFirewall = true;
                inherit (cfg.remote) port;
                defaultWindowManager = "startplasma-x11";
              };
            })
          (mkIf (cfg.remote.type == "rustdesk")
            {
              environment.systemPackages = [pkgs.rustdesk];
              #services.rustdesk-server.enable = true;
            })
        ])
      )
      (mkIf (cfg.desktop == "gnome") {
        # Enable the X11 windowing system.
        services.xserver = {
          enable = true;
          displayManager.gdm.enable = true;
          displayManager.defaultSession = "";
          desktopManager.gnome.enable = true;
          autorun = mkForce cfg.autoStart;
          displayManager.autoLogin =
            if cfg.autoLogin
            then {
              enable = true;
              user = "matt";
            }
            else {enable = false;};
        };
        environment.gnome.excludePackages = with pkgs; [
          firefox
        ];
        # Configure keymap in X11
        services.xserver = {
          xkb.layout = "us";
          xkb.variant = "";
        };

        environment.systemPackages = with pkgs; [
          # graphics debug tools
          xorg.xdpyinfo
          glxinfo
          vulkan-tools
          libsForQt5.qt5.qttools.bin # qdbus
        ];
        # Enable touchpad support (enabled default in most desktopManager).
        services.libinput.enable = true;
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
        services.xserver.displayManager.setupCommands = "${pkgs.displaylink}/bin/DisplayLinkManager &";
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
      (mkIf (cfg.desktop == "pantheon") {
        # Enable the X11 windowing system.
        services.xserver = {
          enable = true;
          displayManager.lightdm.enable = true;
          displayManager.defaultSession = "";
          desktopManager.pantheon.enable = true;
          autorun = mkForce cfg.autoStart;
          displayManager.autoLogin =
            if cfg.autoLogin
            then {
              enable = true;
              user = "matt";
            }
            else {enable = false;};
        };
        # Configure keymap in X11
        services.xserver = {
          xkb.layout = "us";
          xkb.variant = "";
        };

        environment.systemPackages = with pkgs; [
          # graphics debug tools
          xorg.xdpyinfo
          glxinfo
          vulkan-tools
          libsForQt5.qt5.qttools.bin # qdbus
        ];
        # Enable touchpad support (enabled default in most desktopManager).
        services.libinput.enable = true;
      })
      (mkIf ((cfg.desktop == "pantheon") && cfg.displayLink) {
        boot.extraModulePackages = with config.boot.kernelPackages; [
          evdi
        ];
        services.xserver.videoDrivers = [
          "modesetting"
          "displaylink"
          "evdi"
        ];
        services.xserver.displayManager.setupCommands = "${pkgs.displaylink}/bin/DisplayLinkManager &";
        environment.systemPackages = with pkgs; [
          displaylink
        ];
      })
      (mkIf cfg.sound {
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
