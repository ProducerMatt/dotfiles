pkgs:
with pkgs; [
  neovim
  emacs-unstable
  nixos-generators
  steam-run
  #nox
  niv
  nixpkgs-review
  nix-init
  nix-diff
  nil
  alejandra
  stdenv
  gnumake
  resolve-march-native # find appropriate compiler flags for your cpu
  remarshal # convert between config file formats
  rtx # https://github.com/jdxcode/rtx
  diffoscope # extensive diff tool -- directories, PDF files, ISOs, etc

  #ansible
  #ansible-lint
  #ansible-later
  #ansible-language-server

  editorconfig-core-c
  editorconfig-checker
]
