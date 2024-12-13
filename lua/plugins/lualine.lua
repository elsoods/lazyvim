return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
            fmt = function(mode)
              return mode:lower()
            end,
          },
        },
      },
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
    },
  },
}
