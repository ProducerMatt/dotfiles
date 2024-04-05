{lib, ...}: let
  sources = [
    [
      "https://ai.cachix.org"
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
    ]
    [
      "https://nrdxp.cachix.org"
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    ]
    [
      "https://producermatt-nur.cachix.org"
      "producermatt-nur.cachix.org-1:vwAYMzXLtFGCQZf9HpyrncxXQ/Qk5yGjt2CeM7/neIs="
    ]
    [
      "https://nix-community.cachix.org"
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ]
    [
      "https://foo-dogsquared.cachix.org"
      "foo-dogsquared.cachix.org-1:/2fmqn/gLGvCs5EDeQmqwtus02TUmGy0ZlAEXqRE70E="
    ]
    [
      "https://cuda-maintainers.cachix.org"
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ]
  ];
in
  with builtins;
  with lib; {
    nix.settings = {
      substituters = map (pair: head pair) sources;
      trusted-public-keys = map (pair: last pair) sources;
    };
  }
