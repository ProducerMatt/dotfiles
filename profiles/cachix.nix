let
  sources = import ../snippets/substitutors.nix;
  first = x: builtins.elemAt x 0;
  second = x: builtins.elemAt x 1;
in {
  nix.settings = {
    extra-substituters = map first sources;
    extra-trusted-substituters = map first sources;
    extra-trusted-public-keys = map second sources;
  };
}
