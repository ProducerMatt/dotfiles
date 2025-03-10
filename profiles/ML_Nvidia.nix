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

  # BUG: Nvidia 565 broken with latest Linux kernel, force version 570
  # https://github.com/NixOS/nixpkgs/issues/375730
  # TODO: remove once fixed
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.86.16"; # use new 570 drivers
    sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
    openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
    settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
    usePersistenced = false;
  };
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
