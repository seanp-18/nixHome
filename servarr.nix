{ pkgs, lib, config, ... }:

{
  services.radarr.enable = true;
  services.radarr.settings.server.bindaddress = "127.0.0.1";
  services.sonarr.enable = true;
  services.sonarr.settings.server.bindaddress = "127.0.0.1";
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
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
  };
  services.syncthing = {
    enable = true;
    user = "root";

    settings = {
      gui.enable = false;
      devices = {
        hestia = {
          id =
            "DKZOBVI-UVDM5Y5-7DTKSFC-EWDTRHV-RTWPSZT-NGKGTYD-MJV50XL-JUV2TQI";
          addresses = [ "tcp://100.79.17.128" ];
        };
        freyja = {
          id =
            "YTSBAA3-QWCLHNR-KMCPZ4N-4JXMFAY-77W6ISR-J25BWKS-CE67AUZ-Y77FSA6";
          addresses = [ "tcp://100.120.98.80" ];
        };
      };
      folders = {
        backup = {
          path = "/backup";
          devices = [ "hestia" "freyja" ];
        };
      };
    };
  };
  services.prowlarr.settings.server.bindaddress = "127.0.0.1";
  services.jellyfin.enable = true;
  services.transmission.enable = true;
  services.transmission.settings.umask = "002";
  users.users.sonarr.extraGroups = [ "transmission" ];
  users.users.radarr.extraGroups = [ "transmission" ];
  users.users.jellyfin.extraGroups = [ "sonarr" "radarr" ];
  systemd.tmpfiles.rules = [
    "d /var/lib/transmission/Downloads - transmission transmission"
    "d /media/movies - radarr radarr"
    "d /media/tv - sonarr sonarr"
    "d /media/anime - sonarr sonarr"
    "d /var/lib/transmission/Downloads/radarr-movies - transmission transmission"
    "d /var/lib/transmission/Downloads/sonarr-shows - transmission transmission"
    "d /media/backup - smbuser users"
  ];
  # Samba requires these ports for file supports and network discovery
  networking.firewall.allowedTCPPorts = [ 445 139 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];
  # These ports are to enable applications from the home server to be available to devices on the tailnet
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 80 53 ];
  networking.firewall.interfaces.tailscale0.allowedUDPPorts = [ 53 67 ];
  systemd.services.caddy = lib.mkIf config.services.caddy.enable {
    after = [ "tailscaled.service" ];
    preStart = ''
      ${pkgs.coreutils}/bin/timeout 60s ${pkgs.bash}/bin/bash -c 'until ${pkgs.tailscale}/bin/tailscale status --peers=false >/dev/null; do ${pkgs.coreutils}/bin/sleep 1; done'
    '';
    wants = [ "tailscaled.service" ];
  };
  services.caddy = {
    enable = true;
    virtualHosts = {
      # radarr
      "http://radarr.${config.networking.hostName}" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:7878
        '';
      };
      # jellyfin
      "http://jellyfin.${config.networking.hostName}" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:8096 
        '';
      };

      # sonarr
      "http://sonarr.${config.networking.hostName}" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:8989
        '';
      };
      # prowlarr
      "http://prowlarr.${config.networking.hostName}" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:9696
        '';
      };
      #transmission 
      "http://transmission.${config.networking.hostName}" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:9091
        '';
      };
    };
  };
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      address = [
        "/sonarr.hestia/100.79.17.128"
        "/radarr.hestia/100.79.17.128"
        "/prowlarr.hestia/100.79.17.128"
        "/jellyfin.hestia/100.79.17.128"
        "/transmission.hestia/100.79.17.128"
        "/sonarr.freyja/100.120.98.80"
        "/radarr.freyja/100.120.98.80"
        "/prowlarr.freyja/100.120.98.80"
        "/jellyfin.freyja/100.120.98.80"
        "/transmission.freyja/100.120.98.80"
      ];
      server = [ "1.1.1.1" "8.8.8.8" ];
      bind-dynamic = true;
      interface = [ "tailscale0" ];

    };
  };
  environment.systemPackages = with pkgs; [ samba ];
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

