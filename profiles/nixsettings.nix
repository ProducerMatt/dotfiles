{
  inputs,
  pkgs,
  ...
}: {
  imports = [./cachix.nix];
  nix = {
    package = pkgs.nixVersions.nix_2_23;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations recursive-nix
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
      # slows performance of writes, let weekly optimize get it
      auto-optimise-store = false;
      trusted-users = ["root" "matt" "nixremote"];
      trusted-public-keys = [
        "cache.PherigoNAS.local-1:an8uYbjcJQKUvSdBEe/hlAbbHGDFH+sZZK6PpAQlSn8="
      ];
    };
    registry =
      builtins.mapAttrs (name: flake: {
        from = {
          id = name;
          type = "indirect";
        };
        flake = flake;
      })
      inputs;
  };
  nixpkgs.config.allowUnfree = true;
}
