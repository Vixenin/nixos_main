{ config, pkgs, ... }:

{
  # Bootloader setup
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Kernel version
    kernelPackages = pkgs.linuxPackages_6_14;

    # Nvidia wayland tweaks & ghost monitor fix
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nouveau.modeset=0"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_EnableGpuFirmware=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    # Force nvidia proprietary
    blacklistedKernelModules = [
      "nouveau"
    ];
  };
}
