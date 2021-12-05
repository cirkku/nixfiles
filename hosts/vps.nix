{ config, lib, pkgs, modulesPath, ... }:

{
    networking.hostName = "server";
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    
  boot = {
    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "sd_mod" "sr_mod" ];
    };
    #kernelModules = [ "" ];
  };

  fileSystems."/" = {
    device = "";
    fsType = "xfs";
  };
  
  filesystems."/mnt/Sakuya" = {
    device = "";
    fsType = "";
  };

  fileSystems."/export/Sakuya" = {
    device = "/mnt/Sakuya";
    options = [ "bind" ];
  };

  fileSystems."/boot" =
    { device = "";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = ""; }];
   
  services.nfs.server = {
    enable = true;
    exports = ''
      /export/Sakuya  192.168.1.1/24(rw,fsid=0,no_subtree_check)
    '';
  };
  services.minecraft-server = {
    enable = true;
    eula = true; #required
    serverProperties = {
      server-ip = "192.168.1.186";
      motd = "panin sun mutsiis";
      allow-nether = true;
      enable-rcon = false;
      op-permission-level = 2;
      view-distance = 17;
      online-mode = false;
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
