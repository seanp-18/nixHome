{ ... }:

{
  virtualisation.oci-containers.containers.palworld = {
    environment = {
      COMMUNITY =
        "true"; # Enable this if you want your server to show up in the community servers tab, USE WITH SERVER_PASSWORD!
      CROSSPLAY_PLATFORMS = "(Steam,Xbox,PS5,Mac)";
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
    extraOptions = [ "--memory=6g" "--memory-reservation=4g" ];
    environmentFiles = [
      /palworld-secrets # Put the following in here.
      # SERVER_PASSWORD = "worldofpals";  # Optional but recommended
      # ADMIN_PASSWORD = "adminPasswordHere";
    ];

    hostname = "palworld-server";
    image = "thijsvanloef/palworld-server-docker:latest";
    ports = [
      "27015:27015/udp" # Required if you want your server to show up in the community servers tab
      "8211:8211/udp"
      "8212:8212/tcp" # REST API enabled port, enabled by default. DO NOT PORT FORWARD THIS.
    ];
    volumes = [ "palworld:/palworld" ];
  };
  # This creates a timer that triggers every 4 hours
  systemd.timers."docker-palworld-restart" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "00/4:00:00"; # Runs every 4 hours (12am, 4am, 8am, etc.)
      Persistent = true; # If the machine was off, it runs immediately on boot
      Unit = "docker-palworld-restart.service";
    };
  };
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

