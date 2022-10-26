{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.rsync-bpc pkgs.rrsync-bpc ];
}
