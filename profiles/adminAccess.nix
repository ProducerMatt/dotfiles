{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; builtins.concatLists [
    (getSnippet "base_cli")
    (getSnippet "dev")
    (getSnippet "sysadmin")
    (getSnippet "git")
  ];
}
