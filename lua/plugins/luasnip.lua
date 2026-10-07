return {
  {
    "L3MON4D3/LuaSnip",
    keys = {
      {
        "<C-l>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end,
        mode = { "i", "s" },
        desc = "Next snippet choice",
      },
      {
        "<C-h>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(-1)
          end
        end,
        mode = { "i", "s" },
        desc = "Previous snippet choice",
      },
      {
        "<C-u>",
        function()
          if require("luasnip").choice_active() then
            require("luasnip.extras.select_choice")()
          end
        end,
        mode = { "i", "s" },
        desc = "Pick snippet choice from list",
      },
    },
    config = function()
      -- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })
      require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/lua/snippets/vscode" })
    end,
  },
}
