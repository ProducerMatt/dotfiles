{ inputs, ... }:

{
  imports = [
    inputs.guix-overlay.nixosModules.guix
  ];
  services.guix.enable = true;
}
