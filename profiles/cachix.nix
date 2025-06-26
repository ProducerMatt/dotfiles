let
  sources = import ../snippets/substitutors.nix;
in
  with builtins; {
    nix.settings = {
      extra-substituters = map (elemAt 0) sources;
      extra-trusted-public-keys = map (elemAt 1) sources;
    };
  }
