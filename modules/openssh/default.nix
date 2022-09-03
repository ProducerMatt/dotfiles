{ config, pkgs, ... }:

{
  # Mostly cribbed from github.com/k4yt3x/sshd_config
  # TODO:
  # - allow only specified users to log in
  # - allow only specified IPs and ports
  # - define known hosts
  services.openssh = {
    enable = true;
    macs = [
      "hmac-sha2-256-etm@openssh.com"
      "hmac-sha2-512-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
    ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes128-gcm@openssh.com"
      "aes256-ctr"
      "aes192-ctr"
      "aes128-ctr"
    ];
    kexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "diffie-hellman-group-exchange-sha256" # requires shortened moduli file
      "diffie-hellman-group14-sha256"
    ];
    moduliFile = ./moduli-shortened;
    passwordAuthentication = false; # NOTE: make sure you can log in!
    forwardX11 = false;
    permitRootLogin = "no";
  };
  environment.systemPackages = with pkgs; [
    mosh
  ];
  programs.mosh.enable = true;
}
