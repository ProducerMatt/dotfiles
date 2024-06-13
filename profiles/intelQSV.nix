{pkgs, ...}: {
  nixpkgs.config.packageOverrides = pkgs: let
    ffmpeg_6-full = pkgs.ffmpeg_6-full.override {withMfx = true;};
    jellyfin-ffmpeg = pkgs.jellyfin-ffmpeg.override {inherit ffmpeg_6-full;};
  in {
    inherit ffmpeg_6-full jellyfin-ffmpeg;
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    jellyfin = pkgs.jellyfin.override {inherit jellyfin-ffmpeg;};
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
