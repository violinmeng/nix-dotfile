{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.zsh;

in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
      # install zsh with home packages
      home.packages = with pkgs; [
	      zsh
	    ];

      # Shell configuration (zsh)
      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "docker" "python" "node" ];
          theme = "robbyrussell";
        };
        initExtra = ''
          # Custom aliases
          alias ll="exa -l"
          alias la="exa -la"
          alias cat="bat"
          alias vim="nvim"

          # FZF configuration
          if [ -f ~/.fzf.zsh ]; then
            source ~/.fzf.zsh
          elif [ -f "${pkgs.fzf}/share/fzf/completion.zsh" ]; then
            source "${pkgs.fzf}/share/fzf/completion.zsh"
            source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
          fi
        '';
      };
    };
}