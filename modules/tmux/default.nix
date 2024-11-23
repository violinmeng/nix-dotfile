{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.tmux;

in {
  options.modules.tmux = { enable = mkEnableOption "tmux"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
    ];
    programs.tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      customPaneNavigationAndResize = true;

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        resurrect
        continuum
        cpu
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-show-battery false
            set -g @dracula-show-powerline true
            set -g @dracula-refresh-rate 10
          '';
        }
      ];

      extraConfig = ''
        # Enable mouse support
        set -g mouse on

        # Start windows and panes at 1, not 0
        set -g base-index 1
        setw -g pane-base-index 1

        # Improve colors
        set -g default-terminal "screen-256color"
        set -ga terminal-overrides ",xterm-256color:Tc"

        # Set status bar
        set -g status-position top

        # Vim style pane selection
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Use Alt-vim keys without prefix key to switch panes
        bind -n M-h select-pane -L
        bind -n M-j select-pane -D
        bind -n M-k select-pane -U
        bind -n M-l select-pane -R

        # Shift arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window

        # Split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # Reload config file
        bind r source-file ~/.tmux.conf \; display "Reloaded!"

        # Increase scrollback buffer size
        set -g history-limit 10000

        # Auto restore tmux
        set -g @continuum-restore 'on'
      '';
    };
  };
}


