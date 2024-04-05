# File originally written by alyssa.net
# original here under MIT license: https://git.qyliss.net/nixlib/tree/modules/server/git/nixpkgs/default.nix
{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) writeText;
  toGitConfig = lib.generators.toINI {listsAsDuplicateKeys = true;};
in {
  users.groups.nixpkgs = {};

  environment.etc.gitconfig.text = ''
    [safe]
      directory = /var/lib/git/nixpkgs.git
  '';

  systemd.tmpfiles.rules = [
    "L+ /var/lib/git/nixpkgs.git/HEAD - - - - refs/heads/master"
    "L+ /var/lib/git/nixpkgs.git/config - - - - ${writeText "config" (toGitConfig {
      core.repositoryformatversion = 0;
      core.filemode = true;
      core.bare = true;
      core.sharedRepository = "world";
      "remote \"origin\"" = {
        url = "https://github.com/NixOS/nixpkgs";
        fetch = [
          "+refs/heads/master:refs/remotes/origin/master"
          "+refs/heads/staging:refs/remotes/origin/staging"
          "+refs/heads/staging-*:refs/remotes/origin/staging-*"
          "+refs/heads/nixos-*:refs/remotes/origin/nixos-*"
          "+refs/heads/nixpkgs-unstable:refs/remotes/origin/nixpkgs-unstable"
          "+refs/heads/nixpkgs-*-darwin:refs/remotes/origin/nixpkgs-*-darwin"
          "+refs/heads/release-*:refs/remotes/origin/release-*"
        ];
      };
    })}"
    "d /var/lib/git/nixpkgs.git 2775 - nixpkgs"
    "d /var/lib/git/nixpkgs.git/refs 2775 - nixpkgs"
    "d /var/lib/git/nixpkgs.git/objects 2775 - nixpkgs"
    "d /var/lib/git/nixpkgs.git/objects/pack 2775 - nixpkgs"
  ];

  systemd.services.git-fetch-nixpkgs = {
    after = ["network-online.target"];
    requires = ["network-online.target"];
    serviceConfig.DynamicUser = true;
    serviceConfig.Group = "nixpkgs";
    serviceConfig.ReadWritePaths = "/var/lib/git/nixpkgs.git";
    serviceConfig.ExecStart = "${pkgs.gitMinimal}/bin/git --git-dir /var/lib/git/nixpkgs.git fetch"; # -vupP";
    serviceConfig.Type = "oneshot";
    serviceConfig.UMask = "0002";
  };

  systemd.timers.git-fetch-nixpkgs = {
    wantedBy = ["timers.target"];
    timerConfig.OnActiveSec = 0;
    timerConfig.OnUnitActiveSec = 300;
  };
}
