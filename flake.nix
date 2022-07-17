{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        NixVbox = lib.nixosSystem {
          inherit system;
          modules = [
            ./NixVbox.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.matt = {
                imports = [ ./Matt.nix ];
              };
            }
          ];
        };
        PortableNix = lib.nixosSystem {
          inherit system;
          modules = [
            ./PortableNix.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.matt = {
                imports = [ ./Matt.nix ];
              };
            }
          ];
        };
      };
    };
}
