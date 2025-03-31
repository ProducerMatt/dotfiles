{
  lib,
  config,
  ...
}: {
  nixpkgs.config = {
    # TODO: whitelist unfree pkgs
    allowUnfree = lib.mkForce true;
    cudaSupport = lib.mkForce true;
  };

  services.xserver = {
    enable = lib.mkDefault false;
    videoDrivers = ["nvidia"];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia-container-toolkit.enable = lib.mkForce true;

  hardware.nvidia = {
    modesetting.enable = true;
    # NOTE: one of these three are needed for graphics on PortableNix, further testing needed
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
}
