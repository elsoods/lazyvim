-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-c>", "ciw")
-- vim.keymap.set("n", "yc", "yygccp")
vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p")
