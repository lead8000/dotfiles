# configuration.nix
{ config, pkgs, lib, system, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ 
    "btusb"
    "vboxdrv"
    "vboxnetflt"
    "vboxnetadp"
  ];
  
  # Pick only one of the below networking options.
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; 
  networking.resolvconf.enable = false;

  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;

  systemd.services.bluetooth = {
    serviceConfig.ExecStart = [
      ""
      "${pkgs.bluezFull}/libexec/bluetooth/bluetoothd --experimental"
    ];
  };

  # Set your time zone.
  services.timesyncd.enable = true;
  services.timesyncd.servers = ["time.google.com"];
  time.timeZone = "America/Havana"; 

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; 
  };

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
    permittedInsecurePackages = [
      "nodejs-16.20.2"
      "qtwebkit-5.212.0-alpha4"
    ];
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
    };
  };

  services.xserver = {
    enable = true;
    layout = "us";

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
       	  haskellPackages.xmonad-extras
      	  haskellPackages.xmonad
        ];
      };
    };

    displayManager = {
      lightdm.enable = true;
      sessionCommands = ''
        ${pkgs.procps}/bin/pkill polybar || true
        /run/current-system/sw/bin/start-polybar &
	sleep 5
	{pkgs.haskellPackages.xmonad}/bin/xmonad --restart
      '';
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leandro_driguez = {
    isNormalUser = true;
    extraGroups = [ 
	"wheel" 
	"docker" 
        "audio"
        "vboxusers"
    ]; 
  };
  users.extraGroups.vboxusers.members = [ "leandro_driguez" ];

  environment.etc."polybar/config".source = /home/leandro_driguez/.config/polybar/header.conf;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim 
    neovim
    wget
    rofi
    nethogs

    haskellPackages.xmonad
    polybar

    alacritty
    telegram-desktop
    git
    firefox
    zip
    unzip
    ntfs3g

    ranger
    bind
    postman
    notion-app-enhanced
    mattermost-desktop

    openvpn
    go
    python311
    python311Packages.pip

    thunderbird
    zathura 
    libreoffice

    gcc
    cmake
    gnumake
    zlib
    unrar

    nodePackages.pyright

    dotnet-sdk_7
    omnisharp-roslyn
    
    zsh
    ffmpeg

    nodejs_18
    libGL

    docker
    docker-compose

    alsaLib
    alsaUtils

    jetbrains-mono

    vlc
    clipgrab

    texlive.combined.scheme-full

    home-manager

    unstable.google-chrome

    wireguard-tools

    obsidian
    activitywatch

    (pkgs.writeShellScriptBin "start-polybar" ''
        #!/bin/sh
  	${pkgs.polybar}/bin/polybar header -c /home/leandro_driguez/.config/polybar/header.conf &
    '')
  ];

  # List services that you want to enable:
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # services.openvpn.servers.myvpn.config = builtins.readFile "/root/.config/openvpn/config.ovpn";

  # for running AppImage
  boot.supportedFilesystems = [ "fuse" ];

  services.udev.extraRules = ''
    KERNEL=="vboxdrv", NAME="vboxdrv", OWNER="root", GROUP="vboxusers", MODE="0660"
    KERNEL=="vboxdrvu", NAME="vboxdrvu", OWNER="root", GROUP="vboxusers", MODE="0660"
    KERNEL=="vboxnetctl", NAME="vboxnetctl", OWNER="root", GROUP="vboxusers", MODE="0660"
  '';

  services.openvpn.servers.beepstream.config = builtins.readFile "/etc/nixos/beepstream.ovpn";

  system.stateVersion = "23.05";
}
