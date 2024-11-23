{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.git;

in {
    options.modules.git = { enable = mkEnableOption "git"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
          git
        ];

        programs.git = {
            enable = true;
            userName = "Elin Wang";
            userEmail = "violinmeng@gmail.com";
            extraConfig = {
                init = { defaultBranch = "main"; };
                # core = {
                #     excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
                # };
                pull.rebase = true;
            };
        };
    };
}