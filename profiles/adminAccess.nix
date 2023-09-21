{ config, lib, pkgs, ... }:

let
  getSnippet = lib.our.getPkgSnippet pkgs;
in
{
  environment.systemPackages = with pkgs; builtins.concatLists [
    (getSnippet "base_cli")
    (getSnippet "dev")
    (getSnippet "sysadmin")
    (getSnippet "git")
  ];
  networking.firewall.allowedTCPPorts = [
    8888
    8080
    7860
    7861 # dev servers gotta dev
  ];
}
