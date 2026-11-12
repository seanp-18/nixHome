{ config, pkgs, ... }:
{
  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    group = "servarr";
    openFirewall = true;
    serverConfig = {
      BitTorrent = {
        Session = {
          GlobalMaxSeedingMinutes = 1209600;
          GlobalMaxSeedingAction = 2;
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/qBittorrent/Downloads - qbittorrent servarr"
    "d /var/lib/qBittorrent/Downloads/radarr-movies - qbittorrent servarr"
    "d /var/lib/qBittorrent/Downloads/sonarr-shows - qbittorrent servarr"
  ];
}
