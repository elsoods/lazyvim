return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "copilot-chat" },
    config = function()
      require("render-markdown").setup({
        -- render_modes = true,
        -- preset = "obsidian",
        heading = {
          icons = {},
        },
      })
    end,
  },
}
