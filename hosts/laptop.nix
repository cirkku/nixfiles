{ config, lib, pkgs, modulesPath, ... }:
{
  networking = { 
    hostName = "laptop";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    powertop acpi upower tlp
  ];

  hardware = {
    video.hidpi.enable = lib.mkDefault true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ intel-media-driver ];
    };
  };

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = { 
    initrd = { 
      luks.devices."luksroot".device = "/dev/disk/by-uuid/b2398de5-0bab-4c38-9e4b-f81e4648a185";
      kernelModules = [ "coretemp" "dm-snapshot" ];
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };  
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/20cd69ad-86d0-4e60-9225-44da19faa2a3";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/8fa4f7ec-b5f3-4fc6-a55a-a0c1bd1b9de6";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/671C-584B";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/24926477-e596-4a21-b3b1-89c6cb30c111"; }
    ];
      
  fileSystems."/mnt/koishi" =
    { device = "192.168.1.186:/koishi";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };
  fileSystems."/mnt/sakuya" =
    { device = "192.168.1.186:/sakuya";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };
  #use laptop for virtual machines
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  powerManagement.powertop.enable = true;
  #services.tlp.enable = true; ### doesn't work with gnome
}



