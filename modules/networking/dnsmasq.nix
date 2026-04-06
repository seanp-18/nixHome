{ config, pkgs, ... }:

{
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      address = [
        # Hestia's services
        "/sonarr.hestia/100.79.17.128"
        "/radarr.hestia/100.79.17.128"
        "/prowlarr.hestia/100.79.17.128"
        "/lidarr.hestia/100.79.17.128"
        "/jellyfin.hestia/100.79.17.128"
        "/transmission.hestia/100.79.17.128"
        
        # Freyja's services
        "/sonarr.freyja/100.120.98.80"
        "/radarr.freyja/100.120.98.80"
        "/prowlarr.freyja/100.120.98.80"
        "/lidarr.freyja/100.120.98.80"
        "/jellyfin.freyja/100.120.98.80"
        "/transmission.freyja/100.120.98.80"
      ];
      server = [ "1.1.1.1" "8.8.8.8" ];
      bind-dynamic = true;
      interface = [ "tailscale0" ];
    };
  };
}
