{ config, lib, pkgs, ... }:

{
  # Graphics and nvidia driver
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
        monado-vulkan-layers
        vulkan-validation-layers
      ];
  };

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement = {
      # Powermanagement, safe for wayland
      enable = true;

      finegrained = false;
    };

    # For open drivers
    open = false;

    nvidiaSettings = true;

    # Nvidia custom driver version
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "565.57.01";
      sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
      sha256_aarch64 = "sha256-aDVc3sNTG4O3y+vKW87mw+i9AqXCY29GVqEIUlsvYfE=";
      openSha256 = "sha256-/tM3n9huz1MTE6KKtTCBglBMBGGL/GOHi5ZSUag4zXA=";
      settingsSha256 = "sha256-H7uEe34LdmUFcMcS6bz7sbpYhg9zPCb/5AmZZFTx1QA=";
      persistencedSha256 = "sha256-hdszsACWNqkCh8G4VBNitDT85gk9gJe1BlQ8LdrYIkg=";
      patchesOpen = [
        ./nvidia.patch
      ];
    };
  };

  # Accept nvidia license
  nixpkgs.config.nvidia.acceptLicense = true;
}
