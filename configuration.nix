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
      ./modules/nixpkgs/overlays.nix
      ./modules/programs.nix
      ./modules/vr.nix
    ];

  # Setup the storage
  fileSystems."/mnt/Mango" = {
    label = "Mango";
    device = "/dev/disk/by-uuid/5aace8e8-d6f4-489f-8e29-ee07e5c51b91";
    fsType = "ext4";
    options = [ "nofail" "rw" "noatime" ];
  };

  fileSystems."/mnt/Backup" = {
    label = "Backup";
    device = "/dev/disk/by-uuid/c515297a-7147-4c84-92fe-24939a787555";
    fsType = "ext4";
    options = [ "nofail" "rw" "noatime" ];
  };

  # System State Version
  system.stateVersion = "24.11";
}
