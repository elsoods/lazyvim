local function lonelog_threads()
  Snacks.picker({
    title = "Lonelog Threads",
    cwd = vim.fn.getcwd(),
    all = false, -- false: latest state per thread, true: every occurrence
    preview = "file",

    finder = function(o)
      local res = vim
        .system({
          "rg",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--color=never",
          "--sort=path",
          "-o",
          "-g",
          "*.md",
          "\\[#?Thread:[^\\]]*\\]",
          o.cwd,
        }, { text = true })
        :wait()

      local all_items, latest, counts = {}, {}, {}
      for line in vim.gsplit(res.stdout or "", "\n", { trimempty = true }) do
        local file, lnum, col, tag = line:match("^(.-):(%d+):(%d+):(.*)$")
        if file then
          local is_ref = tag:sub(2, 2) == "#"
          local inner = tag:match("^%[#?Thread:(.*)%]$") or ""
          local name, state = inner:match("^([^|]*)|?(.*)$")
          name, state = vim.trim(name), vim.trim(state)
          if state == "" then
            state = is_ref and "ref" or "?"
          end

          local item = {
            file = file,
            pos = { tonumber(lnum), tonumber(col) - 1 },
            name = name,
            state = state,
          }
          item.text = ("%s %s %s"):format(state, name, vim.fn.fnamemodify(file, ":."))

          counts[name] = (counts[name] or 0) + 1
          all_items[#all_items + 1] = item
          if not is_ref then
            latest[name] = item
          end
        end
      end

      if o.all then
        return all_items
      end

      local items = {}
      for name, item in pairs(latest) do
        item.count = counts[name]
        items[#items + 1] = item
      end
      local done = { closed = true, abandoned = true }
      table.sort(items, function(a, b)
        local da, db = done[a.state:lower()] or false, done[b.state:lower()] or false
        if da ~= db then
          return not da
        end
        return a.name:lower() < b.name:lower()
      end)
      return items
    end,

    format = function(item)
      local hl = ({
        open = "DiagnosticWarn",
        closed = "DiagnosticOk",
        abandoned = "Comment",
      })[item.state:lower()] or "Special"
      local ret = {
        { ("%-10s"):format(item.state), hl },
        { item.name, "Title" },
      }
      if item.count then
        ret[#ret + 1] = { ("  x%d"):format(item.count), "Comment" }
      end
      ret[#ret + 1] = {
        ("  %s:%d"):format(vim.fn.fnamemodify(item.file, ":."), item.pos[1]),
        "Comment",
      }
      return ret
    end,

    actions = {
      toggle_all = function(picker)
        picker.opts.all = not picker.opts.all
        picker:find()
      end,
    },
    win = {
      input = { keys = { ["<a-a>"] = { "toggle_all", mode = { "i", "n" } } } },
    },
  })
end

return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>fl", lonelog_threads, desc = "Lonelog threads" },
  },
}
