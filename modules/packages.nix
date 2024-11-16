{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Silly stuff
    fastfetch
    gnome.gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.arcmenu

    # Programs
    gparted
    appimage-run
    git
    perl
    unzip
    pavucontrol
    gnome.gnome-software
    vscode
    libreoffice-fresh

    # Noise suppression & alsa mixer
    easyeffects
    alsa-utils

    # Media
    vlc
    vesktop

    # Media tools
    aseprite
    blender
    kdenlive
    audacity
    obs-studio

    # Games
    wineWowPackages.stable
    mangohud
    bottles
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
