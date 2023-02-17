{ config, lib, pkgs, ... }:

{
  # My Nix desktop is becoming unresponsive, only breaking free once the
  # OOM-killer kicks in. But this can take a _long_ time. Let's get aggressive.
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10; # <%10 free
  };
}
