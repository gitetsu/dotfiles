local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nathom/filetype.nvim",
  },
  {
    "stevearc/dressing.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.2",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "nvim-telescope/telescope-symbols.nvim",
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
      },
      {
        "benfowler/telescope-luasnip.nvim",
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
          require("telescope").load_extension "frecency"
        end,
      },
      {
        "molecule-man/telescope-menufacture",
        config = function()
          require("telescope").load_extension "menufacture"
        end,
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension "file_browser"
        end,
      },
    },
    cmd = { "Telescope" },
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      telescope.load_extension "fzf"
      telescope.load_extension "live_grep_args"
      telescope.load_extension "luasnip"
      telescope.setup {
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          mappings = {
            i = {
              ["<C-a>"] = { "<ESC>I", type = "command" },
              ["<C-g>"] = actions.close,
            },
          },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require "which-key"
      function ToggleCopyMode()
        if not vim.g.default_mouse_mode then
          vim.g.default_mouse_mode = vim.opt.mouse:get()
        end

        if next(vim.opt.mouse:get()) == nil then
          vim.opt.mouse = vim.g.default_mouse_mode
        else
          vim.opt.mouse = {}
        end
        vim.opt.list = not (vim.opt.list:get())
        vim.api.nvim_command "IBLToggle"
        vim.api.nvim_command "ToggleDiag"
      end
      wk.register({
        e = {
          name = "Edit",
          j = { "<cmd>lua require('ts-node-action').node_action()<cr>", "Node Action" },
          J = { "<cmd>TSJToggle<cr>", "Toggle Split / Join" },
          t = { "<cmd>Oil --float<cr>", "Edit Current Buffer Tree" },
          T = { "<cmd>execute 'Oil --float' getcwd()<cr>", "Edit Current Tree" },
        },
        f = {
          name = "Find",
          b = { "<cmd>lua require('telescope').extensions.menufacture.buffers()<cr>", "Find Buffers" },
          c = { "<cmd>lua require('telescope.builtin').colorscheme()<cr>", "Find Colorschemes" },
          B = { "<cmd>lua require('browse').open_bookmarks({ bookmarks = bookmarks })<cr>", "Find Buffers" },
          f = { "<cmd>lua require('telescope').extensions.menufacture.find_files()<cr>", "Find Files" },
          F = { "<cmd>lua require('telescope.builtin').find_files({no_ignore=true})<cr>", "Find All Files" },
          g = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "Grep Files" },
          G = { "<cmd>lua require('telescope.builtin').live_grep({no_ignore=true})<cr>", "Grep All Files" },
          j = { "<cmd>OverseerRun<cr>", "Find Jobs" },
          r = { "<cmd>Telescope frecency<cr>", "Recent Files" },
          s = { "<cmd>lua require('telescope').extensions.luasnip.luasnip{}<cr>", "Find Snippets" },
          t = { "<cmd>Telescope file_browser<cr>", "Find In Current Buffer Tree" },
          T = { "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", "Find In Current Directory Tree" },
          u = { "<cmd>UrlView<cr>", "Find URLs" },
        },
        g = {
          name = "Git",
          v = { "<cmd>OpenInGHFileLines<cr>", "Open in GitHub" },
        },
        l = {
          name = "Lsp",
          a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
          d = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Go To Definition(Preview)" },
          k = { "<cmd>lua require('lsp_signature').toggle_float_win()<cr>", "Toggle lsp_signature" },
        },
        s = {
          name = "Swap",
          s = { "<cmd>lua require('iswap').iswap_with()<cr>", "Swap With This" },
          S = { "<cmd>lua require('iswap').iswap()<cr>", "Swap" },
        },
        t = {
          name = "Toggle",
          c = { "<cmd>lua ToggleCopyMode()<cr>", "Toggle Copy Mode" },
          f = { "<cmd>NvimTreeToggle<cr>", "Toggle File Tree" },
          k = { "<cmd>HiMyWordsToggle<cr>", "Toggle Hightlight Word Under Cursor" },
          K = { "<cmd>HiMyWordsClear<cr>", "Clear All Highlights" },
          n = { "<cmd>set number!<cr>", "Toggle Number" },
          p = { "<cmd>set paste!<cr>", "Toggele Paste" },
          r = { "<cmd>RegexplainerToggle<cr>", "Toggele Regexplainer" },
          u = { "<cmd>UndotreeToggle<cr>", "Toggle Undo Tree" },
        },
        w = {
          name = "Window",
          w = { "<cmd>WinShift<cr>", "Start Win-Move mode targeting the current window for moving" },
          s = { "<cmd>WinShift swap<cr>", "Swap the current window with another" },
        },
      }, { prefix = "<leader>" })
    end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeFindFile", "NvimTreeToggle", "NvimTreeClose" },
    config = function()
      require("nvim-tree").setup {
        hijack_cursor = true,
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        git = {
          ignore = false,
        },
        renderer = {
          group_empty = true,
        },
      }
    end,
  },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    config = function()
      require("oil").setup {
        keymaps = {
          ["q"] = "actions.close",
          ["<esc>"] = "actions.close",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-x>"] = "actions.select_split",
        },
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 20,
        },
      }
    end,
  },
  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup {
        mappings = {
          "rails",
        },
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup {
        indent = {
          char = "▏",
        },
      }
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
        },
        sections = {
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              path = 1,
            },
          },
          lualine_x = { "branch", "diff", "diagnostics", "encoding", "fileformat", "filetype" },
        },
        inactive_sections = {
          lualine_c = {
            {
              "filename",
              path = 4,
            },
          },
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/lua-dev.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
          require("lspsaga").setup {}
        end,
      },
      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup()
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("mason-lspconfig").setup()
        end,
      },
      {
        "jayp0521/mason-null-ls.nvim",
        config = function()
          require("mason-null-ls").setup {
            ensure_installed = { "prettier" },
            automatic_installation = true,
          }
        end,
      },
    },
    config = function()
      require("lspconfig").lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              -- https://github.com/neovim/nvim-lspconfig/issues/1700
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }
      require("lspconfig")["tsserver"].setup {}
      require("lspconfig")["phpactor"].setup {}
      require("lspconfig")["ruby_ls"].setup {}
      require("lspconfig")["solargraph"].setup {}
      require("null-ls").setup {
        sources = {
          require("null-ls").builtins.completion.spell,
          require("null-ls").builtins.diagnostics.actionlint,
          require("null-ls").builtins.diagnostics.checkmake,
          require("null-ls").builtins.diagnostics.yamllint,
          require("null-ls").builtins.diagnostics.zsh,
          require("null-ls").builtins.formatting.stylua,
        },
      }
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      local config = {
        debug = true,
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
          border = "rounded",
        },
        hint_prefix = "🤖",
      }

      require("lsp_signature").setup(config)
      require("lsp_signature").on_attach(config)
    end,
  },
  {
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = function()
      require("toggle_lsp_diagnostics").init {}
    end,
  },
  {
    "bennypowers/nvim-regexplainer",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("regexplainer").setup {
        auto = true,
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup {}
    end,
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup {
        opacity = 10,
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      {
        "mizlan/iswap.nvim",
        config = function()
          require("iswap").setup {}
        end,
      },
      "RRethy/nvim-treesitter-endwise",
      {
        "ckolkey/ts-node-action",
        dependencies = { "nvim-treesitter" },
        config = function()
          require("ts-node-action").setup {}
        end,
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "dockerfile",
          "graphql",
          "hcl",
          "html",
          "javascript",
          "json",
          "lua",
          "make",
          "markdown",
          "php",
          "regex",
          "ruby",
          "sql",
          "tsx",
          "typescript",
          "yaml",
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        autotag = {
          enable = false,
        },
        endwise = {
          enable = true,
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    -- TODO
    "hiphish/rainbow-delimiters.nvim",
  },
  {
    "m-demare/hlargs.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("hlargs").setup {}
    end,
  },
  {
    "asiryk/auto-hlsearch.nvim",
    version = "1.0.0",
    config = function()
      require("auto-hlsearch").setup {
        create_commands = false,
      }
    end,
  },
  {
    "dvoytik/hi-my-words.nvim",
    event = "VeryLazy",
    config = function()
      require("hi-my-words").setup {}
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {}
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.search").setup()
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup {}
    end,
  },
  {
    -- TODO
    "mvllow/modes.nvim",
    version = "v0.2.0",
    config = function()
      require("modes").setup {}
    end,
  },
  {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup {}
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
    end,
  },
  {
    "kana/vim-smartchr",
  },
  -- {
  --   "Dkendal/nvim-treeclimber",
  --   config = function()
  --     require("nvim-treeclimber").setup()
  --   end,
  -- },
  {
    -- TODO tag
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup {}
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      local augroup = vim.api.nvim_create_augroup("AutoFormatGroup", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = "*",
        group = augroup,
        command = "FormatWrite",
      })
      require("formatter").setup {
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua,
          },
          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
          },
        },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()
        end,
      },
      "hrsh7th/cmp-buffer",
      "onsails/lspkind.nvim",
      "ray-x/cmp-treesitter",
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      {
        "rafamadriz/friendly-snippets",
      },
    },
    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"
      local luasnip = require "luasnip"
      luasnip.filetype_extend("ruby", { "rails" })
      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "treesitter" },
          { name = "luasnip" },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol_text",
          },
        },
        mapping = {
          ["<C-i>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end),
          ["<C-n>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ["<C-p>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
        sorting = {
          comparators = {
            function(...)
              return require("cmp_buffer"):compare_locality(...)
            end,
          },
        },
      }
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  {
    "kevinhwang91/nvim-fundo",
    dependencies = "kevinhwang91/promise-async",
    build = function()
      require("fundo").install()
    end,
    config = function()
      vim.o.undofile = true
      require("fundo").setup {}
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    event = "VeryLazy",
    config = function()
      require("highlight-undo").setup {}
    end,
  },
  {
    "folke/flash.nvim",
    config = function()
      require("flash").setup {
        label = {
          uppercase = false,
          rainbow = {
            enabled = true,
          },
        },
      }
    end,
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
      },
    },
  },
  {
    "Wansmer/treesj",
    cmd = "TSJToggle",
    config = function()
      require("treesj").setup()
    end,
  },
  {
    "monaqa/dial.nvim",
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.constant.alias.bool,
          augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%H:%M"],
          augend.date.alias["%H:%M:%S"],
          augend.constant.alias.ja_weekday,
          augend.constant.alias.ja_weekday_full,

          augend.constant.new {
            elements = { "and", "or" },
            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          },
          augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          },
        },
      }

      vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
      vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual "visual", { noremap = true })
      vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual "visual", { noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual "visual", { noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual "visual", { noremap = true })
    end,
  },
  {
    -- TODO
    "jinh0/eyeliner.nvim",
  },
  {
    "tversteeg/registers.nvim",
    name = "registers",
  },
  {
    -- TODO
    "gbprod/stay-in-place.nvim",
    config = function()
      require("stay-in-place").setup {}
    end,
  },
  {
    -- TODO
    "wellle/targets.vim",
  },
  {
    -- TODO
    "utilyre/sentiment.nvim",
    config = function()
      require("sentiment").setup {}
    end,
  },
  {
    -- TODO
    "lalitmee/browse.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("browse").setup {
        provider = "brave",
        bookmarks = {
          ["github"] = {
            ["name"] = "search github from neovim",
            ["code_search"] = "https://github.com/search?q=%s&type=code",
            ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
            ["issues_search"] = "https://github.com/search?q=%s&type=issues",
            ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
          },
          "https://www.startpage.com/sp/search?query=%s",
          "https://search.funami.tech/search.php?q=%s",
        },
      }
    end,
  },
  {
    -- TODO
    "famiu/nvim-reload",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("wildfire").setup()
    end,
  },
  {
    "ray-x/starry.nvim",
    config = function()
      vim.g.starry_disable_background = true
    end,
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup {
        transparent = true,
      }
    end,
  },
  {
    "sainnhe/sonokai",
    config = function()
      vim.g.sonokai_transparent_background = true
    end,
  },
  {
    "Yazeed1s/minimal.nvim",
    config = function()
      vim.g.minimal_transparent_background = true
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup {
        transparent_background = true,
      }
      -- [[vim.cmd "colorscheme catppuccisonokain"]]
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup {
        options = {
          transparent = true,
        },
      }
    end,
  },
  {
    "marko-cerovac/material.nvim",
    config = function()
      require("material").setup {
        disable = {
          background = true,
        },
      }
    end,
  },
  {
    "Th3Whit3Wolf/one-nvim",
    config = function()
      vim.g.one_nvim_transparent_bg = true
    end,
  },
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup {
        style = "deep",
        transparent = true,
      }
    end,
  },
  {
    "rmehri01/onenord.nvim",
    config = function()
      require("onenord").setup {
        disable = {
          background = true,
        },
      }
    end,
  },
  {
    "maxmx03/FluoroMachine.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local fm = require "fluoromachine"
      fm.setup {
        transparent = true,
      }
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    config = function()
      require("nordic").setup {
        transparent_bg = true,
      }
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup {
        transparent = true,
      }
    end,
  },
  {
    "JoosepAlviste/palenightfall.nvim",
    config = function()
      require("palenightfall").setup {
        transparent = true,
      }
    end,
  },
  {
    "Yagua/nebulous.nvim",
    config = function()
      require("nebulous").setup {
        disable = {
          background = true,
        },
      }
    end,
  },
  {
    "folke/styler.nvim",
    config = function()
      require("styler").setup {
        themes = {
          lua = { colorscheme = "fluoromachine" },
          typescriptreact = { colorscheme = "nightfox" },
          -- help = { colorscheme = "kanagawa" },
          ruby = { colorscheme = "duskfox" },
        },
      }
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = function()
      require("colorful-winsep").setup {
        no_exec_files = { "packer", "TelescopePrompt", "mason", "NvimTree" },
      }
    end,
  },
  {
    "xorid/swap-split.nvim",
    config = function()
      require("swap-split").setup {}
    end,
  },
  {
    "Wansmer/sibling-swap.nvim",
    config = function()
      require("sibling-swap").setup {
        highlight_node_at_cursor = true,
      }
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup {}
    end,
  },
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "hashivim/vim-terraform",
    ft = { "hcl", "tf", "tfvars", "terraformrc", "tfstate" },
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require "notify"
    end,
  },
  {
    "sindrets/winshift.nvim",
  },
  {
    "axieax/urlview.nvim",
    config = function()
      require("urlview").setup {
        default_picker = "telescope",
      }
    end,
  },
  {
    "chrishrb/gx.nvim",
    event = { "BufEnter" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true, -- default settings
  },
  {
    "tweekmonster/startuptime.vim",
    cmd = "StartupTime",
  },
  {
    "akinsho/nvim-toggleterm.lua",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup {
        open_mapping = [[<c-space>]],
        direction = "vertical",
        size = 100,
      }
    end,
  },
  {
    "jghauser/mkdir.nvim",
  },
  {
    "folke/persistence.nvim",
    config = function()
      require("persistence").setup()
    end,
  },
  {
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup {}
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-i>",
            accept_word = "<Tab>",
          },
        },
      }
    end,
  },
  {
    "almo7aya/openingh.nvim",
  },
  {
    "stevearc/overseer.nvim",
    opts = {},
    event = "VeryLazy",
  },
}, {
  defaults = {
    lazy = true,
  },
}) --
-- {
--   "VonHeikemen/fine-cmdline.nvim",
--   requires = { "MunifTanjim/nui.nvim" },
-- }

-- use {
--   "xiyaowong/nvim-transparent",
--   config = function()
--     -- require("transparent").setup {}
--   end,
-- }
