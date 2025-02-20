return {
  -- add gruvbox
  {
    "scottmckendry/cyberdream.nvim",
    init = function()
      require("cyberdream").setup({
        italic_comments = true,
        borderless_pickers = true,
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
    },
  },
  {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    opts = { variant = "oled" },
  },
  {
    "mellow-theme/mellow.nvim",
    lazy = false,
    priority = 1000,
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
