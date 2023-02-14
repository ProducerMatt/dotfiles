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
      type = with types; nullOr strMatching [ "plasma" ];
      default = "plasma";
    };
    autoLogin = mkEnableOption "Autologin to the Desktop";
  };
  config = (lib.mkIf cfg.enable
    (lib.mkIf (cfg.desktop == "plasma")
      ({
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
          # graphics debug tools
          xorg.xdpyinfo
          glxinfo
          vulkan-tools
          libsForQt512.qt5.qttools.bin # qdbus
        ];
        # Enable touchpad support (enabled default in most desktopManager).
        services.xserver.libinput.enable = true;
      } // (lib.mkIf cfg.displayLink
        {
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
        })))
  //
  (lib.mkIf cfg.sound
    {
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
  //
  (lib.mkIf cfg.printing
    {
      # Enable CUPS to print documents.
      services.printing.enable = true;
    }));
}
