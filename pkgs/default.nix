pkgs: let
  # NOTE: fix for getting rrsync when not used as an overlay
  rsync-bpc = pkgs.callPackage (import ./rsync-bpc/default.nix) {};
in {
  # keep sources this first
  _sources = import ../npins/default.nix;
  # then, call packages with `final.callPackage`

  inherit rsync-bpc;

  rrsync-bpc = pkgs.callPackage (import ./rsync-bpc/rrsync.nix) {inherit rsync-bpc;};
  sshdo = pkgs.callPackage (import ./sshdo/default.nix) {};
}
