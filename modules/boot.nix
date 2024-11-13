{ config, pkgs, ... }:

{
  # Bootloader setup
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Nvidia wayland tweaks & ghost monitor fix
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
  };
}