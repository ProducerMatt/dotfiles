{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.rsync-bpc ];
}
