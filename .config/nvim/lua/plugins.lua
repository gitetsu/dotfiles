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
      telescope.load_extension "fzf"
      telescope.setup {
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          mappings = {
            i = {
              ["<C-a>"] = {"<ESC>I", type = "command"},
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
          f = { "<cmd>Telescope find_files<cr>", "Find File" },
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
          a = {"<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action"},
          d = {"<cmd>split | lua vim.lsp.buf.definition()<cr>", "Go To Definition"},
        }
      }, { prefix = "<leader>" })
    end,
  }

  use {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeFindFile", "NvimTreeToggle", "NvimTreeClose" },
    config = function()
      vim.g.nvim_tree_quit_on_open = 1
      vim.g.nvim_tree_group_empty = 1
      require("nvim-tree").setup {
        hijack_cursor = true,
        auto_close = true,
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
      }
    end,
  }

  use { "xiyaowong/nvim-transparent" }

  use {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    requires = {
      "folke/lua-dev.nvim",
      {
        "glepnir/lspsaga.nvim",
        config = function()
          require("lspsaga").init_lsp_saga()
        end,
      },
    },
    config = function()
      require("lspconfig").phpactor.setup {}
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {},
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "dockerfile",
          "javascript",
          "json",
          "lua",
          "php",
          "ruby",
          "yaml",
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
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc" },
    config = function()
      require("Comment").setup {}
    end,
  }

  use "kana/vim-smartchr"

  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require("surround").setup { mappings_style = "surround" }
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
    },
    event = "InsertEnter",
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
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
    event = "BufReadPre",
    config = function()
      require'hop'.setup {
      }
    end
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
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    requires = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("yaml_nvim").init()
    end,
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
    keys = { "<C-y>", "<leader>fl", "<leader>gt" },
  }

  use {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = function()
      require("persistence").setup()
    end,
  }
end)
