{ lib }:
with builtins; with lib;

let
  getTaggedIPs = wantedTag: list: filter (x: any (t: t == wantedTag) x.tags) list;
  netIPv4addrs = machineset: tag: wantedMachines: catAttrs "address" (concatMap
    (machine:
      (getTaggedIPs tag machineset.${machine}.IPv4))
    wantedMachines);
in
rec {
  net.home = {
    DNS = netIPv4addrs machines "home" [ "apu4vpn" "Pi4OpenBSD" ];
    gateway = "192.168.1.1";
    postfix = ".local";
  };
  machines = {
    PortableNix = {
      net = "home";
      IPv4 = [
        {
          address = "192.168.1.5";
          prefixLength = 16;
          tags = [ "home" ];
          interface = "enp112s0";
        }
      ];
      ssh.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzedljAnnwHwDno7cVfShZN2D3Dt5SwAWYUlLex/2Yg";
    };
    apu4vpn = {
      net = "home";
      IPv4 = [
        {
          address = "192.168.1.16";
          prefixLength = 16;
          tags = [ "home" ];
        }
      ];
      ssh.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQtRcU6x6Ot7IFF5N+ecpOofQnQ5GaZMCcWaECyal0w";
    };
    Pi4OpenBSD = {
      net = "home";
      IPv4 = [
        {
          address = "192.168.1.61";
          prefixLength = 16;
          tags = [ "home" ];
        }
      ];
      ssh.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPaVb1exjSJZbRyyC7l0bHCKp8VXJIhcafG4x3SdQlEM";
    };
    BabyDell = {
      net = "home";
      IPv4 = [
        {
          address = "192.168.1.10";
          prefixLength = 16;
          tags = [ "home" ];
          interface = "enp0s31f6";
        }
      ];
      ssh.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4jG9M12tFG9aJtvoU8vUB0cfDVVieVk/PyrHQbqDy+";
    };
    PherigoNAS = {
      net = "home";
      IPv4 = [
        {
          address = "192.168.1.3";
          prefixLength = 16;
          tags = [ "home" ];
        }
      ];
      ssh.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKaCWm/sUg2VHB6MX47Gn4/rdQD9A60F+UCJowm9jFj";
      services = {
        remoteFS = {
          "/mnt/PublicNAS" = {
            device = "PherigoNAS.local:/mnt/PherigoRAID/Public";
            fsType = "nfs";
            options = [
              "nfsvers=4"
              "noatime"
            ];
          };
          "/mnt/MattNAS" = {
            device = "PherigoNAS.local:/mnt/PherigoRAID/Matt";
            fsType = "nfs";
            options = [
              "nfsvers=4"
              "noatime"
            ];
          };
        };
      };
    };

    # outside
    github = {
      DNS = [ "github.com" ];
      ssh.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      tags = [ "outside" ];
    };
  };
}
