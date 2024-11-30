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

    services.monado = {
        enable = true;
        defaultRuntime = true; # Register as default openxr runtime
    };

    systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
    };

    environment.systemPackages = with pkgs; [
        envision
    ];

    # Install wivrn
    systemd.services.flatpak-wivrn-install = {
        wantedBy = [ "multi-user.target" ];
        after = [ "flatpak-repo.service" ];
        path = [ pkgs.flatpak ];
        script = ''
            flatpak install -y flathub io.github.wivrn.wivrn
        '';
    };
}