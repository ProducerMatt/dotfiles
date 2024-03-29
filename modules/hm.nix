{inputs, config, lib, ...}: {
  options = {
    imports = [
      #inputs."home-manager-${config.matt.hm.branch}".nixosModules.home-manager
    ] ++ (map (name:
        lib.recursiveUpdate
          (import ../users/default.nix).${name}.nixos
          (lib.setAttrByPath ["home-manager" "users" name "home" "stateVersion"] config.metaInfo.stateVersion))
      config.matt.hm.users);
    matt.hm = {
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
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
