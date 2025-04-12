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
  };
}
