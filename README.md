# Usage

To update:
``` sh
nix flake update
```

To test changes:
``` sh
sudo nixos-rebuild test --flake .#
```

To apply changes:

``` sh
sudo nixos-rebuild switch --flake .#
```
