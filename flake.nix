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
    nixrepl = {
      url = "github:schuelermine/nixos-repl-setup";
    };
  };
  outputs = {
    self, nixpkgs, nixpkgs-unstable,
      rnix-lsp, home-manager, nur, mynur, flake-utils, ...
  }:
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
        mynur = mynur.packages."${system}";
      };

      lib = nixpkgs.lib;

      # NOTE: how do i make this available outside of this file?
      flakeVersion = with self; {
        inherit lastModified lastModifiedDate narHash;
        # TODO: could clearly be a function mapping
        rev = (self.rev or "dirty");
        shortRev = (self.shortRev or "dirty");
        revCount = (self.revCount or "dirty");
      };
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
          system = flake-utils.lib.system.x86_64-linux;
          modules = [
            ({ pkgs, ... }: {
              system.configurationRevision = flakeVersion.rev;
            })

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
