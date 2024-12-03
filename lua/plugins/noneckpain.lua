return {
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    keys = { { "<leader>np", ":NoNeckPain<CR>", desc = "No Neck Pain" } },
    opts = {
      width = 150,
      buffers = {
        scratchPad = {
          -- set to `false` to
          -- disable auto-saving
          enabled = true,
          -- set to `nil` to default
          -- to current working directory
          location = "~/Documents/",
        },
        bo = {
          filetype = "md",
        },
      },
    },
  },
}
