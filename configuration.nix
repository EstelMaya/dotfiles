{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "22.11";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = [ "uvcvideo" ];
    kernelParams = [
      "quiet"
      "loglevel=3"
      "acpi_backlight=vendor"
      "vt.global_cursor_default=0"
    ];

    loader = {
      timeout = 3;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        editor = false;
      };
    };
  };


  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
    opengl.driSupport = true;
  };

  time.timeZone = "Asia/Yekaterinburg";

  networking = {
    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        address = [ "10.8.0.6/24" ];
        dns = [ "1.1.1.1" ];
        privateKeyFile = "/root/wireguard-keys/privatekey";

        peers = [
          {
            publicKey = "JSl0z3KFhMbAPZE9Bcw4nnwq4Owk6TptWGHEDT2g7nY=";
            presharedKeyFile = "/root/wireguard-keys/presharedkey";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            endpoint = "20.223.217.137:51820";
            persistentKeepalive = 0;
          }
        ];
      };
    };
    hostName = "laptop";
    wireless.iwd.enable = true;
    wireless.iwd.settings = {
      General = {
        EnableNetworkConfiguration = true;
      };
      Network = {
        EnableIPv6 = true;
      };
    };
  };

  security = {
    sudo.enable = false;
    doas.enable = true;
    doas.extraRules = [{
      groups = [ "wheel" ];
      keepEnv = true;
    }];
  };

  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv-with-scripts.override {
        scripts = [ self.mpvScripts.mpris ];
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    psmisc
    python310
    ranger
    neofetch
    zathura
    tdesktop
    brave
    keepassxc
    imv
    mpv
    libreoffice-fresh-unwrapped
    qbittorrent
    libnotify
    pavucontrol
    zsh-powerlevel10k
    zsh-history-substring-search
    pulseaudio
    zip
    unzip
    youtube-dl
    ffmpeg
    android-file-transfer
    mediainfo
    rnix-lsp
    nodePackages.pyright
    nodePackages.vscode-json-languageserver
  ];

  fonts.fonts = with pkgs; [
    hack-font
    font-awesome
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-cjk
  ];


  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      histSize = 1000;
      histFile = "$HOME/.histfile";
      shellAliases = {
        x = "doas";
        r = "ranger";
        p = "python";
      };

      interactiveShellInit = with pkgs;
        lib.mkAfter (lib.concatStringsSep "\n" ([
          "source ${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
          "source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
          "bindkey -v"
          "zstyle ':completion:*' menu select"
          "setopt HIST_IGNORE_ALL_DUPS"
          "unsetopt beep"
          "source /etc/p10k.zsh"
          "bindkey '^[[A' history-substring-search-up"
          "bindkey '^[[B' history-substring-search-down"
        ]));
    };

    adb.enable = true;
    git.enable = true;
    npm.enable = true;
    light.enable = true;

    sway.enable = true;
    sway.extraPackages = with pkgs; [ swayidle foot fuzzel grim slurp mako playerctl gammastep waybar wl-clipboard libappindicator-gtk3 ];
    xwayland.enable = false;

    neovim = {
      enable = true;
      viAlias = true;
      defaultEditor = true;
      withPython3 = true;
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ packer-nvim nvim-treesitter ];
        };
        customRC = ''
          	        luafile /etc/nvim/init.lua
        '';
      };
    };
  };

  xdg.portal.wlr.enable = true;

  services = {
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };


  users.defaultUserShell = pkgs.zsh;
  users.users.kei = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
