{ config, pkgs, ... }:

{
  # Bootloader setup
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    #kernelPackages = pkgs.linuxPackages_latest;

    # Fuck you ngreedia with your shit drivers :3
    kernelPackages = pkgs.linuxPackages_6_11;

    # Nvidia wayland tweaks & ghost monitor fix
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nouveau.modeset=0"
      "nvidia-drm.fbdev=1"
      "ipv6.disable=1"
    ];

    # Force nvidia proprietary
    blacklistedKernelModules = [
      "nouveau"
    ];
  };
}
