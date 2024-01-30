{ pkgs, extraModulesPath, inputs, lib, ... }:
let

  inherit (pkgs)
    agenix
    cachix
    editorconfig-checker
    mdbook
    nix
    nixpkgs-fmt
    nvfetcher-bin
    git-crypt
    ;
  ripsecrets = pkgs.nur.repos.ProducerMatt.ripsecrets;

  hooks = import ./hooks;

  pkgWithCategory = category: package: { inherit package category; };
  devos = pkgWithCategory "devos";
  linter = pkgWithCategory "linter";
  docs = pkgWithCategory "docs";
  repo = pkgWithCategory "repo";

in
{
  _file = toString ./.;

  imports = [ "${extraModulesPath}/git/hooks.nix" ];
  git = { inherit hooks; };

  # tempfix: remove when merged https://github.com/numtide/devshell/pull/123
  devshell.startup.load_profiles = pkgs.lib.mkForce (pkgs.lib.noDepEntry ''
    # PATH is devshell's exorbitant privilige:
    # fence against its pollution
    _PATH=''${PATH}
    # Load installed profiles
    for file in "$DEVSHELL_DIR/etc/profile.d/"*.sh; do
      # If that folder doesn't exist, bash loves to return the whole glob
      [[ -f "$file" ]] && source "$file"
    done
    # Exert exorbitant privilige and leave no trace
    export PATH=''${_PATH}
    unset _PATH
  '');

  commands = [
    (devos nix)
    (devos agenix)

    {
      category = "devos";
      name = nvfetcher-bin.pname;
      help = nvfetcher-bin.meta.description;
      command = "cd $PRJ_ROOT/pkgs; ${nvfetcher-bin}/bin/nvfetcher -c ./sources.toml $@";
    }

    (linter nixpkgs-fmt)
    (linter editorconfig-checker)

    (docs mdbook)
    (repo ripsecrets)
    (repo git-crypt)
  ]
  ++ lib.optionals (!pkgs.stdenv.buildPlatform.isi686) [
    (devos cachix)
  ]
  ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux && !pkgs.stdenv.buildPlatform.isDarwin) [
    (devos inputs.nixos-generators.packages.${pkgs.system}.default)
    (devos inputs.deploy.packages.${pkgs.system}.deploy-rs)
  ]
  ;
}