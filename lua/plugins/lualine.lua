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
            color = function(section)
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
              elseif currMode == "CTRL-V" then
                return { bg = "#eb6eb7", fg = "#282828" }
              elseif currMode == "CTRL-Vs" then
                return { bg = "#eb6eb7", fg = "#282828" }
              elseif currMode == "c" then
                return { bg = "#e67f43", fg = "#282828" }
              elseif currMode == "t" then
                return { bg = "#e67f43", fg = "#282828" }
              elseif currMode == "r" then
                return { bg = "#ed4a46", fg = "#282828" }
              end
              -- return { fg = vim.bo.modified and '#aa3355' or '#33aa88' }
            end,
          },
        },
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
