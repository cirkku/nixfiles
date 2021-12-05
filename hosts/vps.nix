{ config, lib, pkgs, modulesPath, ... }:

{
	networking.firewall.enable = false;
	nixpkgs.config.allowUnfree = true;
	services.openssh.enable = true;
    networking.hostName = "gensokyo";
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    
  boot = {
    initrd = {
	availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    };
  };
   fileSystems."/" =
    { device = "/dev/disk/by-uuid/57c57de3-f4b4-4b22-b606-f64347a1ef7e";
      fsType = "xfs";
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/33c5bfe1-0dce-473e-8476-1ac5ef290510";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A79B-417B";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/89d9e05c-d4d5-4591-80a5-c19b38ddb6b0"; }
    ];

  
  #services.nfs.server = {
  #  enable = true;
  #  exports = ''
  #    /export/Sakuya  192.168.1.1/24(rw,fsid=0,no_subtree_check)
  #  '';
  #};
  services.minecraft-server = {
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

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
