{ config, pkgs, ... }:

{
  services.transmission = {
    enable = true;
    settings.umask = "002";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/transmission/Downloads - transmission transmission"
    "d /var/lib/transmission/Downloads/radarr-movies - transmission transmission"
    "d /var/lib/transmission/Downloads/sonarr-shows - transmission transmission"
    "d /var/lib/transmission/Downloads/lidarr-music - transmission transmission"
  ];
}
