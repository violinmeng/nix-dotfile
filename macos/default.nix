# macos/default.nix
{ config, pkgs, ... }:

{
  # 系统配置
  nixpkgs.config.allowUnfree = true;

  # 启用 macOS 模块
  macos = {
    enable = true;
    system = {
      enable = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    homebrew.enable = true;
  };

  # 导入模块
  imports = [
    ./options.nix
    ./system
    ./homebrew
  ];

  # 基本系统设置
  services.nix-daemon.enable = true;

  # 添加信任用户
  nix.settings.trusted-users = [
    "@admin"
    (builtins.getEnv "USER")
  ];

  # Nix configuration
  nix.settings = {
    auto-optimise-store = true;  # 自动优化 Nix store
    keep-outputs = true;         # 保留构建输出
    keep-derivations = true;     # 保留导出文件
  };
}