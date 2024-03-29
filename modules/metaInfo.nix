{self, lib, config, ...}:
let
flakeInfo = with self; {
      inherit lastModified lastModifiedDate narHash;
      # TODO: could clearly be a function mapping
      rev = self.rev or "dirty";
      shortRev = self.shortRev or "dirty";
      revCount = self.revCount or "dirty";
      rootDir = ../.;
    };
  metaInfo = flakeInfo // config.metaInfo;
in
{
  options = {
      metaInfo.stateVersion = lib.mkOption {
          type = with lib.types; str;
          example = "23.11";
      };
    };
  config = {
    inherit metaInfo;
    users.motd = ''
      ${config.networking.hostName}
      Flake revision #${builtins.toString flakeInfo.revCount} from ${flakeInfo.lastModifiedDate}
      Flake commit ${flakeInfo.shortRev}
    '';
    system.configurationRevision = flakeInfo.rev;
    system.stateVersion = metaInfo.stateVersion;
  } // (lib.mkIf config.matt.hm.enable {
      home-manager.stateVersion = metaInfo.stateVersion;
    });
}
