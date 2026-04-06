{ pkgs, lib, config, ... }:

{

  # Servarr stack
  services.radarr = {
    enable = true;
    settings.server.bindaddress = "127.0.0.1";
  };
  
  services.sonarr = {
    enable = true;
    settings.server.bindaddress = "127.0.0.1";
  };
  
  services.lidarr = {
    enable = true;
    settings.server.bindaddress = "127.0.0.1";
  };
  
  services.prowlarr = {
    enable = true;
    openFirewall = true;
    settings.server.bindaddress = "127.0.0.1";
  };
  
  # User group assignments
  users.users.sonarr.extraGroups = [ "transmission" ];
  users.users.radarr.extraGroups = [ "transmission" ];
  users.users.lidarr.extraGroups = [ "transmission" ];
  users.users.jellyfin.extraGroups = [ "sonarr" "radarr" "lidarr" ];
  
  # Media directory permissions
  systemd.tmpfiles.rules = [
    "d /media/movies - radarr radarr"
    "d /media/tv - sonarr sonarr"
    "d /media/anime - sonarr sonarr"
    "d /media/music - lidarr music"
  ];
  
  systemd.user.services.caffeine = {
    description = "caffeine";
    script = "${lib.getExe' pkgs.caffeine-ng "caffeine"}";
    serviceConfig = {
      PrivateTmp = true;
      ProtectSystem = "full";
      Restart = "on-failure";
      Slice = "session.slice";
      Type = "exec";
    };
    wantedBy = [ "graphical-session.target" ];
  };
}
