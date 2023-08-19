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
    bridges = {
      br0 = {
        interfaces = [
          "br0"
        ];
      };
    };
  };
}
