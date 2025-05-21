{ config, pkgs, ... }:

{
  # Libratbag daemon
  services.ratbagd.enable = true;

  # Piper
  environment.systemPackages = with pkgs; [
    piper
  ];
}
