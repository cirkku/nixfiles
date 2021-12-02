{ config, pkgs, ... }:

let 
    # Import config files
    zshsettings = import ./home/zsh/zsh.nix;
    nvimsettings = import ./home/nvim/nvim.nix;
    firefoxsettings = import ./home/firefox/firefox.nix;
in 
{ 
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
        videos = "$HOME/Media/Videos";
        music = "$HOME/Mount/3TB/Music";
        pictures = "$HOME/Media/Pictures";
    };

    # Poor attempt to keep compatible with Stow on other distros
    # * old idea for sourcing files. for now I'll just use stow for files other than ZSH and firefox
    home.file = {
        ".xinitrc".text = ''
            dbus-launch bspwm & sxhkd &
            if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	            eval $(dbus-launch --exit-with-session --sh-syntax)
            fi
            systemctl --user import-environment DISPLAY XAUTHORITY

            if command -v dbus-update-activation-environment >/dev/null 2>&1; then
                dbus-update-activation-environment DISPLAY XAUTHORITY
            fi
        '';
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
        pinentryFlavor = "qt";
    };

    # Do not touch
    home.stateVersion = "21.03";
}
