{ config, lib, pkgs, ... }:

let
  getSnippet = s: import (../snippets + "/${s}.nix") pkgs;
in
{
  environment.systemPackages = with pkgs; builtins.concatLists [
    (getSnippet "base_cli")
    (getSnippet "dev")
    (getSnippet "sysadmin")
    (getSnippet "git")
  ];
}
