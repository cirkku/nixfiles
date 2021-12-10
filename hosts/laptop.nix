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
    { device = "/dev/disk/by-uuid/01787aeb-718a-4622-a4ac-4ac7468334cf";
      fsType = "xfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/31751266-be3c-46bf-886f-e2df5268213c";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9C32-DD66";
      fsType = "vfat";
    };
  
  fileSystems."/mnt/virtualbox" =
    { device = "/dev/disk/by-uuid/180bcd1c-1bb9-479e-92fa-1994e56a6bdf";
      fsType = "xfs";
    };
      
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
  swapDevices =
    [ { device = "/dev/disk/by-uuid/4c72d467-6196-4bdf-937f-7f5e567f330d"; }
    ];
  #use laptop for virtual machines
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  powerManagement.powertop.enable = true;
  #services.tlp.enable = true; ### doesn't work with gnome
}


