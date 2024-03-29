{inputs, config, lib, ...}: {
  options = {
    matt.hm = {
      enable = lib.mkEnableOption "module";
      users = lib.mkOption {
        default = [
          "matt"
        ];
        type = with lib.types; listOf str;
      };
      branch = lib.mkOption {
        type = with lib.types; uniq (enum ["stable" "latest"]);
      };
    };
  };
  config = lib.mkIf config.matt.hm.enable {
    imports = [
      inputs."home-manager-${config.matt.hm.branch}".nixosModules.home-manager
    ] ++ (map (name: (import ../users/default.nix).${name}.nixos) config.matt.hm.users);
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
