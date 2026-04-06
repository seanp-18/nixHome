{ config, pkgs, inputs, ... }:

{
  imports = [ 
    # Hardware
    ./hardware-configuration.nix
    
    # Import entire additional folder
    ./additional
    
    # Import all module categories
    ../../modules
  ];

  # Host configuration
  networking.hostName = "hestia";
  
  # Time zone
  time.timeZone = "Asia/Bangkok";

  # Locale settings
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "th_TH.UTF-8";
    LC_IDENTIFICATION = "th_TH.UTF-8";
    LC_MEASUREMENT = "th_TH.UTF-8";
    LC_MONETARY = "th_TH.UTF-8";
    LC_NAME = "th_TH.UTF-8";
    LC_NUMERIC = "th_TH.UTF-8";
    LC_PAPER = "th_TH.UTF-8";
    LC_TELEPHONE = "th_TH.UTF-8";
    LC_TIME = "th_TH.UTF-8";
  };
  
  # Hestia-specific firewall rules
  networking.firewall.interfaces.enp0s31f6.allowedUDPPorts = [ 8211 27015 ];
  networking.firewall.interfaces.enp0s31f6.allowedTCPPorts = [ 80 8096 8212 ];


  system.stateVersion = "25.11";
}
