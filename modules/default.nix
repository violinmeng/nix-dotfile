{ inputs, pkgs, config, ... }:

{

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "23.11";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  config.modules = {
    # gui

    # cli
    nvim.enable = true;
    zsh.enable = true;
    git.enable = true;
    neovim.enable = true;
    tmux.enable = true;

    # system
    packages.enable = true;
  };

  imports = [
      # gui
      ./alacritty


      # cli
      ./git
      ./zsh
      ./tmux
      ./nvim

      # system
  ];
}