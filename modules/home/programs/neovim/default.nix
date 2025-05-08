{ unstable, ... }:
let
  lib = unstable.lib;
in
{
  stylix.targets.neovim.enable = false;

  programs.nixvim = {
    enable = true;

    enableMan = false;
    withPython3 = false;
    withRuby = false;

    extraPackages = with unstable; [
      lua-language-server
      stylua
      ripgrep
    ];

    extraPlugins = with unstable.vimPlugins; [ lazy-nvim ];

    extraConfigLua = let
      plugins = with unstable.vimPlugins; [
        LazyVim
        bufferline-nvim
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        conform-nvim
        dashboard-nvim
        dressing-nvim
        flash-nvim
        friendly-snippets
        gitsigns-nvim
        grug-far-nvim
        indent-blankline-nvim
        lazydev-nvim
        lualine-nvim
        luvit-meta
        neo-tree-nvim
        noice-nvim
        nui-nvim
        nvim-cmp
        nvim-lint
        nvim-lspconfig
        nvim-snippets
        nvim-treesitter
        nvim-treesitter-textobjects
        nvim-ts-autotag
        persistence-nvim
        plenary-nvim
        snacks-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        todo-comments-nvim
        tokyonight-nvim
        trouble-nvim
        ts-comments-nvim
        which-key-nvim
        { name = "catppuccin"; path = catppuccin-nvim; }
        { name = "mini.ai"; path = mini-nvim; }
        { name = "mini.icons"; path = mini-nvim; }
        { name = "mini.pairs"; path = mini-nvim; }
      ];

      mkEntryFromDrv = drv:
        if lib.isDerivation drv then
          { name = "${lib.getName drv}"; path = drv; }
        else
          drv;

      lazyPath = unstable.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
    in
    ''
      require("lazy").setup({
        defaults = {
          lazy = true,
        },
        dev = {
          path = "${lazyPath}",
          patterns = { "" },
          fallback = true,
        },
        spec = {
          { 
            "LazyVim/LazyVim",
            import = "lazyvim.plugins",
            opts = {
              colorscheme = "rose-pine",
            }
          },
          {
            "rose-pine/neovim",
            name = "rose-pine",
            config = function()
              require("rose-pine").setup({
                disable_background = true,
              })
            end,
          },
          { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
          { "williamboman/mason-lspconfig.nvim", enabled = false },
          { "williamboman/mason.nvim", enabled = false },
          { "nvim-treesitter/nvim-treesitter", opts = function(_, opts) opts.ensure_installed = {} end },
        },
      })
    '';

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
  };
}

