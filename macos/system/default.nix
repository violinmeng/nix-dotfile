{ config, lib, pkgs, ... }:

let
  cfg = config.macos.system;
in {
  config = lib.mkIf cfg.enable {
    # System settings
    system = {
      # 系统状态版本
      stateVersion = 4;

      # 允许自动链接应用程序
      activationScripts.applications.text = pkgs.lib.mkForce ''
        echo "setting up ~/Applications..." >&2
        rm -rf ~/Applications/Nix\ Apps
        mkdir -p ~/Applications/Nix\ Apps
        for app in $(find ${pkgs.system.build.applications}/Applications -maxdepth 1 -type l); do
          src="$(/usr/bin/stat -f%Y "$app")"
          cp -r "$src" ~/Applications/Nix\ Apps
        done
      '';

      # 系统配置
      defaults = {
        NSGlobalDomain = {
          AppleShowAllExtensions = true;
          ApplePressAndHoldEnabled = false;
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          _HIHideMenuBar = false;
        };

        dock = {
          autohide = true;
          mru-spaces = false;
          orientation = "bottom";
          showhidden = true;
        };

        finder = {
          AppleShowAllExtensions = true;
          QuitMenuItem = true;
          FXEnableExtensionChangeWarning = false;
        };

        trackpad = {
          Clicking = true;
          TrackpadThreeFingerDrag = true;
        };
      };

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };

      # Rosetta 2 support
      rosetta.enable = true;
    };

    # TouchID for sudo
    security.pam.enableSudoTouchIdAuth = true;

    # Nix settings
    nix.settings = {
      build-users-group = "nixbld";
      experimental-features = cfg.experimental-features;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # System packages
    environment.systemPackages = with pkgs; [
      mas  # Mac App Store CLI
    ];
  };
}
