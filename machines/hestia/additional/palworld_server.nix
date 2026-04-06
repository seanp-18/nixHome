{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.palworld = {
    image = "thijsvanloef/palworld-server-docker:latest";
    hostname = "palworld-server";

    environment = {
      COMMUNITY = "true";
      CROSSPLAY_PLATFORMS = "(Steam, Xbox, PS5, Mac)";
      MULTITHREADING = "true";
      PGID = "1000";
      PLAYERS = "8";
      PORT = "8211";
      PUID = "1000";
      REST_API_ENABLED = "true";
      REST_API_PORT = "8212";
      SERVER_DESCRIPTION = "bruh";
      SERVER_NAME = "CirqueDeClowns";
      TZ = "UTC";
      PAL_EGG_DEFAULT_HATCHING_TIME = "0";
      DROP_ITEM_MAX_NUM = "1000";
      PAL_SPAWN_NUM_RATE = "0.8";
    };

    environmentFiles = [ /palworld-secrets ];

    extraOptions = [ "--memory=6g" "--memory-reservation=4g" ];

    ports = [ "27015:27015/udp" "8211:8211/udp" "8212:8212/tcp" ];

    volumes = [ "palworld:/palworld" ];
  };

  # Systemd Timer for restarts
  systemd.timers."docker-palworld-restart" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "00/4:00:00";
      Persistent = true;
      Unit = "docker-palworld-restart.service";
    };
  };

  # Systemd Service for the restart script
  systemd.services."docker-palworld-restart" = {
    script = ''
      /run/current-system/sw/bin/systemctl restart podman-palworld.service
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
