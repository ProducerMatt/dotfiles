pkgs:

with pkgs; [
  cantarell-fonts
  emacs-all-the-icons-fonts
  font-awesome
  hasklig
  iosevka
  source-code-pro
  texlive.combined.scheme-full
  nerdfonts
  atkinson-hyperlegible
  #(iosevka.override {
  #  privateBuildPlan = ''
  #    [buildPlans.iosevka-matt]
  #    family = "Iosevka Matt"
  #    spacing = "normal"
  #    serifs = "sans"
  #    no-cv-ss = false
  #    export-glyph-names = false

  #      [buildPlans.iosevka-matt.variants]
  #      inherits = "ss08"

  #      [buildPlans.iosevka-matt.ligations]
  #      inherits = "dlig"

  #    [buildPlans.iosevka-matt.widths.normal]
  #    shape = 600
  #    menu = 5
  #    css = "normal"
  #  '';
  #  set = "matt";
  #})
]
