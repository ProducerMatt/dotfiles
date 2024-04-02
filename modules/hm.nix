{self, inputs, config, lib, myLib, ...}:
let
  cfg = config.matt.hm;
in
{
  imports = [
    (import ../users/matt {pred = lib.any (x: x == "matt") cfg.users;})
  ];
  options = {
    matt.hm = {
      enable = lib.mkEnableOption "this module";
      users = lib.mkOption {
# NOTE: this will be resolved in user loading
        default = [
          "matt"
        ];
        type = with lib.types; listOf (enum ["matt"]);
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
      extraSpecialArgs = {
        inherit self myLib;
      };
    };
  };
}
