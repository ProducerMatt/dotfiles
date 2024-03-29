{self, lib, config, ...}:
let
flakeInfo = {
      inherit (self) lastModified lastModifiedDate narHash;
      # TODO: could clearly be a function mapping
      rev = self.rev or "dirty";
      shortRev = self.shortRev or "dirty";
      revCount = self.revCount or "dirty";
      rootDir = ../.;
    };
  metaInfo = config.metaInfo // {flake = flakeInfo;};
in
{
  options = {
      metaInfo = {
        stateVersion = lib.mkOption {
          type = with lib.types; uniq str;
          example = "23.11";
        };
        flake = lib.mkOption {
            type = with lib.types; uniq raw;
            default = flakeInfo;
            readOnly = true;
          };
      };
    };
  config = {
    inherit (config) metaInfo;
    users.motd = ''
      ${config.networking.hostName}
      Flake revision #${builtins.toString flakeInfo.revCount} from ${flakeInfo.lastModifiedDate}
      Flake commit ${flakeInfo.shortRev}
    '';
    system.configurationRevision = flakeInfo.rev;
    system.stateVersion = config.metaInfo.stateVersion;
  };
}
