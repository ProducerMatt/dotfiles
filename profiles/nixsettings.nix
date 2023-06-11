{ pkgs, ... }:

{
  imports = [ ./cachix ];
  nix = {
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
      trusted-public-keys = [
        "cache.PherigoNAS.local-1:an8uYbjcJQKUvSdBEe/hlAbbHGDFH+sZZK6PpAQlSn8="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;
}
