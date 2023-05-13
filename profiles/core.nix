{ config, pkgs, lib, ... }:

let
  getSnippet = s: import (../snippets + "/${s}.nix") pkgs;
in
{
  environment.systemPackages =
    (getSnippet "base_cli");
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
