{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Silly stuff
    nightfox-gtk-theme
    morewaita-icon-theme
    catppuccin-cursors

    gnome-tweaks
    gnomeExtensions.arcmenu
    
    fastfetch

    # Programs
    monado
    gparted
    appimage-run
    git
    perl
    unzip
    pavucontrol
    android-tools
    gnome-software
    vscode
    libreoffice-fresh

    # Noise suppression & alsa mixer
    easyeffects
    alsa-utils

    # Media
    vlc

    # Media tools
    blender
    krita
    aseprite
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
