return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
            -- fmt = function(mode)
            --   return mode:lower()
            -- end,
            color = function(section)
              local enable_mode_colors = true
              if not enable_mode_colors then
                return nil
              end
              local currMode = vim.fn.mode()

              --require 'notify'(currMode)

              if currMode == "n" then
                return { bg = "#3fc5b7", fg = "#282828" }
              elseif currMode == "i" then
                return { bg = "#83c746", fg = "#282828" }
              elseif currMode == "v" then
                return { bg = "#eb6eb7", fg = "#282828" }
              elseif currMode == "V" then
                return { bg = "#eb6eb7", fg = "#282828" }
              elseif currMode == "\22" then
                return { bg = "#eb6eb7", fg = "#282828" }
              elseif currMode == "c" then
                return { bg = "#e67f43", fg = "#282828" }
              elseif currMode == "t" then
                return { bg = "#e67f43", fg = "#282828" }
              elseif currMode == "r" then
                return { bg = "#ed4a46", fg = "#282828" }
              end
            end,
          },
        },
        lualine_z = {},
      },
      options = {
        -- section_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- component_separators = { left = "|", right = "|" },
        component_separators = { left = "|", right = "|" },
        theme = "auto",
      },
    },
  },
}
