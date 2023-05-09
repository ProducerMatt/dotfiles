{ config, lib, pkgs, ... }:

let
  cfg = config.services.mattsNetwork;
  myConstants = config.myConstants;
  wantedAttrs = listOfNames: a:
    lib.filterAttrs (n: v: lib.any (name: n == name) listOfNames) a;
  recUpdateList = listOfAttrs:
    builtins.foldl' lib.recursiveUpdate { } listOfAttrs;
in
{
  options.services.mattsNetwork = with builtins; with lib; {
    hostname = mkOption {
      description = "hostname for this machine";
      type = with types; nullOr string;
      default = null;
    };
  };
  #options.myConstants = lib.mkOption
  #  { internal = true; default = myConstants; };
  config = with lib; mkIf (cfg.hostname != null) (
    let
      this = myConstants.machines.${cfg.hostname};
    in
    {
      networking = {
        defaultGateway = this.net.gateway;
        nameservers = this.net.DNS;
        hostName = cfg.hostname;
        interfaces = #recursiveUpdate
          (if ((hasAttr "IPv4" this) &&
            any (hasAttr "interface") this.IPv4)
          then
            let ifs = catAttrs "interface" this.IPv4;
            in recUpdateList (map
              (wantedIF: {
                ${wantedIF} = {
                  useDHCP = false;
                  ipv4.addresses =
                    (map (wantedAttrs [ "address" "prefixLength" ])
                      (filter
                        (i: (hasAttr "interface" i
                          && i.interface == wantedIF))
                        this.IPv4));
                };
              })
              ifs)
          else
            { });
      };
    }
  );
}
