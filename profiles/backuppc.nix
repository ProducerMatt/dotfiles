{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.rsync-bpc
    pkgs.rrsync-bpc
    #pkgs.sshdo
  ];
}
