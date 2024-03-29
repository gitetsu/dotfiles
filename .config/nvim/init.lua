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
opt.pumheight = 15

cmd "au TextYankPost * lua vim.highlight.on_yank {on_visual = false}"

-- search
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true

opt.splitright = true

-- cmd
opt.wildmode = "longest,full"

vim.g.mapleader = " "

local function keymap(mode, key, cmd, opts, defaults)
  opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})
  vim.api.nvim_set_keymap(mode, key, cmd, opts)
end

local function map(key, cmd, opts)
  return keymap("", key, cmd, opts)
end

local function nmap(key, cmd, opts)
  return keymap("n", key, cmd, opts)
end

local function nnoremap(key, cmd, opts)
  return keymap("n", key, cmd, opts, { noremap = true })
end

local function omap(key, cmd, opts)
  return keymap("o", key, cmd, opts)
end

local function icnoremap(key, cmd, opts)
  return keymap("!", key, cmd, opts, { noremap = true })
end

local function cnoremap(key, cmd, opts)
  return keymap("c", key, cmd, opts, { noremap = true })
end

-- normal
nnoremap("j", "gj")
nnoremap("k", "gk")
map("gj", "<cmd>lua require'flash'.jump({search = { forward = true, wrap = true, multi_window = true }})<cr>", {})
map("gk", "<cmd>lua require('flash').treesitter({})<cr>", {})

-- insert/command
icnoremap("<C-b>", "<Left>", { silent = false })
icnoremap("<C-f>", "<Right>", { silent = false })
icnoremap("<C-d>", "<Del>", { silent = false })

-- command
cnoremap("<C-p>", "<Up>", { silent = false })

require "plugins"
-- cmd "hi Normal ctermbg=none"
-- cmd "hi SignColumn ctermbg=none"
