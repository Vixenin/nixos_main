{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Silly Stuff
    fastfetch
    gnome.gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.arcmenu

    # Programs
    gparted
    vulkan-tools
    appimage-run
    git
    perl
    unzip
    pavucontrol
    gnome.gnome-software
    vscode
    libreoffice-fresh

    # Noise suppression & Alsa Mixer
    easyeffects
    alsa-utils

    # Media
    vlc
    discord

    # Media Tools
    krita
    aseprite
    blender
    kdenlive
    audacity
    obs-studio

    # Games
    wineWowPackages.stable
    bottles
    gamescope
    mangohud
    godot_4
  ];

  # Remove gnome trash
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    gnome-terminal
    epiphany
    geary
    evince
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);
}
