{ config, pkgs, lib, ... }:

let
  # Driver metadata
  mkDriverArgs = {
    version = "575.51.02";
    sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
    sha256_aarch64 = "sha256-NNeQU9sPfH1sq3d5RUq1MWT6+7mTo1SpVfzabYSVMVI=";
    openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
    settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
    persistencedSha256 = "sha256-dgmco+clEIY8bedxHC4wp+fH5JavTzyI1BI8BxoeJJI=";
  };
in
{
  boot = {
    # Wayland tweaks & ghost monitor fix
    kernelParams = [
      # Core functionality
      "pci=realloc=on"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_EnableGpuFirmware=1"

      # Shader cache
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"

      # Performance & rebar
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia.NVreg_EnableResizableBAR=1"
    ];

    # Force proprietary drivers
    blacklistedKernelModules = [
      "nouveau"
      "nvidiafb"
    ];
  };

  environment.variables = {
    # Wayland tweaks
    GBM_BACKEND = "nvidia-drm";
    NVD_BACKEND = "drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # 10GB shader cache
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "$HOME/.nv_shader_cache";
    __GL_SHADER_DISK_CACHE_SIZE = "10737418240";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";

    # libGLX.so.0 fix for vr
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";

    # Va-api and vdpau support
    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";
  };

  # Use X driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Vulkan
      vulkan-loader
      vulkan-headers
      vulkan-validation-layers
      vulkan-volk

      # Opengl
      libglvnd
      mesa

      # Vaapi
      libva
      nvidia-vaapi-driver
      libva-vdpau-driver

      # Vdpau
      vaapiVdpau
      libvdpau

      # Opencl
      ocl-icd

      # Gstreamer
      gst_all_1.gst-vaapi
    ];
  };

  # Nvidia in containers
  hardware.nvidia-container-toolkit = {
    enable = true;
    package = pkgs.nvidia-container-toolkit;
  };

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement = {
      # Power management, safe for wayland
      enable = true;
      finegrained = false;
    };

    # Open drivers
    open = false;

    nvidiaSettings = true;

    # Custom driver
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver mkDriverArgs;
  };

  # Cuda support
  environment.systemPackages = with pkgs; [
    # Diagnostic tools
    vdpauinfo
    pciutils

    # Codecs
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base

    # Cuda
    cudatoolkit
  ];

  # Accept license
  nixpkgs.config.nvidia.acceptLicense = true;
}
