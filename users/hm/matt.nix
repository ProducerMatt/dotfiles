{ pkgs, self, ... }:
let
  start_emacs = "emacsclient -c -a 'emacs'";
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "matt";
  home.homeDirectory = "/home/matt";
  home.stateVersion = "22.05";

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      direnv hook fish | source
    '';
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.gpg.enable = true;

  home.sessionVariables = {
    REALNAME = "ProducerMatt";
    EMAIL = "ProducerMatt42@gmail.com";
    KEYID = "E6EA80E5CB3E1F9C";

    EDITOR = start_emacs;
    VISUAL = start_emacs;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = "58014742+ProducerMatt@users.noreply.github.com";
    userName = "Producer Matt";
    extraConfig = {
      init = { defaultBranch = "main"; };
      pull = { rebase = true; };
    };
  };

  home.packages = with pkgs; [
    vimHugeX
    htop
    emacs28NativeComp
    firefox
    kitty
    fish
    exa
    fd
    ripgrep
    ripgrep-all
    croc
    p7zip
    psmisc
    tmux
    bat
    git-crypt
    passphrase2pgp
    tig
    keybase
    tere
    nur.repos.ProducerMatt.pledge
    direnv
    nix-direnv
    git-ignore
    cachix
    rlwrap
    httrack
    libressl
    hugo
    manix # cli package & docs search
    nur.repos.ProducerMatt.ripsecrets

    # mainly for Emacs
    clang
    guile_3_0
    guile-cairo
    rnix-lsp
    # any less than medium isn't guaranteed to work
    texlive.combined.scheme-full
    # required by +jupyter
    #(python38.withPackages(ps: with ps; [jupyter]))

    # Emacs + Python
    (python310.withPackages (ps: with ps; [
      ipython
      pyflakes
      black
      pytest
      nose
      isort
      # Latex source code highlighting
      pygments
    ]))

    conda
    ispell
    pandoc
    tectonic
    gnuplot
    graphviz
    cmake
    shellcheck
    editorconfig-core-c
    nodejs
    nixfmt
    nodePackages.mermaid-cli
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
    defaultEditor = true;
  };
  programs.vim.package = pkgs.vimHugeX;
  home.shellAliases = {
    l = "exa";
    ll = "exa -la";
    la = "exa -a";
    e = start_emacs;
    er = "systemctl --user restart emacs.service";

    # quick cd
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # git
    g = "git";

    # grep
    grep = "rg";
    gi = "grep -i";

    # internet ip
    # TODO: explain this hard-coded IP address
    myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

    # nix
    n = "nix";
    np = "n profile";
    ni = "np install";
    nr = "np remove";
    ns = "n search --no-update-lock-file";
    nf = "n flake";
    nepl = "n repl '<nixpkgs>'";
    srch = "ns nixos";
    orch = "ns override";
    mn = ''
      manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
    '';
    top = "btm";

    # sudo
    s = "sudo -E ";
    si = "sudo -i";
    se = "sudoedit";

    # nix
    nrb = "sudo nixos-rebuild";

    # fix nixos-option for flake compat
    nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

    # systemd
    ctl = "systemctl";
    stl = "s systemctl";
    utl = "systemctl --user";
    ut = "systemctl --user start";
    un = "systemctl --user stop";
    up = "s systemctl start";
    dn = "s systemctl stop";
    jtl = "journalctl";
  };

  fonts = {
    fontconfig.enable = true;
  };

  home.file = {
    ".guile".text = ''
      (use-modules
        (ice-9 readline)
        (ice-9 format)
        (ice-9 pretty-print))
      (activate-readline)
    '';
  };
}
