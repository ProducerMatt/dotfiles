with builtins;

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
  };
  machines = {
    PortableNix = {
      net = net.home;
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
      IPv4 = [
        {
          address = "192.168.1.16";
          prefixLength = 16;
          tags = [ "home" ];
        }
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQtRcU6x6Ot7IFF5N+ecpOofQnQ5GaZMCcWaECyal0w";
    };
    Pi4OpenBSD = {
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
      IPv4 = [
        {
          address = "192.168.1.9";
          prefixLength = 16;
          tags = [ "home" ];
        }
      ];
      ssh.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuvDGtyzI0wFZgIREiJsjddnrnv8dZQI0choswy4qmW";
    };

    # outside
    github = {
      DNS.public = [ "github.com" ];
      ssh.public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      tags = [ "outside" ];
    };
  };
}
