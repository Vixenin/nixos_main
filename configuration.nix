{ config, pkgs, ... }:

{
  # Import hardware configuration
  imports =
    [ ./hardware-configuration.nix
      ./modules/boot.nix
      ./modules/network.nix
      ./modules/desktop.environment.nix
      ./modules/audio.nix
      ./modules/user.vixenin.nix
      ./modules/packages.nix
      ./modules/programs.nix
      ./modules/environment.nix
      ./modules/nvidia.nix
    ];

  # System State Version
  system.stateVersion = "24.05";
}