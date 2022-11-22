{ config, lib, pkgs, ... }:

{
  fileSystems."/mnt/PublicNAS" = {
    device = "192.168.1.3:/Public";
    fsType = "nfs";
  };
  networking.nameservers = [ "192.168.1.61" "192.168.1.16" ]; # TODO change depending on network
}
