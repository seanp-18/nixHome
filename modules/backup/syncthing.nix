{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "syncthing";
    settings = {
      gui.enable = false;
      devices = {
        hestia = {
          id = "FWOLZDG-JMOSSDR-GWM4Y4W-LXV4PMD-ICPIUMI-4KW5N46-4VBD77O-HHUMPQO";
          addresses = [ "tcp://100.79.17.128:22000" ];
        };
        freyja = {
          id = "WIEE74Z-OGTJWWI-MLXJJGP-4HMWV53-XAPAAIN-33J67UI-SUQFR3C-U27EHAN";
          addresses = [ "tcp://100.120.98.80:22000" ];
        };
      };
      folders = {
        backup = {
          path = "/media/backup";
          devices = [ "hestia" "freyja" ];
          ignorePerms = true;
        };
      };
    };
  };
  
  systemd.tmpfiles.rules = [
    "f /media/backup/.stfolder - syncthing syncthing -"
  ];
}
