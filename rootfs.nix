# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    #"console=tty0"
    "gnome.initial-setup=1"
    "debug"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # no user accounts
  users = {
    mutableUsers = false;
    allowNoPasswordLogin = true;
    users.gnome-initial-setup = {
      isSystemUser = true;
      group = "gnome-initial-setup";
      home = "/var/lib/gnome-initial-setup";
      createHome = true;
    };
    groups.gnome-initial-setup = {};
  };
  
  # but gnome-initial-setup
  services.gnome.gnome-initial-setup.enable = true;
  services.displayManager.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  # TODO: upstream this
  # override gdm pam config
  security.pam.services.gdm-launch-environment.text = pkgs.lib.mkForce ''
    auth     required       pam_succeed_if.so audit quiet_success user in gdm:gnome-initial-setup
    auth     optional       pam_permit.so

    account  required       pam_succeed_if.so audit quiet_success user in gdm:gnome-initial-setup
    account  sufficient     pam_unix.so

    password required       pam_deny.so

    session  required       pam_succeed_if.so audit quiet_success user in gdm:gnome-initial-setup
    session  required       pam_env.so conffile=/etc/pam/environment readenv=0
    session  optional       ${config.systemd.package}/lib/security/pam_systemd.so
    session  optional       pam_keyinit.so force revoke
    session  optional       pam_permit.so
  '';
  environment.gnome.excludePackages = [
    pkgs.evince
    pkgs.gnome-photos
    pkgs.gnome-text-editor
    pkgs.gnome-tour
    pkgs.gedit # text editor
    pkgs.simple-scan
    pkgs.yelp
    pkgs.gnome.cheese # webcam tool
    pkgs.gnome.file-roller
    pkgs.gnome.geary # email reader
    pkgs.gnome.evince # document viewer
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-characters
    pkgs.gnome.gnome-contacts
    pkgs.gnome.gnome-control-center
    pkgs.gnome.gnome-clocks
    pkgs.gnome.gnome-font-viewer
    pkgs.gnome.gnome-disk-utility
    pkgs.gnome.gnome-maps
    pkgs.gnome.gnome-music
    pkgs.gnome.gnome-system-monitor
    pkgs.gnome.gnome-terminal
    pkgs.gnome.gnome-weather
    pkgs.gnome.epiphany # web browser
    pkgs.gnome.nautilus
    pkgs.gnome.sushi
    pkgs.gnome.totem # video player
    pkgs.gnome.tali # poker game
    pkgs.gnome.iagno # go game
    pkgs.gnome.hitori # sudoku game
    pkgs.gnome.atomix # puzzle game
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];
  # List services that you want to enable:

  # Disable permanent logging.
  services.journald.extraConfig = "Storage=volatile";

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

