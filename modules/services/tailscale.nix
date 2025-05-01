{ config, pkgs, ... }:

{
  # Setup tailscale
  services = {
    tailscale.enable = true;
  };
}
