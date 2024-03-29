{inputs, config, lib, ...}:
let
  cfg = config.matt.hm;
in
{
  imports = (map
    (name: (import ../users/default.nix)."${name}".nixos)
    ["matt"]);
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
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
