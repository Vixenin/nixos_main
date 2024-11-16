{ config, pkgs, ... }:

{
  # Network configuration
  networking = {
    hostName = "chillet";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 57621 9757 ];
      allowedUDPPorts = [ 5353 9757 ];
      enable = true;
    };
  };

  # Avahi for vr | wivrn
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  # Printing and audio
  services.printing.enable = true;
}
