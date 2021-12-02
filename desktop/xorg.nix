{ config, lib, pkgs, ... }:
{
    programs.xss-lock = {
        enable = true;
        lockerCommand = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    };

    services.xserver = {
        enable = true;
        layout = "fi,rs,ru";
        xkbOptions = "eurosign:e,grp:alt_space_toggle,caps:ctrl_modifier";
        desktopManager = {
            xterm.enable = false;
            #sometimes I like enabling xfce, so it remains here, if you don't plant to ever use it then just remove the line entirely
            xfce.enable = false;
        };
        #bspwm window manager
        # ^ useless comment
        windowManager.bspwm.enable = true;
        displayManager = {
            startx.enable = true;
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