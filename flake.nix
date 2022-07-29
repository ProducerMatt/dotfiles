{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    nur.url = "github:nix-community/NUR";
    mynur = {
      url = "github:ProducerMatt/my-nur-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
      # use stable packages
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, rnix-lsp, home-manager, nur, mynur, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.checkMeta = true;
      };
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          config.checkMeta = true;
        };
      };
      rnix-lsp-overlay = final: prev: {
        rnix-lsp = import rnix-lsp;
      };
      mynur-overlay = final: prev: {
        rnix-lsp = import mynur;
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
            (builtins.toPath "${nixpkgs}/nixos/modules/profiles/all-hardware.nix")

            # Overlays-module makes "pkgs.unstable" available in configuration.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })

            nur.nixosModules.nur

            # Overlays-module makes "pkgs.mynur" available in configuration.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ mynur-overlay ]; })

            ./PortableNix.nix

            ./modules/openssh

            ./modules/apeloader

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.matt = {
                imports = [ ./Matt.nix nur.nixosModules.nur ];
              };
            }
          ];
        };
      };
    };
}
