{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    gnomeExtensions.appindicator
    gnomeExtensions.arcmenu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-panel
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.openweather
    gnomeExtensions.impatience
    gnomeExtensions.tiling-assistant
    gnomeExtensions.hide-activities-button
    gnomeExtensions.paperwm
    gnomeExtensions.vitals
    gnomeExtensions.netspeed
    gnomeExtensions.gamemode
    gnomeExtensions.no-overview
    numix-gtk-theme
    numix-icon-theme
    numix-cursor-theme
    arc-theme
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
