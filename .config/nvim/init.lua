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
  return keymap("n", key, cmd, opts)
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
map("gj", "<cmd>lua require'hop'.hint_char1({ current_line_only = false, multi_windows = true })<cr>", {})
map("gk", "<cmd>lua require'hop'.hint_char2({ current_line_only = false, multi_windows = true })<cr>", {})
map("gl", "<cmd>lua require'hop'.hint_lines({ current_line_only = false, multi_windows = true })<cr>", {})
map(
  "f",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
  {}
)
map(
  "F",
  "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
  {}
)
-- https://github.com/phaazon/hop.nvim/issues/191
omap("t", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>", {})
omap("T", "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>", {})

-- insert/command
icnoremap("<C-b>", "<Left>", { silent = false })
icnoremap("<C-f>", "<Right>", { silent = false })
icnoremap("<C-d>", "<Del>", { silent = false })

-- command
cnoremap("<C-p>", "<Up>", { silent = false })

require "plugins"
-- cmd "hi Normal ctermbg=none"
-- cmd "hi SignColumn ctermbg=none"
