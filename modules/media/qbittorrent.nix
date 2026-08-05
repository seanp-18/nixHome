{ config, pkgs, ... }:

{
  services.qbittorrent = {
  enable = true;
  webUI = {
    port = 8080;         # Default web UI port
    openFirewall = true; # Opens port in firewall
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/qbittorrent/Downloads - qbittorrent qbittorrent"
    "d /var/lib/qbittorrent/Downloads/radarr-movies - qbittorrent qbittorrent"
    "d /var/lib/qbittorrent/Downloads/sonarr-shows - qbittorrent qbittorrent"
    "d /var/lib/qbittorrent/Downloads/lidarr-music - qbittorrent qbittorrent"
  ];
}
