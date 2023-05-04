{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  #nixConfig.extra-substituters =
  #  "https://nrdxp.cachix.org https://nix-community.cachix.org https://producermatt-nur.cachix.org https://ai.cachix.org";
  #nixConfig.extra-trusted-public-keys =
  #  "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= producermatt-nur.cachix.org-1:vwAYMzXLtFGCQZf9HpyrncxXQ/Qk5yGjt2CeM7/neIs= ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc=";

  inputs =
    {
      # Track channels with commits tested and built by hydra
      nixos.url = "github:nixos/nixpkgs/nixos-22.11";
      latest.url = "github:nixos/nixpkgs/nixos-unstable";
      nixos-22-05.url = "github:nixos/nixpkgs/nixos-22.05";
      # For darwin hosts: it can be helpful to track this darwin-specific stable
      # channel equivalent to the `nixos-*` channels for NixOS. For one, these
      # channels are more likely to provide cached binaries for darwin systems.
      # But, perhaps even more usefully, it provides a place for adding
      # darwin-specific overlays and packages which could otherwise cause build
      # failures on Linux systems.
      nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

      nur.url = "github:nix-community/nur";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      digga.inputs.home-manager.follows = "home";
      digga.inputs.deploy.follows = "deploy";

      home.url = "github:nix-community/home-manager/release-22.11";
      home.inputs.nixpkgs.follows = "nixos";

      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs.nixpkgs.follows = "nixos";

      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixos";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "nixos";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "latest";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      nixos-generators.url = "github:nix-community/nixos-generators";

      rnix-lsp = {
        url = "github:nix-community/rnix-lsp";
        inputs.nixpkgs.follows = "latest";
      };

      nixrepl = {
        url = "github:schuelermine/nixos-repl-setup";
      };
      mynur = {
        url = "github:ProducerMatt/my-nur-pkgs";
      };
      guix-overlay = {
        url = "github:foo-dogsquared/nix-overlay-guix";
        inputs.nixpkgs.follows = "nixos-22-05";
      };
      nixseparatedebuginfod.url = "github:symphorien/nixseparatedebuginfod";
    };

  outputs =
    { self
    , digga
    , nixos
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , nixpkgs
    , guix-overlay
    , nixseparatedebuginfod
    , ...
    } @ inputs:
    let
      # NOTE: how do i make this available outside of this file?
      # NOTE: what about the variable sourceInfo?
      flakeVersion = with self; {
        inherit lastModified lastModifiedDate narHash;
        # TODO: could clearly be a function mapping
        rev = (self.rev or "dirty");
        shortRev = (self.shortRev or "dirty");
        revCount = (self.revCount or "dirty");
      };
    in
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = {
          allowUnfree = true;
          checkMeta = true;
        };

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays =
              let
                nur-modules = import nur {
                  nurpkgs = nixos.legacyPackages.x86_64-linux;
                };
              in
              [
                nur-modules.repos.ProducerMatt.overlays.mosh-unset-tty
                guix-overlay.overlays.default
              ];
          };
          nixpkgs-darwin-stable = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [
              # TODO: restructure overlays directory for per-channel overrides
              # `importOverlays` will import everything under the path given
              (channels: final: prev: {
                inherit (channels.latest) mas;
              } // prev.lib.optionalAttrs true { })
            ];
          };
          latest = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
            });
          })

          nur.overlay
          agenix.overlays.default
          nvfetcher.overlays.default
          guix-overlay.overlays.default
          (final: prev: {
            latest = nixpkgs;
          })
          (import ./overlays/displaylinkFix.nix)
          (import ./overlays/webkitgtk.nix)

          (import ./pkgs)
        ];

        nixos = {
          hostDefaults = {
            system = "x86_64-linux";
            channelName = "latest";
            # NOTE: channelName determines what nixpkgs the shell uses
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules =
              let
                nur-modules = import nur {
                  nurpkgs = nixos.legacyPackages.x86_64-linux;
                };
              in
              [
                { lib.our = self.lib; }
                digga.nixosModules.bootstrapIso
                digga.nixosModules.nixConfig
                home.nixosModules.home-manager
                agenix.nixosModules.age
                ({ pkgs, config, ... }: {
                  users.motd = ''
                    ${config.networking.hostName}
                    Flake revision #${builtins.toString flakeVersion.revCount} from ${flakeVersion.lastModifiedDate}
                    Flake commit ${flakeVersion.shortRev}
                  '';
                  system.configurationRevision = flakeVersion.rev;
                })
                nur-modules.repos.ProducerMatt.modules.apeLoader
              ];
          };

          imports = [ (digga.lib.importHosts ./hosts/nixos) ];
          hosts = {
            /* set host-specific properties here */
            PortableNix = {
              modules = [ nixseparatedebuginfod.nixosModules.default ];
            };
          };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [
                core
                nixsettings
                cachix
                users.matt
                openssh
                earlyOOM
              ];
            };
          };
        };

        darwin = {
          hostDefaults = {
            system = "x86_64-darwin";
            channelName = "nixpkgs-darwin-stable";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              { lib.our = self.lib; }
              digga.darwinModules.nixConfig
              home.darwinModules.home-manager
              agenix.nixosModules.age
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts/darwin) ];
          hosts = {
            /* set host-specific properties here */
            #Mac = { };
          };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [ core.darwin users.darwin ];
            };
          };
        };

        home = {
          #imports = [ (digga.lib.importExportableModules ./users/modules) ];
          modules = [ ];
          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ core direnv git ];
              dev = [ fzf nix-index ];
              graphical = [ fonts ];
            };
          };
          users = digga.lib.rakeLeaves ./users/hm;
        };

        devshell = ./shell;

        # TODO: similar to the above note: does it make sense to make all of
        # these users available on all systems?
        homeConfigurations = digga.lib.mergeAny
          (digga.lib.mkHomeConfigurations self.darwinConfigurations)
          (digga.lib.mkHomeConfigurations self.nixosConfigurations)
        ;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

      }
  ;
}
