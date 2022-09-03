# User config that can't be done under home-manager
{ pkgs, ... }:

{
  users.users.matt = {
    isNormalUser = true;
    description = "Matt";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfK6c9SiwYYRxy10EMVh1sctDgy6JN/fMyzsO1hACnN ProducerMatt login key"
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true; # required for vendor distributions of autocomplete, etc.
}
