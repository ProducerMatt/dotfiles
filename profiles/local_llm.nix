{pkgs, ...}: {
  services.ollama = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    acceleration = false;
    package = pkgs.ollama.overrideAttrs (final: prev: let
      version = "0.1.49-rc7";
    in {
      inherit version;
      src = pkgs.fetchFromGitHub {
        owner = "ollama";
        repo = "ollama";
        rev = "v${version}";
        hash = "sha256-ZIJsveQK1WM6GCLsjcp0E//wtLN80qJ8MM5TyzGtBSY=";
        fetchSubmodules = true;
      };
    });
  };
}
