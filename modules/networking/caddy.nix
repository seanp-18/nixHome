{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://radarr.${config.networking.hostName}" = {
        extraConfig = "reverse_proxy http://127.0.0.1:7878";
      };
      "http://jellyfin.${config.networking.hostName}" = {
        extraConfig = "reverse_proxy http://127.0.0.1:8096";
      };
      "http://sonarr.${config.networking.hostName}" = {
        extraConfig = "reverse_proxy http://127.0.0.1:8989";
      };
      "http://prowlarr.${config.networking.hostName}" = {
        extraConfig = "reverse_proxy http://127.0.0.1:9696";
      };
      "http://lidarr.${config.networking.hostName}" = {
        extraConfig = "reverse_proxy http://127.0.0.1:8686";
      };
      "http://transmission.${config.networking.hostName}" = {
        extraConfig = "reverse_proxy http://127.0.0.1:9091";
      };
      "http://navidrome.${config.networking.hostName}" = {
        extraConfig = "reverse_proxy http://127.0.0.1:4533";
      };
    };
  };

  systemd.services.caddy = lib.mkIf config.services.caddy.enable {
    after = [ "tailscaled.service" ];
    preStart = ''
      ${pkgs.coreutils}/bin/timeout 60s ${pkgs.bash}/bin/bash -c 'until ${pkgs.tailscale}/bin/tailscale status --peers=false >/dev/null; do ${pkgs.coreutils}/bin/sleep 1; done'
    '';
    wants = [ "tailscaled.service" ];
  };

  # Tailscale firewall rules for Caddy
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 80 53 ];
  networking.firewall.interfaces.tailscale0.allowedUDPPorts = [ 53 67 ];
}
