return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- opts.sections = opts.sections or {}
      -- opts.sections.lualine_c = opts.sections.lualine_c or {}
      opts.sections.lualine_a = {
        {
          "mode",
          icon = "",
          --   color = function(section)
          --     local enable_mode_colors = true
          --     if not enable_mode_colors then
          --       return nil
          --     end
          --     local currMode = vim.fn.mode()
          --     if currMode == "n" then
          --       return { bg = "#3fc5b7", fg = "#282828" }
          --     elseif currMode == "i" then
          --       return { bg = "#83c746", fg = "#282828" }
          --     elseif currMode == "v" then
          --       return { bg = "#eb6eb7", fg = "#282828" }
          --     elseif currMode == "V" then
          --       return { bg = "#eb6eb7", fg = "#282828" }
          --     elseif currMode == "\22" then
          --       return { bg = "#eb6eb7", fg = "#282828" }
          --     elseif currMode == "c" then
          --       return { bg = "#e67f43", fg = "#282828" }
          --     elseif currMode == "t" then
          --       return { bg = "#e67f43", fg = "#282828" }
          --     elseif currMode == "r" then
          --       return { bg = "#ed4a46", fg = "#282828" }
          --     end
          --   end,
        },
      }
      opts.sections.lualine_z = {}
      opts.options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
        theme = "auto",
      }
      -- table.remove(opts.sections.lualine_c)
      return opts
    end,
  },
}
