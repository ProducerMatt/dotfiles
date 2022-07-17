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
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nix-index = {
    enableFishIntegration = true;
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
    htop
    emacs28NativeComp
    #git
    firefox
    kitty
    fish
    exa
    fd
    ripgrep
    ripgrep-all
    croc
    p7zip
    tmux
    bat
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp;
    defaultEditor = true;
  };
  home.shellAliases = {
    l = "exa";
    ll = "exa -la";
    la = "exa -a";
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
