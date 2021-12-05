{ config, pkgs, ... }:

let 
    # Import config files
    zshsettings = import ./home/zsh/zsh.nix;
    nvimsettings = import ./home/nvim/nvim.nix;
    firefoxsettings = import ./home/firefox/firefox.nix;
in
{
  #user only packages
  home.packages = with pkgs; [
    discord
    neofetch
    multimc
    ranger
    sshfs
  ];
    # Enable home-manager
    programs.home-manager.enable = true;

    # Source extra files that are too big for this one 
    programs.zsh = zshsettings pkgs;
    programs.neovim = nvimsettings pkgs;
    programs.firefox = firefoxsettings pkgs;

    # Settings for XDG user directory, to declutter home directory
    xdg.userDirs = {
        enable = true;
        documents = "$HOME/Documents/";
        download = "$HOME/Downloads";
        videos = "$HOME/Videos";
        music = "$HOME/Music";
        pictures = "$HOME/Pictures";
    };

    # Settings for git
    programs.git = {
        enable = true;
        userName = "cirkku";
        userEmail = "tuukka.t.korhonen@protonmail.com";
        extraConfig = {
            init = { defaultBranch = "master"; };
        };
    };

    # Settings for gpg
    programs.gpg = {
        enable = true;
    };

    # Fix pass
    services.gpg-agent = {
        enable = true;
        pinentryFlavor = "gnome3";
    };

    # Do not touch
    home.stateVersion = "21.03";
}

