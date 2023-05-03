{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    comma # get any arbitrary program
    tmux
    vim
    wget
    git
    nano
    bind.dnsutils
    fd
    ripgrep
    ethtool
    smartmontools
    aria2
    libressl
    nixos-generators
    #nox
    niv
    parallel # xargs but multi-core

    nur.repos.ProducerMatt.cosmo.pledge
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
