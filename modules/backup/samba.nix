{ config, pkgs, ... }:

{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings.global = {
      "workgroup" = "WORKGROUP";
      "server string" = "smbnix";
      "security" = "user";
    };
    settings.Public = {
      browseable = "yes";
      comment = "Public samba share.";
      "guest ok" = "yes";
      path = "/media/backup/";
      "read only" = "no";
    };
    settings.Music = {
      browseable = "yes";
      comment = "Music share.";
      "guest ok" = "yes";
      path = "/media/music/";
      "read only" = "no";
    };
  };

  # Samba firewall ports
  networking.firewall.allowedTCPPorts = [ 445 139 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  # Backup directory permissions
  systemd.tmpfiles.rules = [
    "d /media/backup 0775 smbuser backup -"
    "Z /media/backup - smbuser backup -"
  ];
}
