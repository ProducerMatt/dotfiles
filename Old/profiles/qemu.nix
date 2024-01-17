{ config, lib, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };
  environment.systemPackages = with pkgs; [
    qemu_full
  ];
  networking = {
    firewall.allowedTCPPorts = [
      5900
    ];
  };
}
