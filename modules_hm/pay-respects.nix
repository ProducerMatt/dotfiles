{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.pay-respects;
  payRespectsCmd = lib.getExe cfg.package;
  cfgOptions = lib.concatStringsSep " " cfg.options;
in {
  options.programs.pay-respects = {
    enable = lib.mkEnableOption "pay-respects";

    package = lib.mkPackageOption pkgs "pay-respects" {};

    options = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["--alias"];
      example = [
        "--alias"
        "f"
      ];
      description = ''
        List of options to pass to pay-respects <shell>.
      '';
    };

    enableBashIntegration = lib.mkEnableOption "enableBashIntegration";

    enableFishIntegration = lib.mkEnableOption "enableFishIntegration";

    enableNushellIntegration = lib.mkEnableOption "enableNushellIntegration";

    enableZshIntegration = lib.mkEnableOption "enableZshIntegration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    programs = {
      bash.initExtra = lib.mkIf cfg.enableBashIntegration ''
        eval "$(${payRespectsCmd} bash ${cfgOptions})"
      '';

      zsh.initExtra = lib.mkIf cfg.enableZshIntegration ''
        eval "$(${payRespectsCmd} zsh ${cfgOptions})"
      '';

      fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
        ${payRespectsCmd} fish ${cfgOptions} | source
      '';

      nushell.extraConfig = lib.mkIf cfg.enableNushellIntegration ''
        source ${
          pkgs.runCommand "pay-respects-nushell-config.nu" {} ''
            ${payRespectsCmd} nushell ${cfgOptions} >> "$out"
          ''
        }
      '';
    };
  };
}
