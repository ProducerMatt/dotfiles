{inputs, config, lib, ...}:
let
  cfg = config.matt.hm;
in
{
  imports = [
    (import ../users/default.nix {inherit lib; env = "nixos";})
  ];
  options = {
    matt.hm = {
      enable = lib.mkEnableOption "this module";
      users = lib.mkOption {
# NOTE: this will be resolved in user loading
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
  config = lib.mkIf cfg.matt.hm.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
