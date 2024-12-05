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
      version = "565.77";
      sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
      openSha256 = lib.fakeSha256;
      settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
      persistencedSha256 = "sha256-bFtFhYHzRn6GqwWNWKYLxuRcRFhLTRbJviBNEt8Xss=";
    };
  };

  # Accept nvidia license
  nixpkgs.config.nvidia.acceptLicense = true;
}
