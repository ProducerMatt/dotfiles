{pkgs, ...}: {
  nixpkgs.overlays = [
    (_final: prev: {
      vaapiIntel = prev.vaapiIntel.override {enableHybridCodec = true;};
    })
  ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime-legacy1 # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      # NOTE: uses legacy package for intel CPUs prior to gen12
      # for gen12 and up, use intel-compute-runtime
      # https://discourse.nixos.org/t/trouble-getting-quicksync-to-work-with-jellyfin/42275
      # https://github.com/NixOS/nixpkgs/issues/356535
      vpl-gpu-rt
    ];
  };

  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
