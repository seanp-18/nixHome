{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.valheim = {
    image = "ghcr.io/lloesche/valheim-server:latest";
    hostname = "valheim-server";

    environment = {
      # --- Server Identity ---
      SERVER_NAME = "cawValheim";
      WORLD_NAME = "shazam";
      SERVER_PUBLIC = "false"; # Set to "true" to appear in the public server list

      # --- System & Permissions ---
      TZ = "UTC";
      PUID = "1000";
      PGID = "1000";

      # --- Update & Restart Schedules ---
      # Check for updates every 15 minutes, only if no players are online
      UPDATE_CRON = "*/15 * * * *";
      UPDATE_IF_IDLE = "true";

      # Restart the server daily at 05:10, only if no players are online
      RESTART_CRON = "10 5 * * *";
      RESTART_IF_IDLE = "true";
      
    };

    # Secrets are loaded from a file to keep the password out of the Nix store
    environmentFiles = [ /valheim-secrets ];

    extraOptions = [ "--memory=6g" "--memory-reservation=4g" ];

    # Valheim uses UDP ports 2456-2458. Map them 1:1 to the host.
    ports = [ 
      "2456:2456/udp" 
      "2457:2457/udp" 
      "2458:2458/udp" 
    ];

    # Persist the world and configuration data
    volumes = [ 
      "valheim-config:/config"
      "valheim-data:/opt/valheim" 
    ];
  };

  # Systemd Timer for restarts (optional, as the container handles its own schedule)
  # If you prefer to restart via systemd as in your Palworld example:
  systemd.timers."podman-valheim-restart" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "00/6:00:00"; # Restart every 6 hours
      Persistent = true;
      Unit = "podman-valheim-restart.service";
    };
  };

  # Systemd Service for the restart script
  systemd.services."podman-valheim-restart" = {
    script = ''
      /run/current-system/sw/bin/systemctl restart podman-valheim.service
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
