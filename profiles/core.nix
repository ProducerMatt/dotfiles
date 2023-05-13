{ config, pkgs, lib, ... }:

let
  getSnippet = s: import (builtins.toPath "../snippets/${s}.nix") pkgs;
in
{
  environment.systemPackages = with pkgs;
    (getSnippet "base_cli")
    ++ (getSnippet "sysadmin");
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
