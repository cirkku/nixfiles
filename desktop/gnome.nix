{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    gnomeExtensions.blur-my-shell
    gnomeExtensions.hide-activities-button
    gnomeExtensions.vitals
    gnomeExtensions.no-overview
    gnomeExtensions.application-volume-mixer
    numix-gtk-theme
    numix-icon-theme
    numix-cursor-theme
    arc-theme
    rhythmbox
  ];
  environment.gnome.excludePackages = [ 
    pkgs.gnome.geary
    pkgs.gnome.cheese
    pkgs.gnome.gnome-maps
    pkgs.gnome-photos
    pkgs.gnome.gnome-music
    pkgs.gnome.gedit
    pkgs.epiphany
    pkgs.evince
    pkgs.gnome.gnome-characters
    pkgs.gnome.totem
    pkgs.gnome.tali
    pkgs.gnome.iagno
    pkgs.gnome.hitori
    pkgs.gnome.atomix
    pkgs.gnome-tour
  ];
    services.xserver = {
        enable = true;
        layout = "fi,rs,ru";
        xkbOptions = "eurosign:e,grp:alt_space_toggle,caps:ctrl_modifier";
        desktopManager = {
            gnome.enable = true;
        };
        displayManager = {
            gdm.enable = true;
       }; 
               #cool kids don't need mouse acceleration
        libinput = {
            enable = true;
            touchpad = {
                accelProfile = "flat";
                accelSpeed = "0";
            };
        };
    };
}
