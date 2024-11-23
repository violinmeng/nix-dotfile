{ pkgs, lib, config, ... }:

with lib;
let cfg =
    config.modules.packages;
    # screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    # bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    # maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';

in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
        # Development tools
        gcc
        gnumake
        cmake
        python3
        nodejs
        go

        # Command line tools
        ripgrep
        fd
        jq
        tree
        htop
        wget
        curl
        fzf

        # Other utilities
        bat  # Better cat
        exa  # Modern ls
      ];
    };
}