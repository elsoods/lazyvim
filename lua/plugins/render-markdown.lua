return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "quarto" },
    config = function()
      require("render-markdown").setup({
        render_modes = true,
        preset = "obsidian",
      })
    end,
  },
}
