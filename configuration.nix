{ config, pkgs, ... }:

{
  # Import configuration
  imports =
    [ 
      # Auto hardware config
      ./hardware-configuration.nix

      # Applications
      ./modules/applications/chromium.nix
      ./modules/applications/mangohud.nix # Fps counter
      ./modules/applications/steam.nix # Includes gamemode & gamescope
      ./modules/applications/wivrn.nix # Vr service

      # Hardware
      ./modules/hardware/audio.nix
      ./modules/hardware/nvidia.nix
      ./modules/hardware/other.nix # Manager other devices
      ./modules/hardware/storage.nix
      ./modules/hardware/xone.nix # Xbox controller

      # Nixpkgs
      ./modules/nixpkgs/overlay.nix

      # Services
      ./modules/services/flatpak.nix
      ./modules/services/network.nix
      ./modules/services/printer.nix
      ./modules/services/system76-scheduler.nix
      ./modules/services/tailscale.nix

      # Users
      ./modules/users/vixenin.nix

      # Extra
      ./modules/boot.nix
      ./modules/desktop.environment.nix
      ./modules/environment.nix
      ./modules/packages.nix
    ];

  # System State Version
  system.stateVersion = "24.11";
}
