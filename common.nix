{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/backup/default.nix
    ./modules/media/default.nix
    ./modules/networking/default.nix
    ./modules/servarr/default.nix
  ];
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";

  # GNOME Desktop Environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.gdm.autoSuspend = false;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Sound with PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Nix settings
  nix.settings = {
    allowed-users = [ "sean" "nix-gc" "root" ];
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "sean" "root" ];
    auto-optimise-store = true;
    use-xdg-base-directories = true;
  };

  # Users and groups
  users.users.sean = {
    isNormalUser = true;
    description = "sean";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  users.users.smbuser = {
    isNormalUser = true;
    description = "filetransfers";
    extraGroups = [ "backup" ];
  };

  users.users.syncthing = {
    isSystemUser = true;
    group = "syncthing";
    extraGroups = [ "backup" ];
  };

  users.users.lidarr = {
    isSystemUser = true;
    group = "lidarr";
    extraGroups = [ "music" ];
  };

  # Groups
  users.groups.backup = { };
  users.groups.music = { };

  # Programs
  programs.firefox.enable = true;
  programs.git.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Base system packages
  environment.systemPackages = with pkgs; [
    nil
    inputs.lwad-nixos.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    nixfmt-classic
    wgnord
  ];

  # Base firewall ports
  networking.firewall.allowedTCPPorts = [ 5051 ];
  networking.firewall.allowedUDPPorts = [ 5051 ];
}
