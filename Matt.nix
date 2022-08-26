{ config, lib, pkgs, ... }:

{
  home.username = "matt";
  home.homeDirectory = "/home/matt";
  home.stateVersion = "22.05";

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
  programs.nix-index = {
    enableFishIntegration = true;
  };

  programs.gpg.enable = true;

  home.sessionVariables = {
    REALNAME = "ProducerMatt";
    EMAIL = "ProducerMatt42@gmail.com";
    KEYID = "E6EA80E5CB3E1F9C";

    EDITOR = "emacsclient";
    VISUAL = "emacsclient";
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
    config.nur.repos.ProducerMatt.pledge
    direnv
    nix-direnv
    git-ignore
    cachix
    rlwrap
    httrack
    libressl
    hugo
    manix # cli package & docs search
    config.nur.repos.ProducerMatt.ripsecrets

    # mainly for Emacs
    clang
    guile_3_0
    guile-cairo
    rnix-lsp
    # any less than medium isn't guaranteed to work
    texlive.combined.scheme-full
    # required by +jupyter
    #(python38.withPackages(ps: with ps; [jupyter]))
    python-language-server
    (python310.withPackages(ps: with ps; [ ipython pyflakes black pytest nose isort ]))
    conda
    ispell
    pandoc
    tectonic
    gnuplot
    graphviz
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

  #home.file = {
  #".oh-my-tmux".source = pkgs.fetchFromGitHub {
  #  owner = "gpakosz";
  #  repo = ".tmux";
  #  rev = "e865a8a";
  #  sha256 = "IuEiaZozSFmGTRYbpUSyXFynqcP6qwcCBk9XmupN2nA=";
  #  stripRoot = true;
  #};
  #".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "~/.oh-my-tmux/.tmux.conf";

  #".tmux.conf.local".source = ./config/tmux.conf.local;
  #".doom.d" = {
  #  source = ./config/doom.d;
  #  recursive = true;
  #  onChange = "scripts/doomsync.sh";
  #};

  #"dotfiles".source = pkgs.fetchFromGitHub {
  #  owner = "ProducerMatt";
  #  repo = "dotfiles";
  #  rev = "79c9043";
  #  sha256 = "xxEjmughDJ87p+6nCl5t9ynUlzidmhqPl7IiH+XWe+k=";
  #};
  #};
}
