{ config, pkgs, ... }:

{
  # Network configuration
  networking = {
    hostName = "chillet";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 57621 9757 ];
      allowedUDPPorts = [ 5353 9757 53 67 68 ];
      enable = true;
    };
    enableIPv6 = false;
    wireless.iwd.enable = true;
  };

  # Printing and audio
  services.printing.enable = true;
}
