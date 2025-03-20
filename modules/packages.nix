{ config, pkgs, ... }:

let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  }) {
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with pkgs; [
    # Silly stuff
    nightfox-gtk-theme
    morewaita-icon-theme
    
    gnome-tweaks
    gnomeExtensions.arcmenu
    
    fastfetch

    # Programs
    gparted
    appimage-run
    git
    perl
    unzip
    wget
    pavucontrol
    chromium
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
    aseprite
    kdenlive
    audacity
    obs-studio

    # Games
    wineWowPackages.stable
    mangohud
    bottles
    
    prismlauncher

    vPack.r2modman
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
