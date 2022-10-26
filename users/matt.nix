{ hmUsers, pkgs, ... }:
{
  home-manager.users = { inherit (hmUsers) matt; };

  users.users.matt = {
    isNormalUser = true;
    description = "Matt";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfK6c9SiwYYRxy10EMVh1sctDgy6JN/fMyzsO1hACnN ProducerMatt login key"
      ''
        from="192.168.1.4",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty,command="rrsync -ro /home/matt" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0MTVh6Bi82YLKJlpo+4fQRQ3mhZWXFD7VcZEPPWHWA backup@BackupPC
      ''
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true; # required for vendor distributions of autocomplete, etc.
}
