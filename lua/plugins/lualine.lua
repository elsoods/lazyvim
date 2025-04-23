return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
            -- icon = "",
            fmt = function(mode)
              return mode:lower()
            end,
          },
        },
        lualine_z = {},
      },
      options = {
        -- section_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
        theme = "auto",
      },
    },
  },
}
