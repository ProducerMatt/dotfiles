{
  config,
  lib,
  ...
}: {
  nixpkgs.config = {
    # TODO: whitelist unfree pkgs
    allowUnfree = true;
    cudaSupport = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia-container-toolkit.enable = true;

  # ensure text mode works
  boot = {
    initrd.kernelModules = ["nvidia"];
    kernelParams = [
      # intel
      "module_blacklist=i915"
      # AMD
      "module_blacklist=amdgpu"
    ];
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
  };
}
