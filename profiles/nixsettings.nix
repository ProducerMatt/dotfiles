{
  imports = [./cachix.nix];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      # When only 1Gig free, try to free up to 5 gigs
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024 * 5)}
    '';
    # on my local network, builders-use-substitutes slows it down
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "matt" "nixremote"];
      trusted-public-keys = [
        "cache.PherigoNAS.local-1:an8uYbjcJQKUvSdBEe/hlAbbHGDFH+sZZK6PpAQlSn8="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;
}
