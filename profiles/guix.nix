{ inputs, ... }:

{
  imports = [
    inputs.guix-overlay.nixosModules.guix
  ];
  services.guix.enable = true;
  services.guix.package = inputs.guix-overlay.packages.x86_64-linux.guix;
}
