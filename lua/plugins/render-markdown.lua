return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "copilot-chat", "quarto" },
    config = function()
      require("render-markdown").setup({
        -- render_modes = true,
        -- preset = "obsidian",
      })
    end,
  },
}
