{inputs, config, lib, ...}:
let
  cfg = config.matt.hm;
in
{
    imports = lib.optionals cfg.enable (lib.singleton
      (builtins.foldl'
        (name: acc:
          lib.recursiveUpdate acc (import ../users/default.nix).${name}.nixos)
        {} cfg.users));
  options = {
    matt.hm = {
      enable = lib.mkEnableOption "this module";
      users = lib.mkOption {
        default = [
          "matt"
        ];
        type = with lib.types; listOf str;
      };
      #branch = lib.mkOption {
      #  type = with lib.types; uniq (enum ["stable" "latest"]);
      #};
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
