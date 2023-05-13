pkgs:

with pkgs; [
  nixos-generators
  #nox
  niv
  nixpkgs-review
  nix-init
  nix-diff
  nixfmt
  stdenv
  gnumake
  resolve-march-native # find appropriate compiler flags for your cpu
  remarshal # convert between config file formats
]
