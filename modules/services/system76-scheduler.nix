{ config, pkgs, ... }:

{
  # Enable system76 scheduler
  services.system76-scheduler = {
    enable = true;
  };
}