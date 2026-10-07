return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    code = {
      style = "full",
      sign = false,
      border = "thin",
      left_pad = 1,
      right_pad = 1,
    },
    pipe_table = {
      enabled = true,
      render_modes = false,
      cell = "padded",
      wrap = true,
      cell_offset = function()
        return 0
      end,
      padding = 1,
      min_width = 0,
      border_enabled = true,
      border_virtual = false,
      alignment_indicator = "━",
      head = "RenderMarkdownTableHead",
      row = "RenderMarkdownTableRow",
      style = "full",
    },
    heading = {
      sign = false,
      border = true,
      below = "▔",
      above = "▁",
      left_pad = 0,
      position = "left",
      icons = {
        "█ ",
        "██ ",
        "███ ",
        "████ ",
        "█████ ",
        "██████ ",
      },
    },
    checkbox = {
      enabled = true,
    },
  },
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
}
