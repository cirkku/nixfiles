{ config, lib, pkgs, modulesPath, ... }:
{
  networking.firewall.enable = false;
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "gensokyo";
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];  

  boot = {
    initrd = {
	  availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    };
  };

  fileSystems."/mnt/sakuya" = {
    device = "/dev/disk/by-uuid/846af420-7d78-471e-8997-bf65f5636eda";
    fsType = "ext4";
  };

  fileSystems."/mnt/koishi" = {
    device = "/dev/disk/by-uuid/c8012ca0-5145-4fe5-8da7-c06885c15811";
    fsType = "xfs";
  };

  fileSystems."/export/koishi" = {
    device = "/mnt/koishi";
    options = [ "bind" ];
  };

  fileSystems."/export/sakuya" = {
    device = "/mnt/sakuya";
    options = [ "bind" ];
  };
  
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/57c57de3-f4b4-4b22-b606-f64347a1ef7e";
    fsType = "xfs";
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/33c5bfe1-0dce-473e-8476-1ac5ef290510";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A79B-417B";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/89d9e05c-d4d5-4591-80a5-c19b38ddb6b0";
  }];

  # enable services here 
  services = { 
    openssh.enable = true;
    nfs.server = {
      enable = true;
      exports = ''
        /export         192.168.1.1/24(rw,fsid=0,no_subtree_check)
        /export/sakuya  192.168.1.1/24(rw,nohide,insecure,no_subtree_check) 
        /export/koishi  192.168.1.1/24(rw,nohide,insecure,no_subtree_check) 
      '';
    };
    minecraft-server = {
      enable = true;
      eula = true; #required
      declarative = true;
      dataDir = "/var/lib/mincecraft";
      serverProperties = {
	    server-ip = "192.168.1.186";
        motd = "panin sun mutsiis";
        allow-nether = true;
        enable-rcon = true;
        rconPort = 2556;
        op-permission-level = 2;
        view-distance = 17;
        online-mode = true;
        max-players = 20;
        leven-name = "porvaristo";
        simulation-distance = 10;
        spawn-monsters = true;
        gamemode = "survival";
        difficulty = "hard";
        server-port = 2556;
        pvp = true;
      };
      package = pkgs.minecraft-server;
    };
    transmission = {
      enable = true;
      user = "cirno";
      settings = {
        peer-port = 1337;
        download-dir = "/mnt/sakuya/torrents/";
        incomplete-dir = "/mnt/sakuya/torrents/.incomplete/";
        incomplete-dir-enabled = true;
      };
    };
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
