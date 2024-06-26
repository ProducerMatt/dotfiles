{
  nixpkgs.config = {
    # TODO: whitelist unfree pkgs
    allowUnfree = true;
    cudaSupport = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    #extraPackages = [ pkgs.nvidia_gl ];
    #extraPackages32 = [ pkgs.nvidia_gl_32 ];
  };

  hardware.nvidia-container-toolkit.enable = true;
  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
