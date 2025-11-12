return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "folke/snacks.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  -- init = function()
  --   -- delete lazygit keymap for file history
  --   vim.api.nvim_create_autocmd("User", {
  --     pattern = "LazyVimKeymaps",
  --     once = true,
  --     callback = function()
  --       pcall(vim.keymap.del, "n", "<leader>gg")
  --     end,
  --   })
  -- end,
}
