pkgs:

with pkgs; [
  emacs28NativeComp
  nixos-generators
  #nox
  niv
  nixpkgs-review
  nix-init
  nix-diff
  nixfmt
  rnix-lsp
  stdenv
  gnumake
  resolve-march-native # find appropriate compiler flags for your cpu
  remarshal # convert between config file formats
  rtx # https://github.com/jdxcode/rtx

  ansible
  ansible-lint
  ansible-later
  ansible-language-server

  exercism

  erlang_nox
  erlang-ls

  elixir
  elixir_ls

  gleam
]
