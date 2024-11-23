{ config, lib, pkgs, ... }:

let
  cfg = config.macos.homebrew;
  isAppInstalled = app:
    lib.any (x: x == app) (lib.splitString "\n" (builtins.getEnv "HOMEBREW_INSTALLED_APPS"));
in {
  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = cfg.autoUpdate;
        cleanup = cfg.cleanup;
        upgrade = true;
      };
      global = {
        brewfile = true;
        lockfiles = true;
      };
      taps = [
        "homebrew/cask-fonts"
        "homebrew/services"
        "homebrew/cask-versions"
      ];
      # 只在 WeChat 未安装时添加到 masApps
      masApps = if ! isAppInstalled "WeChat" then {
        WeChat = 836500024;  # WeChat App Store ID
      } else {};

      # Homebrew configuration
      extraConfig = ''
        # 如果应用已存在，跳过安装
        cask_args appdir: "~/Applications",
                  skip_cask_deps: true,
                  require_sha: true,
                  no_quarantine: true,
                  skip_cask_deps: true

        # 检查已安装的应用
        before_install: |
          installed_apps=$(ls -1 /Applications/ ~/Applications/ 2>/dev/null | grep '\.app$' | sed 's/\.app$//')
          export HOMEBREW_INSTALLED_APPS="$installed_apps"
      '';

      # Homebrew Cask 配置
      casks = [];  # 可以根据需要添加其他应用
    };
  };
}
