{ config, pkgs, ... }:

{
  # Import configuration
  imports =
    [ ./hardware-configuration.nix
      ./modules/boot.nix
      ./modules/environment.nix
      ./modules/network.nix
      ./modules/user.vixenin.nix
      ./modules/nvidia.nix
      ./modules/audio.nix
      ./modules/desktop.environment.nix
      ./modules/packages.nix
      ./modules/programs.nix
      ./modules/vr.nix
    ];

  # System State Version
  system.stateVersion = "24.05";
}
