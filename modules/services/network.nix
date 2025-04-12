{ config, pkgs, ... }:

{
  # Network configuration
  networking = {
    hostName = "chillet";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 57621 25565 9757 ];
      allowedUDPPorts = [ 9757 25565 5353 53 67 68 ];
      enable = true;
    };
    enableIPv6 = false;
    wireless.iwd.enable = true;
  };
}
