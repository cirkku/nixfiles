{ config, pkgs, ... }:
{   
    services = {
        openssh = {
            enable = true;
            permitRootLogin = "no";
            passwordAuthentication = true;
            ports = [ 69 ];
        };
        #bittorrent client daemon
        transmission = {
            enable = true;
            user = "tuukka";
            settings = {
                download-dir = "/home/tuukka/Download/torrents/";
                incomplete-dir = "/home/tuukka/Download/torrents/.incomplete/";
                incomplete-dir-enabled = true;
                peer-port-random-on-start = false;
                port = 1337;
            };
        };
        picom = {
            enable = true;
            shadow = false;
        };
        #music player daemon
        mpd = {
            enable = true;
            startWhenNeeded = true;
            user = "tuukka";
            musicDirectory = "/home/tuukka/Music";
            dataDir = "/home/tuukka/Music/mpd/";
            extraConfig = ''
                audio_output {
                  type "pulse"
                  name "pulseaudio tcp on 127.0.0.1"
                  server "127.0.0.1"
                }
                audio_output {
                  type "fifo"
                  name "my_fifo"
                  path "/tmp/mpd.fifo"
                  format "44100:16:2"
                }
            '';
        };
    
        #services that only need to be enabled
    };



    #low latency configuration attempt for pulse, actually seemingly just ends up not working 9/10 times
    hardware.pulseaudio = {
        #keep tcp enabled its a hackjob to get music player daemon to work
        tcp.enable = true;
        tcp.anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
    
        # daemon.conf
        daemon.config = {
            high-priority = "yes";
            nice-level = -15;
            realtime-scheduling = "yes";
            realtime-priority = 50;
            resample-method = "speex-float-0";
            default-fragments = 2;
            default-fragment-size-msec = 4;
        };
        # default.pa
        configFile = pkgs.runCommand "default.pa" {} ''
            sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
            ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
        '';
      };
      # realtime processing for group `audio'
      security.pam.loginLimits = [
        { domain = "@audio"; item = "nice"; type = "-"; value = "-20"; }
        { domain = "@audio"; item = "rtpio"; type = "-"; value = "99"; }
      ];

}
