{
  # My Nix desktop is becoming unresponsive, only breaking free once the
  # OOM-killer kicks in. But this can take a _long_ time. Let's get aggressive.
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    extraArgs = let
      catPatterns = patterns: builtins.concatStringsSep "|" patterns;
      preferPatterns = [
        ".firefox-wrappe"
        "minetest"
        "vaultwarden"
        "java" # If it's written in java it's uninmportant enough it's ok to kill it
      ];
      avoidPatterns = [
        "bash"
        "mosh-server"
        "sshd"
        "systemd"
        "systemd-logind"
        "systemd-udevd"
        "tmux: client"
        "tmux: server"
        "nix"
      ];
    in [
      "--prefer"
      "'^(${catPatterns preferPatterns})$'"
      "--avoid"
      "'^(${catPatterns avoidPatterns})$'"
    ];
  };
}
