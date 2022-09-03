{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nano

    config.nur.repos.ProducerMatt.pledge
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
