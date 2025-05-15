{ unstable, ... }:
let
  lib = unstable.lib;
in
{
  stylix.targets.neovim.enable = false;

  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    enableMan = false;

    withPython3 = false;
    withRuby = false;

    extraPackages = with unstable; [
      marksman
      markdownlint-cli2
      lua-language-server
      bash-language-server
      tailwindcss-language-server
      lua
      luarocks
      nil
      stylua
      fzf
    ];

    extraPlugins = with unstable.vimPlugins; [ lazy-nvim ];

    extraConfigLua =
      let
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
          {
            name = "catppuccin";
            path = catppuccin-nvim;
          }
          {
            name = "mini.ai";
            path = mini-nvim;
          }
          {
            name = "mini.icons";
            path = mini-nvim;
          }
          {
            name = "mini.pairs";
            path = mini-nvim;
          }
        ];

        mkEntryFromDrv =
          drv:
          if lib.isDerivation drv then
            {
              name = "${lib.getName drv}";
              path = drv;
            }
          else
            drv;

        lazyPath = unstable.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        local header = [[

          ███    ██ ██ ██   ██ ██    ██ ██ ███    ███
          ████   ██ ██  ██ ██  ██    ██ ██ ████  ████
          ██ ██  ██ ██   ███   ██    ██ ██ ██ ████ ██
          ██  ██ ██ ██  ██ ██   ██  ██  ██ ██  ██  ██
          ██   ████ ██ ██   ██   ████   ██ ██      ██
        ]]
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
            {
              "folke/snacks.nvim",
              optional = true,
              opts = {
                dashboard = {
                  width = 50,
                  preset = {
                    header = header,
                    -- stylua: ignore
                    ---@type snacks.dashboard.Item[]
                    keys = {
                      { icon = " ", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')", key = "f" },
                      { icon = " ", desc = "New File", action = ":ene | startinsert", key = "n" },
                      ---@diagnostic disable-next-line: missing-fields
                      { icon = " ", desc = "Explorer", action = function() Snacks.explorer({ cwd = LazyVim.root() }) end , key = "e" },
                      { icon = " ", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')", key = "r" },
                      { icon = " ", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", key = "c" },
                      { icon = "󰦛 ", key = "s", desc = "Restore Session", section = "session" },
                      { icon = "󰁯 ", action = function() require("persistence").load({ last = true }) end, desc = "Restore Last Session", key = "S" },
                      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                  },
                },
              },
            },

            {
              "nvimdev/dashboard-nvim",
              optional = true,
              opts = function()
                local function config()
                  vim.cmd.cd(vim.fn.stdpath("config"))
                  require("persistence").load()
                end

              local function restore_session() require("persistence").load() end
              local function restore_last_session() require("persistence").load({ last = true }) end
              local function quit() vim.api.nvim_input("<cmd>qa<cr>") end

                return {
                  logo = header,
                  theme = "doom",
                  hide = {
                    statusline = false,
                  },
                  config = {
                  center = {
                    { action = 'lua LazyVim.pick()()',              desc = "Find File",            icon = "", key = "f" },
                    { action = "ene | startinsert",                 desc = "New File",             icon = "", key = "n" },
                    { action = "Neotree",                           desc = "Explorer",             icon = "", key = "e" },
                    { action = 'lua LazyVim.pick("oldfiles")()',    desc = "Recent Files",         icon = "", key = "r" },
                    { action = 'lua LazyVim.pick("live_grep")()',   desc = "Find Text",            icon = "", key = "g" },
                    { action = restore_session,                     desc = "Restore Session",      icon = "󰁯", key = "s" },
                    { action = restore_last_session,                desc = "Restore Last Session", icon = "󰦛", key = "S" },
                    { action = quit,                                desc = "Quit",                 icon = "", key = "q" },
                  },
                    footer = function()
                      local stats = require("lazy").stats()
                      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                      return { "⚡ Nixvim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
                    end,
                  },
                }
              end,
              config = function(_, opts)
                local win_height = vim.api.nvim_win_get_height(0) + 2 -- plus 2 for status bar
                local _, logo_count = string.gsub(opts.logo, "\n", "") -- count newlines in logo
                local logo_height = logo_count + 2 -- logo size + newlines
                local actions_height = #opts.config.center * 2 - 1 -- minus 1 for last item
                local total_height = logo_height + actions_height + 2 -- plus for 2 for footer
                local margin = math.floor((win_height - total_height) / 2)
                local logo = string.rep("\n", margin) .. opts.logo .. "\n"
                opts.config.header = vim.split(logo, "\n")

                for _, button in ipairs(opts.config.center) do
                  button.desc = "  " .. button.desc .. string.rep(" ", 40 - #button.desc)
                  button.key_format = "%s"
                end

                -- open dashboard after closing lazy
                if vim.o.filetype == "lazy" then
                  vim.api.nvim_create_autocmd("WinClosed", {
                    pattern = tostring(vim.api.nvim_get_current_win()),
                    once = true,
                    callback = function()
                      vim.schedule(function()
                        vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
                      end)
                    end,
                  })
                end

                require("dashboard").setup(opts)
              end,
            },
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
