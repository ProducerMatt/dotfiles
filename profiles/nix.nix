{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "matt" ];
      substituters = [ "https://cache.nixos.org" "https://cache.nixos.org/"
                       "https://producermatt-nur.cachix.org"
                       "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                              "producermatt-nur.cachix.org-1:vwAYMzXLtFGCQZf9HpyrncxXQ/Qk5yGjt2CeM7/neIs="
                               "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
  };
  nixpkgs.config.allowUnfree = true;
}
