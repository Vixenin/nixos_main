{ config, pkgs, ... }:

{
  services.udev.extraRules = ''
    # Disable joystick detection for Huion Kamvas 16
    SUBSYSTEM=="input", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="006d", ENV{ID_INPUT_JOYSTICK}="0"

    # Disable joystick detection for ASRock LED Controller
    SUBSYSTEM=="input", ATTRS{idVendor}=="26ce", ATTRS{idProduct}=="01a2", ENV{ID_INPUT_JOYSTICK}="0"
  '';
}
