return {
  {
    "jakewvincent/mkdnflow.nvim",
    -- enabled = true,
    config = function()
      require("mkdnflow").setup({
        modules = { completion = true },
        links = {
          conceal = true,
          transform_on_create = function(text)
            text = text:gsub(" ", "-")
            text = text:lower()
            return text
          end,
        },
        path_resolution = {
          primary = "root",
          root_marker = "index.md",
          -- sync_cwd = true,
        },
        new_file_template = {
          enabled = true,
          template = "# {{ title }}",
          --           template = [[---
          -- title: "{{title}}"
          -- description: ""
          -- tags:
          -- ---]],
        },
      })
    end,
    ft = { "markdown" },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "mkdnflow" },
        providers = {
          mkdnflow = {
            name = "Mkdnflow",
            module = "mkdnflow.completion.blink",
          },
        },
      },
    },
  },
}
