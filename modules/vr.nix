{ config, pkgs, ... }:

{
    # Avahi for vr | wivrn
    services.avahi = {
        enable = true;
        publish = {
            enable = true;
            userServices = true;
        };
    };

    # Install wivrn :3
    systemd.services.flatpak-wivrn-install = {
        wantedBy = [ "multi-user.target" ];
        after = [ "flatpak-repo.service" ];
        path = [ pkgs.flatpak ];
        script = ''
            flatpak install -y flathub io.github.wivrn.wivrn
        '';
    };
}
