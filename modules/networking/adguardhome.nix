{ config, pkgs, ... }:

{
  services.adguardhome = {
    enable = true;
    openFirewall = true;

    settings = {
      dns = {
        bind_hosts = [ "0.0.0.0" "127.0.0.1" ];
        port = 53;
        upstream_dns = [ "[/hestia/]127.0.0.1:5353" "1.1.1.1" "9.9.9.9" ];
        bootstrap_dns = [ "1.1.0.1" "9.9.9.10" ];
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
      };

      filters = map (url: {
        enabled = true;
        url = url;
      }) [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
      ];
    };
  };

  networking.nameservers = [ "127.0.0.1" ];
}
