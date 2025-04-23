return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      skip_confirm_for_simple_edits = true,
      win_options = {
        wrap = true,
      },
      delete_to_trash = true,
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      { "<leader>o", "<cmd>Oil --preview <cr>", desc = "Open Oil" },
    },
  },
}
