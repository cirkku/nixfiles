{ config, lib, pkgs, modulesPath, ... }:

{
  networking.hostName = "desktop";
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "ata_piix" "ohci_pci" "ehci_pci" "sd_mod" "sr_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.extraHosts = let
    hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts;
    hostsFile = builtins.fetchurl { url=hostsPath; sha256="sha256:03wp9v2hffw5wgd30g4nkzg9xfl288qiv19v239pidkd3p1sl0f6"; };
  in builtins.readFile "${hostsFile}";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b8e56a56-edee-453b-9203-39b955deba4f";
      fsType = "xfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/9766b978-6bc6-4d37-96dc-99b764ca16b3";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3509-7F0C";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/da385cb8-c335-4d98-80a5-e66258f7c8aa"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

}
