{ pkgs, ... }:

{
  imports = [ ./cachix ];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    # on my local network, builders-use-substitutes slows it down
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "matt" "nixremote" ];
      trusted-public-keys = [
        "cache.PherigoNAS.local-1:an8uYbjcJQKUvSdBEe/hlAbbHGDFH+sZZK6PpAQlSn8="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;
}
