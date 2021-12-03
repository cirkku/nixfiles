{ config, lib, pkgs, modulesPath, ... }:

{
    networking.hostName = "laptop";

    environment.systemPackages = with pkgs; [
        powertop acpi upower tlp
    ];

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];

    networking.extraHosts = let
      hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts;
      hostsFile = builtins.fetchurl { url=hostsPath; sha256="sha256:03wp9v2hffw5wgd30g4nkzg9xfl288qiv19v239pidkd3p1sl0f6"; };
    in builtins.readFile "${hostsFile}";

    boot.initrd.luks.devices."luksroot".device = "/dev/disk/by-uuid/b2398de5-0bab-4c38-9e4b-f81e4648a185";

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

  swapDevices =
    [ { device = "/dev/disk/by-uuid/4c72d467-6196-4bdf-937f-7f5e567f330d"; }
    ];
   
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    services.tlp.enable = true;
}

