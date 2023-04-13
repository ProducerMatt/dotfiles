{ pkgs, self, lib, ... }:
let
  start_emacs = "emacsclient -c -a 'emacs'";
  myAliases = {
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

    # git
    gs = "git status";
    gcm = "git commit -m";
  };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;

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
    plugins = with pkgs; with lib;
      map (plugin: (lib.our.cleanForFish pkgs.sources."${plugin}"))
        [
          "fish-abbreviation-tips"
          "fzf"
          "jethrokuan-z"
          "nvmfish"
          "replayfish"
        ];
    shellAliases = myAliases;
  };
  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ./bash_prompt.sh;
    shellAliases = myAliases;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.gpg.enable = true;

  home.sessionVariables = {
    REALNAME = "ProducerMatt";
    EMAIL = "ProducerMatt42@gmail.com";
    KEYID = "E6EA80E5CB3E1F9C";
    TERM = "xterm-direct";
    COLORTERM = "truecolor";

    EDITOR = start_emacs;
    VISUAL = start_emacs;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = "58014742+ProducerMatt@users.noreply.github.com";
    userName = "Producer Matt";
    extraConfig = {
      init = { defaultBranch = "main"; };
      pull = { rebase = false; }; # setting to true was a mistake
    };
  };

  home.packages = with pkgs; builtins.concatLists [
    [
      vimHugeX
      htop # top alternative
      bottom # top alternative
      emacs28NativeComp
      #firefox
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
      nur.repos.ProducerMatt.cosmo
      direnv
      nix-direnv
      git-ignore
      cachix
      nixpkgs-review
      rlwrap
      httrack
      libressl
      hugo
      manix # cli package & docs search
      nur.repos.ProducerMatt.ripsecrets
      nodePackages.pnpm
      ttfautohint
      bind.dnsutils
      metadata-cleaner
      stdenv
      gnumake
      #nur.repos.ProducerMatt.yaml2nix # why aren't you working???
      lsof # list files and sockets in use
      nodePackages.node2nix # node packages to nix packages
      nodePackages.browser-sync # live-reloading dev server
      bc # cli calculators
      imagemagickBig
      remarshal # convert between config file formats
      nix-init
      sd # sed alternative

      # mainly for Emacs
      clang
      ccls
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
      micromamba
    ]
    (import ../../profiles/font-list.nix pkgs)
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
    defaultEditor = true;
  };
  programs.vim.package = pkgs.vimHugeX;

  fonts = {
    fontconfig.enable = true;
  };

  home.file = {
    ".guile".text = ''
      ;; managed by flake
      (use-modules
        (ice-9 readline)
        (ice-9 format)
        (ice-9 pretty-print))
      (activate-readline)
    '';
    ".gdbinit".text = ''
      # managed by flake
      set debug-file-directory ~/.nix-profile/lib/debug
    '';
    #"xterm-24bit.terminfo" = {
    #  text = ''
    #    xterm-emacs|xterm with 24-bit direct color mode for Emacs,
    #    use=xterm-256color,
    #    setb24=\E[48\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&\
    #      %d\:%p1%{255}%&%dm,
    #    setf24=\E[38\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&\
    #      %d\:%p1%{255}%&%dm,
    #  '';
    #  onChange = ''
    #    tic -x -o ~/.terminfo xterm-24bit.terminfo
    #  '';
    #};
  };
}
