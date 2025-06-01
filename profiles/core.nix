{
  inputs,
  config,
  lib,
  overlays,
  pkgs,
  myLib,
  flakeInfo,
  ...
}: {
  imports = [
    inputs.home-manager-stable.nixosModules.home-manager
    (import ../modules/hm.nix)
    inputs.nix-index-database.nixosModules.nix-index
  ];
  environment.systemPackages =
    myLib.getPkgSnippet pkgs "base_cli";
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };
  security.pam.sshAgentAuth.enable = true;
  programs.nix-index-database.comma.enable = true;
  matt.hm.enable = true;
  users.motd = ''
    === ${config.networking.hostName} ===
    Flake revision #${builtins.toString flakeInfo.revCount} from ${flakeInfo.lastModifiedDate}
    Flake commit ${flakeInfo.shortRev}
  '';
  system.configurationRevision = flakeInfo.rev;
  system.copySystemConfiguration = true;
  nixpkgs.overlays = [
    (final: prev: (import ../pkgs/default.nix) final)
    overlays.webkitgtk
    overlays.displaylinkFix
    inputs.emacs-overlay.overlays.default
  ];
  # colmena needs no password
  security.sudo.wheelNeedsPassword = lib.mkForce false;
}
