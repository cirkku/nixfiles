#originally made by notusknot
{ pkgs, config, ... }:

let
    gruvbox = pkgs.vimUtils.buildVimPlugin {
        name = "gruvbox";
        src = pkgs.fetchFromGitHub {
            owner = "morhetz";
            repo = "gruvbox";
            rev = "bf2885a95efdad7bd5e4794dd0213917770d79b7";
            sha256 = "0576sqzljal3k8rsnbmcvlsk4ywg1vfgkxkvrv2zac2d5wwa9i8z";
        };
    };

in
{
    enable = true;
    plugins = with pkgs.vimPlugins; [
        # File tree
        nvim-web-devicons 
        nvim-tree-lua

        # LSP
        nvim-lspconfig

        # Languages
        vim-nix

        # Eyecandy 
        nvim-treesitter
        bufferline-nvim
        galaxyline-nvim
        nvim-colorizer-lua
        gruvbox
        pears-nvim

        # Lsp and completion
        nvim-lspconfig
        nvim-compe

        # Telescope
        telescope-nvim

        # Indent lines
        indent-blankline-nvim
    ];
    extraConfig = ''
        luafile /home/tuukka/.config/nixfiles/home/nvim/lua/settings.lua
    '';
}

