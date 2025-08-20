return {
  "petertriho/nvim-scrollbar",
  enabled = false,
  dependencies = {
    {
      "kevinhwang91/nvim-hlslens",
      config = function()
        -- require('hlslens').setup() is not required
        require("scrollbar.handlers.search").setup({
          -- hlslens config overrides
        })
      end,
    },
  },
  config = function()
    require("scrollbar").setup()
  end,
}
