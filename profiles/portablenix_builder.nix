{
  nix = {
    buildMachines = [
      {
        hostName = "PortableNix.local";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        sshUser = "nixremote";
        sshKey = "/home/matt/.ssh/id_nixremote_ed25519";
        maxJobs = 16;
        speedFactor = 8;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];
    distributedBuilds = true;
  };
}
