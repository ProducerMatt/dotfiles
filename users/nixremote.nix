_: {
  users.users.nixremote = {
    description = "user for remotely initiated build jobs";
    isSystemUser = true;
    group = "nixremote";
    useDefaultShell = true;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHR4G/Vse74jiFwpKYagAEMlfqYs/HdXzSkXgd/6cIKk nix remote building"];
  };
  users.groups.nixremote = {};
  services.openssh.extraConfig = ''
    Match User nixremote
      AllowAgentForwarding no
      AllowTcpForwarding no
      PermitTTY no
      PermitTunnel no
      X11Forwarding no
    Match All
  '';
}
