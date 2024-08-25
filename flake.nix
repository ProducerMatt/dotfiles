{
  description = "Description for the project";

  inputs = {
    # Track channels with commits tested and built by hydra
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-22-05.url = "github:nixos/nixpkgs/nixos-22.05";
    # For darwin hosts: it can be helpful to track this darwin-specific stable
    # channel equivalent to the `nixos-*` channels for NixOS. For one, these
    # channels are more likely to provide cached binaries for darwin systems.
    # But, perhaps even more usefully, it provides a place for adding
    # darwin-specific overlays and packages which could otherwise cause build
    # failures on Linux systems.
    #nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";

    nur.url = "github:nix-community/nur";

    #flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus/?ref=refs/pull/134/head";

    #home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
    #home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #darwin.url = "github:LnL7/nix-darwin";
    #darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

    #deploy.url = "github:serokell/deploy-rs";
    #deploy.inputs.nixpkgs.follows = "nixpkgs-stable";

    #agenix.url = "github:ryantm/agenix";
    #agenix.inputs.nixpkgs.follows = "nixpkgs-stable";

    #nvfetcher.url = "github:berberman/nvfetcher";
    #nvfetcher.inputs.nixpkgs.follows = "nixpkgs-stable";

    #naersk.url = "github:nmattia/naersk";
    #naersk.inputs.nixpkgs.follows = "nixpkgs";

    #nixos-hardware.url = "github:nixos/nixos-hardware";

    #nixos-generators.url = "github:nix-community/nixos-generators";
    #nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nixrepl = {
      url = "github:schuelermine/nixos-repl-setup";
    };
    #mynur = {
    #  url = "github:ProducerMatt/my-nur-pkgs";
    #};
    #guix-overlay = {
    #  url = "github:foo-dogsquared/nix-overlay-guix";
    #  inputs.nixpkgs.follows = "nixos-22-05";
    #};
    nixseparatedebuginfod.url = "github:symphorien/nixseparatedebuginfod";

    #rtx-flake = {
    #  url = "github:jdxcode/rtx";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.flake-utils.follows = "flake-utils-plus";
    #};
    #poetry2nix = {
    #  url = "github:nix-community/poetry2nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    #vscode-server = {
    #  url = "github:nix-community/nixos-vscode-server";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.flake-utils.follows = "flake-utils-plus";
    #};

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    #git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-hammering.url = "github:jtojnar/nixpkgs-hammering";
    nixpkgs-hammering.inputs.nixpkgs.follows = "nixpkgs";

    templates.url = "github:ProducerMatt/nix-templates";
  };

  outputs = {
    self,
    flake-parts,
    #flake-utils-plus,
    #nixpkgs-stable,
    nixpkgs,
    #home-manager-stable,
    home-manager,
    #nixos-hardware,
    #nur,
    #agenix,
    #nvfetcher,
    #deploy,
    #guix-overlay,
    #nixseparatedebuginfod,
    #rtx-flake,
    #poetry2nix,
    #vscode-server,
    #nix-formatter-pack,
    emacs-overlay,
    git-hooks,
    nix-index-database,
    ...
  } @ inputs: let
    utils = import ./utils.nix;
    myLib = utils nixpkgs.lib;
    defaultPkgs = system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowMeta = true;
        };
        overlays = [
          (final: prev: {
            nixpkgs-hammering = inputs.nixpkgs-hammering.packages.${system}.default;
          })
        ];
      };
    hm = import ./modules/hm.nix;
    flakeInfo = {
      inherit (self) lastModified lastModifiedDate narHash;
      # TODO: could clearly be a function mapping
      rev = self.rev or "dirty";
      shortRev = self.shortRev or "dirty";
      revCount = self.revCount or "dirty";
      rootDir = ./.;
    };
  in
    flake-parts.lib.mkFlake {
      inherit inputs;
    } ({withSystem, ...}: {
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
        pkgs,
        system,
        ...
      }: let
        colmena = pkgs.colmena.overrideDerivation (oldSettings: {
          patches = oldSettings.patches ++ [./pkgs/colmena-disable-pure-eval.patch];
        });
        ########################
        # Git pre-push checks
        pc-hooks = git-hooks.lib.${system}.run {
          # only run on push and directly calling `pre-commit` in the shell
          default_stages = ["manual" "push" "pre-merge-commit"];
          src = ./.;
          hooks = let
            enable_on_commit = {
              enable = true;
              stages = ["manual" "push" "pre-merge-commit" "pre-commit"];
            };
          in {
            alejandra = enable_on_commit;
            flake-checker = enable_on_commit;

            convco = {
              enable = true;
              stages = ["commit-msg"];
            };
          };
        };
      in {
        # This sets `pkgs` to a nixpkgs with allowUnfree option set.
        _module.args.pkgs = defaultPkgs system;

        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        devShells.default = pkgs.mkShell {
          packages = with pkgs;
            [
              nixVersions.latest
              colmena
              fish
              nil
              alejandra
              statix
              deadnix
              npins
            ]
            ++ pc-hooks.enabledPackages;
          shellHook = pc-hooks.shellHook;
        };

        checks.default = pc-hooks;
      };
      flake = let
        specialArgs = {
          inherit self myLib flakeInfo inputs;
          profiles = myLib.makeProfiles ./profiles;
          hmProfiles = myLib.makeProfiles ./users/profiles;
          overlays = myLib.rakeLeaves ./overlays;
          users = myLib.rakeLeaves ./users;
          modules = myLib.rakeLeaves ./modules;
        };
      in {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

        nixosModules = {
          inherit hm;
        };

        nixosConfigurations = let
          mkSystem = path: sys:
            myLib.mkSystem specialArgs path sys;
        in {
          PortableNix = mkSystem ./hosts/PortableNix "x86_64-linux";
          BabyDell = mkSystem ./hosts/BabyDell "x86_64-linux";
        };

        colmena = {
          meta = {
            nixpkgs = defaultPkgs "x86_64-linux";
            specialArgs = specialArgs;
          };
          PortableNix = import ./hosts/PortableNix {
            overrides = {
              deployment = {
                allowLocalDeployment = true;
                targetHost = "192.168.1.5";
                targetUser = "matt";
              };
            };
          };
          BabyDell = import ./hosts/BabyDell {
            overrides = {
              deployment = {
                targetHost = "192.168.1.10";
                targetUser = "matt";
              };
            };
          };
        };
      };
    });
}
