{
  pkgs,
  myLib,
  ...
}: {
  environment.systemPackages =
    myLib.getPkgSnippet pkgs "base_cli";
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security.sudo = {
    enable = true;
    execWheelOnly = true;
  };
  security.pam.sshAgentAuth.enable = true;
}
