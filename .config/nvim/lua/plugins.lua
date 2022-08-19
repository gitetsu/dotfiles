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
    },
    cmd = { "Telescope" },
    module = "telescope",
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      telescope.load_extension "fzf"
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
        f = {
          name = "Files",
          b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Find Buffers" },
          f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find Files" },
          F = { "<cmd>lua require('telescope.builtin').find_files({no_ignore=true})<cr>", "Find All Files" },
          g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Grep Files" },
          G = { "<cmd>lua require('telescope.builtin').live_grep({no_ignore=true})<cr>", "Grep All Files" },
          t = { "<cmd>NvimTreeFindFile<cr>", "Find In Tree" },
          T = { "<cmd>NvimTreeToggle<cr>", "Toogle Tree" },
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
      require("lspconfig").phpactor.setup {}
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
    "rmagatti/goto-preview",
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
      }
    end,
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
  }
  use {
    "p00f/nvim-ts-rainbow",
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
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("hlargs").setup {}
    end,
  }

  use {
    "lewis6991/gitsigns.nvim",
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
    "hrsh7th/nvim-pasta",
    event = "BufEnter",
    config = function()
      vim.keymap.set({ "n", "x" }, "p", require("pasta.mappings").p)
      vim.keymap.set({ "n", "x" }, "P", require("pasta.mappings").P)
    end,
  }

  use "kana/vim-smartchr"

  use {
    "ur4ltz/surround.nvim",
    config = function()
      require("surround").setup { mappings_style = "sandwich" }
    end,
  }

  use {
    "johmsalas/text-case.nvim",
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
    },
    event = "InsertEnter",
    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"
      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol_text",
          },
        },
        mapping = {
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
    "Maan2003/lsp_lines.nvim",
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
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  }

  use {
    "famiu/nvim-reload",
    requires = { "nvim-lua/plenary.nvim" },
  }

  use {
    "tomasr/molokai",
  }

  use {
    "folke/tokyonight.nvim",
  }

  use {
    "sainnhe/sonokai",
    config = [[vim.cmd "colorscheme sonokai"]],
  }

  use {
    "mhartington/oceanic-next",
  }

  use {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
  }

  use {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.search").setup()
    end,
  }

  use {
    "kevinhwang91/nvim-hlslens",
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
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      vim.notify = require "notify"
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
