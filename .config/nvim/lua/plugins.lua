local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
  -- https://github.com/wbthomason/packer.nvim/issues/750#issuecomment-1018881168
  vim.o.runtimepath = vim.fn.stdpath "data" .. "/site/pack/*/start/*," .. vim.o.runtimepath
end
vim.cmd [["packadd packer.nvim"]]
vim.cmd [[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

-- https://github.com/wbthomason/packer.nvim/issues/756
require("packer").init {
  max_jobs = 8,
}

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use {
    "lewis6991/impatient.nvim",
  }
  use {
    "nathom/filetype.nvim",
  }
  use {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      {
        "nvim-telescope/telescope-symbols.nvim",
      },
      {
        "benfowler/telescope-luasnip.nvim",
        module = "telescope._extensions.luasnip",
      },
      "smartpde/telescope-recent-files",
    },
    cmd = { "Telescope" },
    module = "telescope",
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      telescope.load_extension "fzf"
      telescope.load_extension "luasnip"
      telescope.load_extension "recent_files"
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
  }

  use {
    "VonHeikemen/fine-cmdline.nvim",
    requires = { "MunifTanjim/nui.nvim" },
  }

  use {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      local wk = require "which-key"
      wk.register({
        e = {
          name = "Edit",
          J = { "<cmd>lua require('trevj').format_at_cursor()<cr>", "Split into lines" },
        },
        f = {
          name = "Find",
          b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Find Buffers" },
          f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find Files" },
          F = { "<cmd>lua require('telescope.builtin').find_files({no_ignore=true})<cr>", "Find All Files" },
          g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Grep Files" },
          G = { "<cmd>lua require('telescope.builtin').live_grep({no_ignore=true})<cr>", "Grep All Files" },
          r = { "<cmd>lua require('telescope').extensions.recent_files.pick()<cr>", "Recent Files" },
          s = { "<cmd>lua require('telescope').extensions.luasnip.luasnip{}<cr>", "Find Snippets" },
          t = { "<cmd>NvimTreeFindFile<cr>", "Find In Tree" },
          T = { "<cmd>NvimTreeToggle<cr>", "Toogle Tree" },
          u = { "<cmd>UrlView<cr>", "Find URLs" },
        },
        d = {
          name = "Display",
          l = { "<cmd>:set list!<cr>" },
          p = { "<cmd>:set paste!<cr>" },
        },
        l = {
          name = "Lsp",
          a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
          d = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Go To Definition(Preview)" },
          D = { "<cmd>split | lua vim.lsp.buf.definition()<cr>", "Go To Definition(New Window)" },
          e = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Toggle lsp_lines" },
        },
        s = {
          name = "Swap",
          s = { "<cmd>lua require('iswap').iswap_with()<cr>", "Swap With This" },
          S = { "<cmd>lua require('iswap').iswap()<cr>", "Swap" },
        },
        w = {
          name = "Window",
          w = { "<cmd>WinShift<cr>", "Start Win-Move mode targeting the current window for moving" },
          s = { "<cmd>WinShift swap<cr>", "Swap the current window with another" },
        },
      }, { prefix = "<leader>" })
    end,
  }

  use {
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
  }

  use {
    "rgroli/other.nvim",
    event = "VimEnter",
    config = function()
      require("other-nvim").setup {
        mappings = {
          "rails",
        },
      }
    end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true,
      }
    end,
  }

  use {
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end,
  }

  use {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
        },
        sections = {
          lualine_b = {
            {
              "filename",
              path = 1,
            },
          },
          lualine_c = {},
          lualine_x = { "branch", "diff", "diagnostics", "encoding", "fileformat", "filetype" },
        },
      }
    end,
  }

  use {
    "xiyaowong/nvim-transparent",
    event = "BufEnter",
    config = function()
      require("transparent").setup {
        enable = true,
      }
    end,
  }

  use {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    requires = {
      "folke/lua-dev.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
          require("lspsaga").init_lsp_saga()
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
    },
    config = function()
      require("lspconfig").sumneko_lua.setup {
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
  }

  use {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    config = function()
      require("fidget").setup {}
    end,
  }

  use {
    "rmagatti/goto-preview",
    event = "VimEnter",
    config = function()
      require("goto-preview").setup {
        opacity = 10,
      }
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "windwp/nvim-ts-autotag",
      {
        "mizlan/iswap.nvim",
        config = function()
          require("iswap").setup {}
        end,
      },
      "RRethy/nvim-treesitter-endwise",
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
          "typescript",
          "yaml",
        },
        highlight = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        endwise = {
          enable = true,
        },
      }
    end,
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
  }

  use {
    "mfussenegger/nvim-treehopper",
    event = "VimEnter",
  }

  use {
    "p00f/nvim-ts-rainbow",
    event = "BufEnter",
    config = function()
      require("nvim-treesitter.configs").setup {
        rainbow = {
          enable = true,
          -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = nil, -- Do not enable for files with more than n lines, int
          -- colors = {}, -- table of hex strings
          -- termcolors = {} -- table of colour name strings
        },
      }
    end,
  }

  use {
    "m-demare/hlargs.nvim",
    event = "BufEnter",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("hlargs").setup {}
    end,
  }

  use {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup {}
    end,
  }

  use {
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc" },
    config = function()
      require("Comment").setup {}
    end,
  }

  use {
    "mvllow/modes.nvim",
    tag = "v0.2.0",
    event = "VimEnter",
    config = function()
      require("modes").setup {}
    end,
  }

  use {
    "hrsh7th/nvim-pasta",
    event = "BufEnter",
    config = function()
      vim.keymap.set({ "n", "x" }, "p", require("pasta.mappings").p)
      vim.keymap.set({ "n", "x" }, "P", require("pasta.mappings").P)
    end,
  }

  use {
    "kana/vim-smartchr",
    event = "VimEnter",
  }

  use {
    "kylechui/nvim-surround",
    tag = "*",
    event = "VimEnter",
    config = function()
      require("nvim-surround").setup {}
    end,
  }

  use {
    "johmsalas/text-case.nvim",
    event = "VimEnter",
    config = function()
      require("textcase").setup {}
    end,
  }

  use {
    "mhartington/formatter.nvim",
    event = "BufWritePre",
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
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
    event = "InsertEnter",
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
      }
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    end,
  }

  use {
    "folke/trouble.nvim",
    event = "BufReadPre",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  }

  use {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "BufEnter",
    config = function()
      vim.diagnostic.config {
        virtual_text = false,
      }
      require("lsp_lines").setup()
    end,
  }

  use {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  }

  use { "mbbill/undotree", cmd = "UndotreeToggle" }

  use {
    "phaazon/hop.nvim",
    branch = "v2",
    event = "VimEnter",
    config = function()
      require("hop").setup {}
    end,
  }

  use {
    "jinh0/eyeliner.nvim",
    event = "VimEnter",
  }

  use {
    "tversteeg/registers.nvim",
    event = "VimEnter",
    setup = function()
      vim.api.nvim_set_var("registers_delay", 500)
    end,
  }

  use {
    "gbprod/stay-in-place.nvim",
    event = "VimEnter",
    config = function()
      require("stay-in-place").setup {}
    end,
  }

  use {
    "wellle/targets.vim",
    event = "BufEnter",
  }

  use {
    "AckslD/nvim-trevJ.lua",
    module = "trevj",
    config = function()
      require("trevj").setup()
    end,
  }

  use {
    "monaqa/dial.nvim",
    event = "BufEnter",
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
  }

  use {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  }

  use {
    "famiu/nvim-reload",
    requires = { "nvim-lua/plenary.nvim" },
    event = "VimEnter",
  }

  use {
    "tomasr/molokai",
    event = "VimEnter",
  }

  use {
    "folke/tokyonight.nvim",
    event = "VimEnter",
  }

  use {
    "sainnhe/sonokai",
    event = "VimEnter",
  }

  use {
    "Yazeed1s/minimal.nvim",
    event = "VimEnter",
  }

  use {
    "catppuccin/nvim",
    as = "catppuccin",
    event = "VimEnter",
    config = function()
      require("catppuccin").setup {
        transparent_background = true,
      }
      -- [[vim.cmd "colorscheme catppuccisonokain"]]
    end,
  }

  use {
    "EdenEast/nightfox.nvim",
    event = "VimEnter",
    config = function()
      require("nightfox").setup {}
    end,
  }

  use {
    "glepnir/zephyr-nvim",
    event = "VimEnter",
  }

  use {
    "mastertinner/nvim-quantum",
    event = "VimEnter",
    config = function()
      -- require('quantum').setup {}
    end,
  }

  use {
    "marko-cerovac/material.nvim",
    event = "VimEnter",
    config = function() end,
  }

  use {
    "Th3Whit3Wolf/one-nvim",
    event = "VimEnter",
  }

  use {
    "navarasu/onedark.nvim",
    event = "BufEnter",
    config = function()
    end,
  }

  use {
    "rmehri01/onenord.nvim",
    config = function()
      vim.cmd "colorscheme onenord"
    end,
  }

  use {
    "rebelot/kanagawa.nvim",
    event = "VimEnter",
  }

  use {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
  }

  use {
    "petertriho/nvim-scrollbar",
    event = "BufReadPre",
    config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.search").setup()
    end,
  }

  use {
    "nvim-zh/colorful-winsep.nvim",
    event = "BufEnter",
    config = function()
      require("colorful-winsep").setup {
        no_exec_files = { "packer", "TelescopePrompt", "mason", "NvimTree" },
      }
    end,
  }

  use {
    "kevinhwang91/nvim-hlslens",
    event = "BufEnter",
  }

  use {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    requires = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
  }

  use {
    "hashivim/vim-terraform",
    ft = { "hcl", "tf", "tfvars", "terraformrc", "tfstate" },
  }

  use {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      vim.notify = require "notify"
    end,
  }

  use {
    "sindrets/winshift.nvim",
    event = "VimEnter",
  }

  use {
    "axieax/urlview.nvim",
    event = "VimEnter",
    config = function()
      require("urlview").setup {
        default_picker = "telescope",
      }
    end,
  }

  use {
    "tweekmonster/startuptime.vim",
    cmd = "StartupTime",
  }

  use {
    "akinsho/nvim-toggleterm.lua",
    keys = { "<C-Space>" },
    config = function()
      require("toggleterm").setup {
        open_mapping = [[<c-space>]],
        direction = "vertical",
        size = 100,
      }
    end,
  }

  use {
    "jghauser/mkdir.nvim",
    event = "VimEnter",
  }

  use {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = function()
      require("persistence").setup()
    end,
  }

  use {
    "klen/nvim-config-local",
    event = "VimEnter",
    config = function()
      require("config-local").setup {}
    end,
  }
end)
