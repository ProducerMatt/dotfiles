{ config, pkgs, lib, ... }:

{
  environment.systemPackages =
    (lib.our.getPkgSnippet pkgs "base_cli");
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
