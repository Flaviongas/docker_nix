# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Santiago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.flavio02 = {
    isNormalUser = true;
    description = "Flavio Jara";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    lazydocker
    bottom
  ];

programs={
neovim = {
enable = true;
defaultEditor = true;
viAlias = true;
vimAlias = true;
};
nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

   services={
   openssh.enable = true;
   };
  nix.settings.experimental-features = ["nix-command" "flakes"];
 systemd.services.cloudflare = {
    wantedBy = ["multi-user.target"];
    after = ["systemd-resolved.service"];
    serviceConfig = {                                            ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=eyJhIjoiNjE1NjcwYzExNDM4MzlmY2VkOTQwYTc0OGZmNmJkZTYiLCJ0IjoiZTA1OWJiMzctMmUzYS00OTI1LWFiZGUtYmEzOGI2YzIzYjA2IiwicyI6IlpURTBORFZoTVRJdFpUQXdZeTAwWkRGaExUbGtNRE10WldKallqVmpNVEJoTjJReiJ9 ";
      Restart = "always";
      User = "root";
      Group = "root";
    };
  };


  system.stateVersion = "25.05"; # Did you read the comment?
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = ["orion"];

systemd.services.uptime = {
    wantedBy = ["multi-user.target"];
    after = ["systemd-resolved.service" "docker.service" "docker.socket"];
    script = ''${pkgs.docker}/bin/docker compose -f /home/flavio02/uptime-kuma/docker-compose.yml up'';
    serviceConfig = {
      Restart = "always";
      User = "root";
      Group = "root";
    };
  };

systemd.services.portainer = {
    wantedBy = ["multi-user.target"];
    after = ["systemd-resolved.service" "docker.service" "docker.socket"];
    script = ''${pkgs.docker}/bin/docker compose -f /home/flavio02/portainer/docker-compose.yml up'';
    serviceConfig = {
      Restart = "always";
      User = "root";
      Group = "root";
    };
  };

}
