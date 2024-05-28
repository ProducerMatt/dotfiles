final: prev: {
  # keep sources this first
  _sources = import ../npins/default.nix;
  # then, call packages with `final.callPackage`
  rsync-bpc = final.callPackage (import ./rsync-bpc/default.nix) { };
  rrsync-bpc = final.callPackage (import ./rsync-bpc/rrsync.nix) { };
  sshdo = final.callPackage (import ./sshdo/default.nix) { };
}
