{ config, pkgs, ... }:

{
  # Network Configuration
  networking = {
    hostName = "chillet";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 57621 9757 ];
      allowedUDPPorts = [ 5353 9757 ];
      enable = true;
    };
  };

  # Avahi for VR | WiVRn
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  # Printing and Audio
  services.printing.enable = true;
}