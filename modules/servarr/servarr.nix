{ pkgs, lib, config, ... }:

{
  users.groups.servarr = { };

  # Servarr stack
  services.radarr = {
    enable = true;
    settings.server.bindaddress = "127.0.0.1";
    group = "servarr";
  };

  services.sonarr = {
    enable = true;
    settings.server.bindaddress = "127.0.0.1";
    group = "servarr";
  };


  services.prowlarr = {
    enable = true;
    openFirewall = true;
    settings.server.bindaddress = "127.0.0.1";
  };

  # User group assignments
  users.users.sonarr.extraGroups = [ "servarr" ];
  users.users.radarr.extraGroups = [ "servarr" ];
  users.users.jellyfin.extraGroups = [ "servarr" ];


  # Media directory permissions
  systemd.tmpfiles.rules = [
    "d /media/movies - radarr servarr"
    "d /media/tv - sonarr servarr"
    "d /media/anime - sonarr servarr"
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
