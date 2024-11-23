{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.neovim;

in {
    options.modules.neovim = { enable = mkEnableOption "neovim"; };
    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        neovim
      ];
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        extraConfig = ''
          " Basic Settings
          set number
          set relativenumber
          set expandtab
          set tabstop=2
          set shiftwidth=2
          set autoindent
          set smartindent
          set mouse=a
          set clipboard=unnamedplus

          " Search settings
          set ignorecase
          set smartcase
          set incsearch
          set hlsearch

          " Theme settings
          colorscheme gruvbox
          set background=dark

          " Key mappings
          let mapleader = " "
          nnoremap <leader>ff <cmd>Telescope find_files<cr>
          nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          nnoremap <leader>fb <cmd>Telescope buffers<cr>

          " NERDTree settings
          nnoremap <leader>n :NERDTreeToggle<CR>
          let NERDTreeShowHidden=1
        '';

        plugins = with pkgs.vimPlugins; [
          # File navigation
          vim-nix
          vim-commentary
          vim-surround
          vim-fugitive
          nerdtree
          telescope-nvim

          # LSP support
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path

          # Theme and visuals
          gruvbox
          vim-airline
          vim-airline-themes

          # Git integration
          vim-gitgutter

          # Language support
          vim-nix
          vim-go
          vim-python-pep8-indent
          vim-javascript
          vim-jsx-pretty
        ];
      };
    };
}