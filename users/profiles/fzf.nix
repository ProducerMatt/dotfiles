{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
  programs.fish = {
    enable = true;
    plugins = with pkgs; with lib;
      map (plugin: (lib.our.cleanForFish pkgs.sources."${plugin}"))
        [
          "fzf"
        ];
  };
}
