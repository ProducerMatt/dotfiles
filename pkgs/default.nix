final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  rsync-bpc = final.callPackage (import ./rsync-bpc/default.nix) { };
  rrsync-bpc = final.callPackage (import ./rsync-bpc/rrsync.nix) { };
}
