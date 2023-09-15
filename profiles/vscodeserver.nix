{ config, lib, pkgs, ... }:

{
  services.openvscode-server = {
    enable = true;
    user = "matt";
  };
}
