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
  ];
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
  environment.systemPackages = [ pkgs.wgnord ];
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
  ## proton vpn brokie
  # networking.wg-quick.interfaces."wg0" = {
  #   autostart = true;
  #   dns = [ "10.2.0.1" ];
  #   privateKeyFile = "/home/sean/protonFilekey.txt";
  #   address = [ "10.2.0.2/32" ];

  #   peers = [{
  #     publicKey = "KJ7R+L65d6HOlSCMvQKFEbEzWga5MtlR24Plh7afIGI=";
  #     allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #     endpoint = "185.183.33.11:51820";
  #   }];
  # };
}

