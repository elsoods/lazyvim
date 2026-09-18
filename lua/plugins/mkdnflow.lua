return {
  {
    "jakewvincent/mkdnflow.nvim",
    enabled = false,
    config = function()
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
          template = [[---
title: "{{title}}"
description: ""
tags:
---]],
        },
      })
    end,
    ft = { "markdown" },
  },
}
