{pkgs, ...}: {
  nixpkgs.overlays = [
    (_final: prev: let
      ffmpeg_7-full = prev.ffmpeg_7-full.override {withMfx = true;};
      jellyfin-ffmpeg = prev.jellyfin-ffmpeg.override {inherit ffmpeg_7-full;};
    in {
      inherit ffmpeg_7-full jellyfin-ffmpeg;
      vaapiIntel = prev.vaapiIntel.override {enableHybridCodec = true;};
      jellyfin = prev.jellyfin.override {inherit jellyfin-ffmpeg;};
    })
  ];
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
