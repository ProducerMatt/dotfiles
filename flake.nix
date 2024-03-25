{
  description = "Description for the project";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    # Track channels with commits tested and built by hydra
    pkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    pkgs-latest.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-22-05.url = "github:nixos/nixpkgs/nixos-22.05";
    # For darwin hosts: it can be helpful to track this darwin-specific stable
    # channel equivalent to the `nixos-*` channels for NixOS. For one, these
    # channels are more likely to provide cached binaries for darwin systems.
    # But, perhaps even more usefully, it provides a place for adding
    # darwin-specific overlays and packages which could otherwise cause build
    # failures on Linux systems.
    nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";

    nur.url = "github:nix-community/nur";

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/?ref=refs/pull/134/head";

    home.url = "github:nix-community/home-manager/release-23.05";
    home.inputs.nixpkgs.follows = "pkgs-latest";
    home-latest.url = "github:nix-community/home-manager/master";
    home-latest.inputs.nixpkgs.follows = "pkgs-latest";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "pkgs-stable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "pkgs-stable";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "pkgs-stable";

    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "pkgs-latest";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "pkgs-latest";

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "pkgs-latest";
    };

    nixrepl = {
      url = "github:schuelermine/nixos-repl-setup";
    };
    mynur = {
      url = "github:ProducerMatt/my-nur-pkgs";
    };
    #guix-overlay = {
    #  url = "github:foo-dogsquared/nix-overlay-guix";
    #  inputs.nixpkgs.follows = "nixos-22-05";
    #};
    nixseparatedebuginfod.url = "github:symphorien/nixseparatedebuginfod";

    rtx-flake = {
      url = "github:jdxcode/rtx";
      inputs.nixpkgs.follows = "pkgs-latest";
      inputs.flake-utils.follows = "flake-utils-plus";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "pkgs-latest";
    };
    #vscode-server = {
    #  url = "github:nix-community/nixos-vscode-server";
    #  inputs.nixpkgs.follows = "pkgs-latest";
    #  inputs.flake-utils.follows = "flake-utils-plus";
    #};

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
  };

  outputs = {
    self,
    flake-parts,
    flake-utils-plus,
    pkgs-stable,
    pkgs-latest,
    home,
    home-latest,
    nixos-hardware,
    nur,
    agenix,
    nvfetcher,
    deploy,
    nixpkgs,
    #, guix-overlay
    nixseparatedebuginfod,
    rtx-flake,
    poetry2nix,
    #, vscode-server,
    nix-formatter-pack,
    ...
  } @ inputs: let
    flakeVersion = with self; {
      inherit lastModified lastModifiedDate narHash;
      # TODO: could clearly be a function mapping
      rev = self.rev or "dirty";
      shortRev = self.shortRev or "dirty";
      revCount = self.revCount or "dirty";
    };
    lib = import ./utils.nix {inherit (pkgs-stable) lib;};
    nfpSettings = {system, pkgs}: {
          inherit system pkgs;
          config = {
            tools = {
              deadnix.enable = true;
              alejandra.enable = true;
              statix.enable = true;
            };
          };
        };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true; # DEBUG

      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
      ];
      systems = ["x86_64-linux"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # This sets `pkgs` to a nixpkgs with allowUnfree option set.
        _module.args.pkgs = import pkgs-latest {
          inherit system;
          config = {
            allowUnfree = true;
            allowMeta = true;
          };
        };

        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nix
            colmena
            fish
            nil
            alejandra
            statix
            deadnix
          ];
        };

        formatter = nix-formatter-pack.lib.mkFormatter (nfpSettings {inherit pkgs system;});

        checks.nix-formatter-pack =
          nix-formatter-pack.lib.mkCheck
          ((nfpSettings {inherit pkgs system;})
          // {checkFiles = [./.];});
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

        colmena = {
          meta = {
            nixpkgs = import pkgs-latest {
              system = "x86_64-linux";
            };
          };
          defaults = {pkgs, ...}: {
            system.copySystemConfiguration = lib.mkForce false;
            nix = {
              package = pkgs.nixUnstable;
              settings = {
                trusted-users = ["matt"];
                extra-experimental-features = "nix-command flakes";
              };
            };
            security.sudo.wheelNeedsPassword = false;
          };
          NixVM = import ./hosts/NixVM;
        };
      };
    };
}
