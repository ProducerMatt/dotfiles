{ pkgs, ... }:
{
    fonts = {
        enableDefaultFonts = true;
        fonts = with pkgs; [
            cantarell-fonts
            emacs-all-the-icons-fonts
            font-awesome
            hasklig
            iosevka
            source-code-pro
            texlive.combined.scheme-full
            nerdfonts
        ];
        fontDir.enable = true;
        fontconfig = {
            enable = true;
        };
    };
}
