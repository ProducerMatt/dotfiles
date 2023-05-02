{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      init = { defaultBranch = "main"; };
      pull = { rebase = false; }; # setting to true was a mistake
    };
  };
  home.packages = with pkgs; [
    git-crypt
    tig
    git-ignore
    nur.repos.ProducerMatt.ripsecrets
  ];
}
