{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.podman = {
    enable = true;
    ## Create a `docker` alias for podman, to use it as a drop-in replacement
    #dockerCompat = true;
    autoPrune.enable = true;
  };
  environment.systemPackages = [
    pkgs.podman-compose
  ];
}
