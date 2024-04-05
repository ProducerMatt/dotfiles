{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps:
      with ps; [
        elixir
        elixir-ls
      ]);
  };
  services.vscode-server = {
    enable = true;
    enableFHS = true;
    nodejsPackage = pkgs.nodejs_20;
  };
}
