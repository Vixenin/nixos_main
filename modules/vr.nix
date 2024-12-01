{ config, pkgs, ... }:

{
    # Install wivrn :3
    services.wivrn = {
        enable = true;
        defaultRuntime = true;
        openFirewall = true;
        config.json = {
            scale = 1.0;
            bitrate = 50 * 1000000;
            encoders = [ 
                {
                    encoder = "nvenc";
                    codec = "h264";
                    width = 1.0;
                    height = 1.0;
                    offset_x = 0.0;
                    offset_y = 0.0;
                } 
            ];
            application = [ pkgs.wlx-overlay-s ];
            tcp_only = true;
        };
        autoStart = true;
    };
}
