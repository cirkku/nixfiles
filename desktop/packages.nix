{ pkgs, config, ... }:

{
    nixpkgs.config.allowUnfree = true;
    # Install all the packages
    environment.systemPackages = with pkgs; [
        zsh 
        fzf
        ripgrep 
        newsboat
        ffmpeg
        exa
        tmux
        libnotify
        sct
        update-nix-fetchgit
        mpc_cli 
       
        # GUI applications
        firefox
        mpv 

        # Development
        git
        gcc
        gnumake
        python3 

        # Language servers for vim
        rnix-lsp
        sumneko-lua-language-server
    ];
    # Install fonts
    fonts.fonts = with pkgs; [
        jetbrains-mono 
        roboto
        uw-ttyp0
        terminus_font_ttf
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
}
