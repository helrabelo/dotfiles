-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set leader key (space is the default in LazyVim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic options
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Clipboard - use system clipboard
vim.opt.clipboard = "unnamedplus"
