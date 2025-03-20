return {
  {
    "jakewvincent/mkdnflow.nvim",
    config = function()
      local cwd = vim.fn.getcwd() -- Get the initial working directory
      local buf_path = vim.fn.expand("%:p") -- Get the absolute path of the current buffer
      local relative_path = vim.fn.relpath(buf_path, cwd) -- Calculate the relative path to the cwd
      require("mkdnflow").setup({
        perspective = {
          priority = "root",
          fallback = "current",
          root_tell = "index.md",
          nvim_wd_heel = false,
          update = true,
        },
        links = {
          style = "markdown",
          name_is_source = false,
          conceal = true,
          context = 0,
          implicit_extension = nil,
          transform_implicit = false,
          transform_explicit = function(text)
            text = text:gsub(" ", "-")
            text = text:lower()
            -- text = os.date("%Y-%m-%d_") .. text
            text = relative_path .. "/" .. text
            return text
          end,
          create_on_follow_failure = true,
        },
        new_file_template = {
          use_template = true,
          placeholders = {
            before = {
              title = "link_title",
              date = "os_date",
            },
            after = {},
          },
          template = "# {{ title }}",
        },
      })
    end,
    ft = { "markdown" },
  },
}
