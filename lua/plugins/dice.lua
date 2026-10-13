-- ~/.config/nvim/lua/plugins/dice.lua
return {
  {
    name = "dice",
    dir = vim.fn.stdpath("config"), -- local "plugin": just loads lua/config/dice.lua
    event = "VeryLazy",
    keys = {
      {
        "<leader>Rr",
        function()
          require("config.dice").prompt()
        end,
        desc = "Roll expression",
      },
      {
        "<leader>Rt",
        function()
          require("config.dice").do_table()
        end,
        desc = "Roll on table",
      },
      {
        "<leader>Rh",
        function()
          require("config.dice").show_history()
        end,
        desc = "Roll history",
      },
      {
        "<leader>RR",
        function()
          require("config.dice").prompt(true)
        end,
        desc = "Roll expression (insert)",
      },
      {
        "<leader>RT",
        function()
          require("config.dice").do_table(nil, true)
        end,
        desc = "Roll on table (insert)",
      },
    },
    config = function()
      -- Tables live in ~/.config/nvim/dice_tables/*.lua (one file per game/system).
      -- Add or edit a file, then run :DiceReload (or restart nvim).
      require("config.dice").setup({
        -- output = "float",
        tables_dir = vim.fn.stdpath("config") .. "/dice_tables",
        -- tables = { ... },  -- inline tables also still work
      })

      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({ { "<leader>R", group = "dice" } })
      end
    end,
  },
}
