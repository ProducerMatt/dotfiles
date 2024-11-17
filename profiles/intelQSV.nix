{pkgs, ...}: {
  nixpkgs.config.packageOverrides = pkgs: let
    ffmpeg_7-full = pkgs.ffmpeg_7-full.override {withMfx = true;};
    jellyfin-ffmpeg = pkgs.jellyfin-ffmpeg.override {inherit ffmpeg_7-full;};
  in {
    inherit ffmpeg_7-full jellyfin-ffmpeg;
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    jellyfin = pkgs.jellyfin.override {inherit jellyfin-ffmpeg;};
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
