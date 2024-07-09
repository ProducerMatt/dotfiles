{
  myLib,
  pkgs,
  ...
}: let
  getSnippet = myLib.getPkgSnippet pkgs;
in {
  environment = {
    systemPackages = builtins.concatLists [
      (getSnippet "base_cli")
      (getSnippet "dev")
      (getSnippet "sysadmin")
      (getSnippet "git")
    ];
    extraOutputsToInstall = ["dev" "lib"];
  };
  networking.firewall.allowedTCPPorts = [
    8888
    8080
    7860
    7861 # dev servers gotta dev
  ];
}
