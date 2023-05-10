{ config, lib, pkgs, ... }:

with builtins; with lib; let
  cfg = config.services.mattsNetwork;
  myConstants = config.myConstants;
  getIPsAndAssignToIFs =
    machine: wantedIF: {
      ${wantedIF} = {
        useDHCP = false;
        ipv4.addresses =
          (map (our.wantedAttrs [ "address" "prefixLength" ])
            (filter
              (i: (hasAttr "interface" i
                && i.interface == wantedIF))
              machine.IPv4));
      };
    };
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
  config = mkIf (cfg.hostname != null) (
    let
      this = myConstants.machines.${cfg.hostname};
    in
    {
      networking = {
        defaultGateway = myConstants.net.${this.net}.gateway;
        nameservers = myConstants.net.${this.net}.DNS;
        hostName = cfg.hostname;
        interfaces = #recursiveUpdate
          (if ((hasAttr "IPv4" this) &&
            any (hasAttr "interface") this.IPv4)
          then
            let ifs = catAttrs "interface" this.IPv4;
            in our.recUpdateList (map (getIPsAndAssignToIFs this) ifs)
          else
            { });
        hosts =
          # needed: attrset of IPs and lists of hostnames
          zipAttrs
            (flatten
              (mapAttrsToList
                (name: value:
                  let
                    ips =
                      (flatten (catAttrs "address"
                        (our.getTaggedIPs this.net value.IPv4)));
                  in
                  map (ip: { ${ip} = "${name}.local"; }) ips)
                (filterAttrs (n: v: v ? IPv4) myConstants.machines)));
      };
    }
  );
}