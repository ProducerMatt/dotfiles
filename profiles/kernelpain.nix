{ config, lib, pkgs, ... }:

{
  boot.crashDump = {
    enable = true;
  };
}
