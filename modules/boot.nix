{ config, pkgs, ... }:

{
  # Bootloader setup
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    # Nvidia wayland tweaks & ghost monitor fix
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "ipv6.disable=1"
    ];
  };
}
