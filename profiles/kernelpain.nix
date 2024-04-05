{
  config,
  lib,
  pkgs,
  ...
}: {
  # When life ain't going how you thought it would
  boot.crashDump = {
    enable = true;
  };
}
