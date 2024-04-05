{
  config,
  lib,
  pkgs,
  ...
}: {
  # Also requires Guix module.
  # See profiles.guix

  environment.systemPackages = with pkgs; [
    # any less than medium isn't guaranteed to work
    texlive.combined.scheme-full

    racket
    imagemagick
    (python310.withPackages (ps:
      with ps; [
        ipython
        pyflakes
        black
        pytest
        nose
        isort
        # Latex source code highlighting
        pygments
      ]))

    ispell
    pandoc
    tectonic
    gnuplot
    graphviz
    shellcheck
    nodePackages.mermaid-cli
  ];
}
