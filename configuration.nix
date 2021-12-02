{ config, pkgs, ... }:

{
    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG="$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR="$HOME/.config/nixos/";
    };

    # Nix settings, auto cleanup and enable flakes
    nix = {
        autoOptimiseStore = true;
        allowedUsers = [ "tuukka" ];
        gc = {
            automatic = true;
            dates = "daily";
        };
        package = pkgs.nixUnstable;
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    nixpkgs.config.allowBroken = true;

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        cleanTmpDir = true;
        loader = {
            systemd-boot.enable = true;
            systemd-boot.editor = false;
            efi.canTouchEfiVariables = true;
        }; 
    };

    # Set up keyboard and language
    time.timeZone = "Europe/Helsinki";
    i18n.defaultLocale = "en_GB.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "fi";
    };

    # Set up user and enable sudo
    users.users.tuukka = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; 
        shell = pkgs.zsh;
    };

    security.protectKernelImage = true;
    powerManagement.powertop.enable = true;

    # Do not touch
    system.stateVersion = "21.11";
    
}
