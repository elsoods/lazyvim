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
    -- Lazyvim Colorscheme fix
    config = function(_, opts)
      require("lualine").setup(opts)

      local function fix_statusline_leak()
        local ok, lualine_hl = pcall(vim.api.nvim_get_hl, 0, { name = "lualine_c_normal" })
        if not ok or not lualine_hl.bg then
          return
        end
        vim.api.nvim_set_hl(0, "StatusLine", { bg = lualine_hl.bg, fg = lualine_hl.fg })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = lualine_hl.bg, fg = lualine_hl.fg })
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("FixStatuslineLeak", { clear = true }),
        callback = fix_statusline_leak,
      })

      -- Apply immediately too, since ColorScheme may have already fired before this ran
      fix_statusline_leak()
    end,
  },
}
