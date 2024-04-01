{pred}:
{ self, pkgs, lib, myLib, flakeInfo, ... }:
{
  config = lib.mkIf pred (
let
  hm =
let
  getSnippet = myLib.getPkgSnippet pkgs;
  start_emacs = "emacsclient -c -a 'emacs'";
  myAliases = {
    l = "eza";
    ll = "eza -la";
    la = "eza -a";
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
    #np = "n profile";
    #ni = "np install";
    #nr = "np remove";
    #ns = "n search --no-update-lock-file";
    #nf = "n flake";
    #nepl = "n repl '<nixpkgs>'";
    #srch = "ns nixos";
    #orch = "ns override";
    mn = ''
      manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
    '';

    ## sudo
    #s = "sudo -E ";
    #si = "sudo -i";
    #se = "sudoedit";

    # nix
    nrb = "sudo nixos-rebuild";

    # fix nixos-option for flake compat
    nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

    ## systemd
    #ctl = "systemctl";
    #stl = "s systemctl";
    #utl = "systemctl --user";
    #ut = "systemctl --user start";
    #un = "systemctl --user stop";
    #up = "s systemctl start";
    #dn = "s systemctl stop";
    #jtl = "journalctl";

    # git
    gs = "git status";
    gcm = "git commit -m";
  };
in
{
#  imports =
#    #[ profiles.vscode ] ++
#    suites.base ++
#    suites.dev; # ++
#  #suites.graphical;
  home.username = "matt";
  home.homeDirectory = "/home/matt";
  home.stateVersion = "23.11";

#  programs.fish = {
#    enable = true;
#    plugins = with pkgs; with lib;
#      map (plugin: (myLib.cleanForFish pkgs.sources."${plugin}"))
#        [
#          "fish-abbreviation-tips"
#          "jethrokuan-z"
#          "nvmfish"
#          "replayfish"
#        ];
#    shellAliases = myAliases;
#  };
  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ./bash_prompt.sh;
    shellAliases = myAliases;
  };

  programs.gpg.enable = true;

  home.sessionVariables = {
    FLAKE = flakeInfo.rootDir;
    REALNAME = "ProducerMatt";
    EMAIL = "ProducerMatt42@gmail.com";
    KEYID = "E6EA80E5CB3E1F9C";
    TERM = "xterm-direct";
    COLORTERM = "truecolor";

    EDITOR = start_emacs;
    VISUAL = start_emacs;
  };
#
#  programs.git = {
#    package = pkgs.gitAndTools.gitFull;
#    userEmail = "58014742+ProducerMatt@users.noreply.github.com";
#    userName = "Producer Matt";
#  };
#
  home.packages = with pkgs; builtins.concatLists [
    (getSnippet "base_cli")
    (getSnippet "dev")
    (getSnippet "sysadmin")
    (getSnippet "git")
    [
      #ripgrep-all # bug
      psmisc
      passphrase2pgp
      #keybase
      #nur.repos.ProducerMatt.cosmo
      cachix
      #rlwrap
      #httrack
      #hugo
      #nodePackages.pnpm
      #metadata-cleaner
      #nur.repos.ProducerMatt.yaml2nix # why aren't you working???
      #nodePackages.node2nix # node packages to nix packages
      #nodePackages.browser-sync # live-reloading dev server
      bc # cli calculators
      imagemagick
      #sd # sed alternative

      # mainly for Emacs
      #clang
      #ccls
      rnix-lsp
      # any less than medium isn't guaranteed to work
      #texlive.combined.scheme-full
      # required by +jupyter
      #(python38.withPackages(ps: with ps; [jupyter]))

      ## Emacs + Python
      #(python310.withPackages (ps: with ps; [
      #  ipython
      #  pyflakes
      #  black
      #  pytest
      #  nose
      #  isort
      #  # Latex source code highlighting
      #  pygments
      #]))
      #micromamba
      #conda
      ispell
      #pandoc
      #tectonic
      #gnuplot
      #graphviz
      #cmake
      shellcheck
      #editorconfig-core-c
      #nodejs
      #nodePackages.mermaid-cli
      #cpplint
    ]
  ];
#  services.emacs = {
#    enable = true;
#    package = pkgs.emacs28NativeComp;
#  };
#  programs.vim.package = pkgs.vim;
#
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
  };
};
in
{
  home-manager.users.matt = hm;

  users.users.matt = {
    isNormalUser = true;
    description = "Matt";
    extraGroups = [ "networkmanager" "wheel" "vboxusers" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfK6c9SiwYYRxy10EMVh1sctDgy6JN/fMyzsO1hACnN ProducerMatt login key"
      ''
        from="192.168.1.4",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0MTVh6Bi82YLKJlpo+4fQRQ3mhZWXFD7VcZEPPWHWA backup@BackupPC
      ''
      #''
      #  from="192.168.1.4",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty,command="rrsync -ro /home/matt" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0MTVh6Bi82YLKJlpo+4fQRQ3mhZWXFD7VcZEPPWHWA backup@BackupPC
      #''
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true; # required for vendor distributions of autocomplete, etc.
});
}
