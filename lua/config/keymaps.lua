-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p")

local wiki = vim.fn.expand("~/Documents/notes/wiki")

vim.keymap.set("n", "<leader>ww", function()
  vim.cmd("edit " .. wiki .. "/index.md")
  vim.cmd("lcd %:p:h")
end, { desc = "Open wiki index" })

local daily = require("config.daily")
vim.keymap.set("n", "<leader>jt", function()
  daily.open(0, true)
end, { desc = "Today's note" })
