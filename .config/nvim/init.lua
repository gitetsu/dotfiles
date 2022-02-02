local status, result = pcall(function()
  require "impatient"
end)

local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local execute = vim.api.nvim_command
local fn = vim.fn

-- edit
local indent = 2
opt.expandtab = true
opt.tabstop = indent
opt.shiftwidth = indent
opt.cindent = true
opt.hidden = true
opt.nrformats = ""
opt.completeopt = "menuone,noselect"

-- display
opt.list = true
opt.listchars = "tab:▸ ,extends:_,trail:-,eol:↩"
opt.signcolumn = "yes"
opt.wrap = false
opt.termguicolors = true

cmd "au TextYankPost * lua vim.highlight.on_yank {on_visual = false}"

-- search
opt.ignorecase = true
opt.smartcase = true

opt.splitright = true

-- cmd
opt.wildmode = "longest,full"

vim.g.mapleader = " "

local function map(mode, key, cmd, opts, defaults)
  opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})
  vim.api.nvim_set_keymap(mode, key, cmd, opts)
end

local function icnoremap(key, cmd, opts)
  return map("!", key, cmd, opts, { noremap = true })
end

icnoremap("<C-b>", "<Left>", { silent = false })
icnoremap("<C-f>", "<Right>", { silent = false })
icnoremap("<C-d>", "<Del>", { silent = false })

require "plugins"
-- cmd "hi Normal ctermbg=none"
-- cmd "hi SignColumn ctermbg=none"
