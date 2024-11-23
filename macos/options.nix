{ config, lib, pkgs, ... }:
{
  options.macos = {
    enable = lib.mkEnableOption "Enable macOS specific configuration";

    system = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable macOS system configuration";
      };

      experimental-features = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "nix-command" "flakes" ];
        description = "Experimental features to enable in Nix";
      };
    };

    homebrew = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable Homebrew package manager";
      };

      autoUpdate = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to automatically update Homebrew on activation";
      };

      cleanup = lib.mkOption {
        type = lib.types.str;
        default = "zap";
        description = "Cleanup mode for Homebrew";
      };
    };
  };

  config = lib.mkIf config.macos.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isDarwin;
        message = "This module is only supported on macOS";
      }
    ];
  };
}
