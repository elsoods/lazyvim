local M = {}

local root = vim.fn.expand("~/Documents/notes/wiki")
local template = root .. "/templates/daily.md"
local dir = root .. "/daily"

local function shift(base, days)
  return os.time({ year = base.year, month = base.month, day = base.day + days, hour = 12 })
end

-- Date of the current buffer if it's a daily note, otherwise today
local function base_date()
  local y, m, d = vim.fn.expand("%:t"):match("^(%d+)-(%d+)-(%d+)%.md$")
  if y then
    return { year = tonumber(y), month = tonumber(m), day = tonumber(d) }
  end
  return os.date("*t")
end

function M.open(offset, from_today)
  local base = from_today and os.date("*t") or base_date()
  local ts = shift(base, offset or 0)
  local fmt = "%Y-%m-%d"
  local path = string.format("%s/%s.md", dir, os.date(fmt, ts))

  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(dir, "p")
    local subs = {
      date = os.date(fmt, ts),
      weekday = os.date("%A", ts),
      prev = os.date(fmt, shift(os.date("*t", ts), -1)),
      next = os.date(fmt, shift(os.date("*t", ts), 1)),
    }
    local lines = vim.fn.readfile(template)
    for i, line in ipairs(lines) do
      lines[i] = line:gsub("{{(%w+)}}", function(k)
        return subs[k]
      end)
    end
    vim.fn.writefile(lines, path)
  end

  vim.cmd.edit(vim.fn.fnameescape(path))
end

return M
