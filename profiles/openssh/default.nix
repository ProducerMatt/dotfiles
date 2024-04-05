{
  config,
  pkgs,
  ...
}: {
  # Mostly cribbed from github.com/k4yt3x/sshd_config
  # Last Updated: December 21, 2023
  # TODO:
  # - allow only specified users to log in
  # - allow only specified IPs and ports
  # - define known hosts
  services.openssh = {
    enable = true;
    moduliFile = ./moduli-shortened;

    extraConfig = ''
      ########## Features ##########

      # accept locale-related environment variables
      AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
      AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
      AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
      AcceptEnv XMODIFIERS
      AcceptEnv TERM

      # disallow ssh-agent forwarding to prevent lateral movement
      AllowAgentForwarding no

      ## prevent TCP ports from being forwarded over SSH tunnels
      ## **please be aware that disabling TCP forwarding does not prevent port forwarding**
      ## any user with an interactive login shell can spin up his/her own instance of sshd
      #AllowTcpForwarding no
      AllowTcpForwarding yes

      # prevent StreamLocal (Unix-domain socket) forwarding
      AllowStreamLocalForwarding no

      ## disables all forwarding features
      ## overrides all other forwarding switches
      #DisableForwarding yes
      DisableForwarding no

      # disallow remote hosts from connecting to forwarded ports
      # i.e. forwarded ports are forced to bind to 127.0.0.1 instad of 0.0.0.0
      GatewayPorts no

      # prevent tun device forwarding
      PermitTunnel no

      # suppress MOTD
      PrintMotd no

      # disable X11 forwarding since it is not necessary
      X11Forwarding no

      ########## Authentication ##########

      # permit only the specified users to login
      #AllowUsers k4yt3x

      # permit only users within the specified groups to login
      #AllowGroups k4yt3x

      # uncomment the following options to permit only pubkey authentication
      # be aware that this will disable password authentication
      #   - AuthenticationMethods: permitted authentication methods
      #   - PasswordAuthentication: set to no to disable password authentication
      #   - UsePAM: set to no to disable all PAM authentication, also disables PasswordAuthentication when set to no
      #AuthenticationMethods publickey
      #PasswordAuthentication no
      #UsePAM no

      # PAM authentication enabled to make password authentication available
      # remove this if password authentication is not needed
      UsePAM yes

      # challenge-response authentication backend it not configured by default
      # therefore, it is set to "no" by default to avoid the use of an unconfigured backend
      ChallengeResponseAuthentication no

      # set maximum authenticaion retries to prevent brute force attacks
      MaxAuthTries 3

      # disallow connecting using empty passwords
      PermitEmptyPasswords no

      # prevent root from being logged in via SSH
      PermitRootLogin no

      # enable pubkey authentication
      PubkeyAuthentication yes

      ########## Cryptography ##########

      # explicitly define cryptography algorithms to avoid the use of weak algorithms
      # AES CTR modes have been removed to mitigate the Terrapin attack
      #   https://terrapin-attack.com/
      Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com
      HostKeyAlgorithms rsa-sha2-512,rsa-sha2-256,ssh-ed25519
      MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com

      # short moduli should be deactivated before enabling the use of diffie-hellman-group-exchange-sha256
      # see this link for more details: https://github.com/k4yt3x/sshd_config#deactivating-short-diffie-hellman-moduli
      KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha256

      ########## Connection Preferences ##########

      # number of client alive messages sent without client responding
      ClientAliveCountMax 2

      # send a keepalive message to the client when the session has been idle for 300 seconds
      # this prevents/detects connection timeouts
      ClientAliveInterval 300

      # compression before encryption might cause security issues
      Compression no

      # prevent SSH trust relationships from allowing lateral movements
      IgnoreRhosts yes

      # log verbosely for addtional information
      #LogLevel VERBOSE

      # allow a maximum of two multiplexed sessions over a single TCP connection
      MaxSessions 2

      # enforce SSH server to only use SSH protocol version 2
      # SSHv1 contains security issues and should be avoided at all costs
      # SSHv1 is disabled by default after OpenSSH 7.0, but this option is
      #   specified anyways to ensure this configuration file's compatibility
      #   with older versions of OpenSSH server
      Protocol 2

      # override default of no subsystems
      # path to the sftp-server binary depends on your distribution
      #Subsystem sftp /usr/lib/openssh/sftp-server
      #Subsystem sftp /usr/libexec/openssh/sftp-server
      #Subsystem sftp internal-sftp

      # let ClientAliveInterval handle keepalive
      TCPKeepAlive no

      # disable reverse DNS lookups
      UseDNS no
    '';
  };
  environment.systemPackages = with pkgs; [
    mosh
  ];
  programs.mosh.enable = true;
}
