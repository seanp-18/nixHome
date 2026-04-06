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
  networking.hostName = "freyja";
  
  # Time zone
  time.timeZone = "America/New_York";

  # Locale settings
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  

  # Freyja-specific firewall rules
  networking.firewall.interfaces.wlp3s0.allowedTCPPorts = [ 8096 4533 ];

  system.stateVersion = "25.11";
}
