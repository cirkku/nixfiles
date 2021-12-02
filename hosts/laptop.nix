{ config, lib, pkgs, modulesPath, ... }:

{
    networking.hostName = "laptop";

    environment.systemPackages = with pkgs; [
        powertop acpi upower tlp
    ];

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc" ];

    networking.extraHosts = let
      hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts;
      hostsFile = builtins.fetchurl { url=hostsPath; sha256="sha256:03wp9v2hffw5wgd30g4nkzg9xfl288qiv19v239pidkd3p1sl0f6"; };
    in builtins.readFile "${hostsFile}";

    #update when new laptop arrives
    fileSystems."/" = { 
        device = "";
        fsType = "";
    };

    fileSystems."/boot" = {
        device = "";
        fsType = "vfat";
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/ccec80c0-6886-4534-899c-04a3a00e88b5"; } ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    services.tlp.enable = true;
}
