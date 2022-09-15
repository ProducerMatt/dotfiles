{
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  virtualisation.podman.enableNvidia = true;
  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
