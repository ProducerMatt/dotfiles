{
  self,
  config,
  lib,
  myLib,
  inputs,
  ...
}: let
  cfg = config.matt.hm;
in {
  imports = [
    (import ../users/matt {enable = builtins.elem "matt" cfg.users;})
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
      primaryMachine = lib.mkEnableOption "lots of packages";
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
        inherit self inputs myLib;
      };
    };
  };
}
