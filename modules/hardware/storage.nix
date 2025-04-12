{ config, pkgs, ... }:

{
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
}