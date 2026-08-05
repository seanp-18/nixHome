{ config, pkgs, ... }:

{
  services.qbittorrent = {
  enable = true;
  webuiPort = 8080;
  group = "servarr";
  openFirewall = true;

  };

  systemd.tmpfiles.rules = [
    "d /var/lib/qbittorrent/Downloads - qbittorrent servarr"
    "d /var/lib/qbittorrent/Downloads/radarr-movies - qbittorrent servarr"
    "d /var/lib/qbittorrent/Downloads/sonarr-shows - qbittorrent servarr"
  ];
}
