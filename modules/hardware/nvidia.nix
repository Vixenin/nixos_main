{ config, pkgs, lib, ... }:

let
  # Base nvidia driver metadata
  mkDriverArgs = {
    version = "570.133.07";
    sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
    sha256_aarch64 = "sha256-yTovUno/1TkakemRlNpNB91U+V04ACTMwPEhDok7jI0=";
    openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
    settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
    persistencedSha256 = "sha256-G1V7JtHQbfnSRfVjz/LE2fYTlh9okpCbE4dfX9oYSg8=";
  };
in
{
  boot = {
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

  environment.variables = {
    # Nvidia wayland tweaks
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Nvidia 10GB shader cache
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "$HOME/.nv_shader_cache";
    __GL_SHADER_DISK_CACHE_SIZE = "10737418240";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";

    # Drm kernel driver 'nvidia-drm' fix
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      # Power management, safe for wayland
      enable = true;
      finegrained = false;
    };

    # For open drivers
    open = false;

    nvidiaSettings = true;

    # Nvidia custom driver version
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver mkDriverArgs;
  };

  # Accept Nvidia license
  nixpkgs.config.nvidia.acceptLicense = true;
}
