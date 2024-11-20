return {
  -- add gruvbox
  {
    "scottmckendry/cyberdream.nvim",
    init = function()
      require("cyberdream").setup({
        italic_comments = true,
      })
    end,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
