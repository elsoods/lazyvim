return {
  {
    "nvim-zh/colorful-winsep.nvim",
    config = function()
      require("colorful-winsep").setup({
        border = "single",
      })
    end,
    event = { "WinLeave" },
  },
}
