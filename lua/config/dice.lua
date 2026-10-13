-- ~/.config/nvim/lua/config/dice.lua
-- Simple, configurable dice roller for Neovim.
--
--   :Dice 2d6+3       roll an expression   (d% = d100, kh/kl supported: 4d6kh3)
--   :DiceTable name   roll on a custom table (no name -> picker)
--   Add ! to any command to insert the result at the cursor instead of notifying.

local M = {}

local uv = vim.uv or vim.loop

M.config = {
  tables = {}, -- inline tables (optional)
  tables_dir = vim.fn.stdpath("config") .. "/dice_tables", -- *.lua files, one per game/system
  title = "Dice",
  output = "float", -- "float" (stays until closed) | "notify"
  notify_timeout = 15000, -- ms, only used when output = "notify"
  history_size = 100,
}

local history = {}

---------------------------------------------------------------------------
-- Expression parsing / rolling
---------------------------------------------------------------------------

-- Supports: NdS, dS, d%, optional keep highest/lowest (kh3 / kl1), optional +/-N
local function parse(expr)
  local s = expr:lower():gsub("%s+", ""):gsub("d%%", "d100")
  local n, sides, rest = s:match("^(%d*)d(%d+)(.*)$")
  if not sides then
    return nil, "invalid dice expression: " .. expr
  end
  n = tonumber(n) or 1
  sides = tonumber(sides)
  if n < 1 or n > 1000 or sides < 1 then
    return nil, "dice count or sides out of range: " .. expr
  end

  local keep, kn
  local mode, cnt, tail = rest:match("^k([hl])(%d+)(.*)$")
  if mode then
    keep, kn, rest = mode, tonumber(cnt), tail
  end

  local mod = 0
  if rest ~= "" then
    if not rest:match("^[+-]%d+$") then
      return nil, "invalid modifier in: " .. expr
    end
    mod = tonumber(rest)
  end

  return { n = n, sides = sides, keep = keep, kn = kn, mod = mod }
end

local function fmt_list(t)
  return "[" .. table.concat(t, ", ") .. "]"
end

--- Roll an expression. Returns { total = n, text = "..." } or nil, err
function M.roll(expr)
  local p, err = parse(expr)
  if not p then
    return nil, err
  end

  local rolls = {}
  for i = 1, p.n do
    rolls[i] = math.random(p.sides)
  end

  local kept = rolls
  if p.keep then
    local sorted = vim.deepcopy(rolls)
    table.sort(sorted, function(a, b)
      if p.keep == "h" then
        return a > b
      end
      return a < b
    end)
    kept = {}
    for i = 1, math.min(p.kn, #sorted) do
      kept[i] = sorted[i]
    end
  end

  local total = p.mod
  for _, v in ipairs(kept) do
    total = total + v
  end

  local text = fmt_list(rolls)
  if p.keep then
    text = text .. " keep " .. fmt_list(kept)
  end
  if p.mod ~= 0 then
    text = text .. string.format(" %s%d", p.mod > 0 and "+" or "-", math.abs(p.mod))
  end

  return { total = total, text = string.format("%s -> %s = %d", expr, text, total) }
end

---------------------------------------------------------------------------
-- Tables
---------------------------------------------------------------------------
-- A table looks like one of:
--   { entries = { "a", "b", "c" } }                      -- rolls 1d3
--   { dice = "1d100", entries = { {1,60,"Rat"}, {61,100,"Wolf"} } }
--   An entry's text may also be a function returning a string.

local function normalize(t)
  local ranges, max = {}, 0
  for i, e in ipairs(t.entries or {}) do
    if type(e) == "table" and type(e[1]) == "number" then
      ranges[#ranges + 1] = { e[1], e[2] or e[1], e[3] }
      max = math.max(max, e[2] or e[1])
    else
      ranges[#ranges + 1] = { i, i, e }
      max = math.max(max, i)
    end
  end
  return ranges, t.dice or ("1d" .. max)
end

local function table_names()
  local names = vim.tbl_keys(M.config.tables)
  table.sort(names)
  return names
end

-- mode: nil (plain roll), "h" / "l" (2 dice, keep highest / lowest),
-- "h3" / "l3" (3 dice, ...), or a name defined in the table's `modes`.
function M.roll_table(name, mode)
  local t = M.config.tables[name]
  if not t then
    return nil, "no such table: " .. tostring(name)
  end
  local ranges, dice = normalize(t)
  local label = ""
  if mode and mode ~= "" then
    local m = (t.modes and t.modes[mode]) or mode
    local dir, count = m:lower():match("^([hl])(%d*)$")
    if not dir then
      return nil, "unknown mode: " .. mode
    end
    local sides = dice:match("^1d(%d+)$")
    if not sides then
      return nil, "keep modes need a table that rolls a single 1dN"
    end
    dice = string.format("%dd%dk%s1", tonumber(count) or 2, sides, dir)
    label = " (" .. mode .. ")"
  end
  local r, err = M.roll(dice)
  if not r then
    return nil, err
  end
  for _, e in ipairs(ranges) do
    if r.total >= e[1] and r.total <= e[2] then
      local text = e[3]
      if type(text) == "function" then
        text = text()
      end
      return string.format("%s%s: %s => %s", name, label, r.text, tostring(text))
    end
  end
  return string.format("%s%s: %s => (no entry for this result)", name, label, r.text)
end

---------------------------------------------------------------------------
-- Output
---------------------------------------------------------------------------

-- Floating window that stays open until you close it (q / <Esc> / <CR>)
local function float(lines, title)
  -- Buffer holds the raw text (no padding), so yanks contain only the result.
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local width = #title + 4
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l) + 2)
  end
  width = math.min(width, vim.o.columns - 4)
  local height = math.max(1, math.min(#lines, vim.o.lines - 6))

  -- Make every yank charwise so `p` pastes right after the cursor
  -- instead of on a new line below it.
  vim.api.nvim_create_autocmd("TextYankPost", {
    buffer = buf,
    callback = function()
      local ev = vim.v.event
      if ev.regtype ~= "V" then
        return
      end
      local text = ev.regcontents
      local regs = { '"', "0" }
      if ev.regname ~= "" then
        table.insert(regs, ev.regname)
      end
      local cb = vim.o.clipboard
      if cb:find("unnamedplus") then
        table.insert(regs, "+")
      end
      if cb:find("unnamed[^p]") or cb:match("unnamed$") then
        table.insert(regs, "*")
      end
      for _, r in ipairs(regs) do
        vim.fn.setreg(r, text, "c")
      end
    end,
  })

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
    footer = " q close ",
    footer_pos = "center",
  })

  vim.wo[win].foldcolumn = "1" -- left margin without adding text to the buffer

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  for _, key in ipairs({ "q", "<Esc>", "<CR>" }) do
    vim.keymap.set("n", key, close, { buffer = buf, nowait = true })
  end
  vim.api.nvim_create_autocmd("WinLeave", { buffer = buf, once = true, callback = close })
end

local function emit(lines, insert)
  if type(lines) == "string" then
    lines = { lines }
  end

  for _, l in ipairs(lines) do
    table.insert(history, os.date("%H:%M:%S") .. "  " .. l)
  end
  while #history > M.config.history_size do
    table.remove(history, 1)
  end

  if insert then
    vim.api.nvim_put(lines, #lines > 1 and "l" or "c", true, true)
  elseif M.config.output == "notify" then
    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
      title = M.config.title,
      timeout = M.config.notify_timeout,
    })
  else
    float(lines, M.config.title)
  end
end

function M.show_history()
  if #history == 0 then
    return vim.notify("no rolls yet", vim.log.levels.INFO, { title = M.config.title })
  end
  local rev = {}
  for i = #history, 1, -1 do
    rev[#rev + 1] = history[i]
  end
  float(rev, M.config.title .. " history")
end

local function fail(err)
  vim.notify(err, vim.log.levels.WARN, { title = M.config.title })
end

---------------------------------------------------------------------------
-- Public actions
---------------------------------------------------------------------------

function M.do_roll(expr, insert)
  local r, err = M.roll(expr)
  if not r then
    return fail(err)
  end
  emit(r.text, insert)
end

function M.do_table(name, insert, mode)
  if name and name ~= "" then
    local res, err = M.roll_table(name, mode)
    return res and emit(res, insert) or fail(err)
  end
  local names = table_names()
  if #names == 0 then
    return fail("no tables configured")
  end
  vim.ui.select(names, { prompt = "Roll on table:" }, function(choice)
    if not choice then
      return
    end
    local modes = vim.tbl_keys(M.config.tables[choice].modes or {})
    if #modes == 0 then
      return M.do_table(choice, insert)
    end
    table.sort(modes)
    table.insert(modes, 1, "normal")
    vim.ui.select(modes, { prompt = choice .. " mode:" }, function(m)
      if m then
        M.do_table(choice, insert, m ~= "normal" and m or nil)
      end
    end)
  end)
end

function M.prompt(insert)
  vim.ui.input({ prompt = "Roll (e.g. 2d6+3, 4d6kh3, d%): " }, function(input)
    if input and input ~= "" then
      M.do_roll(input, insert)
    end
  end)
end

---------------------------------------------------------------------------
-- Setup
---------------------------------------------------------------------------

-- Each file in tables_dir returns { table_name = {...}, ... }.
-- Files are loaded in alphabetical order; a later duplicate name overrides an
-- earlier one (with a warning). Inline `tables` from setup() are the base.
function M.load_tables()
  local merged = vim.deepcopy(M._inline or {})
  local dir = M.config.tables_dir
  local files = dir and vim.fn.glob(dir .. "/*.lua", false, true) or {}
  table.sort(files)
  local seen = {}
  for _, f in ipairs(files) do
    local ok, res = pcall(dofile, f)
    if ok and type(res) == "table" then
      for name, t in pairs(res) do
        if seen[name] then
          fail(string.format("table '%s' in %s overrides one from %s", name, vim.fn.fnamemodify(f, ":t"), seen[name]))
        end
        seen[name] = vim.fn.fnamemodify(f, ":t")
        merged[name] = t
      end
    else
      fail("could not load " .. f .. ": " .. tostring(res))
    end
  end
  M.config.tables = merged
  return vim.tbl_count(merged)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  M._inline = M.config.tables
  M.load_tables()
  math.randomseed(os.time() + (uv.hrtime() % 1000000))
  math.random()
  math.random()
  math.random() -- warm up

  vim.api.nvim_create_user_command("Dice", function(a)
    M.do_roll(a.args ~= "" and a.args or "1d20", a.bang)
  end, { nargs = "?", bang = true, desc = "Roll dice expression (! inserts at cursor)" })

  vim.api.nvim_create_user_command("DiceReload", function()
    local n = M.load_tables()
    vim.notify(n .. " tables loaded", vim.log.levels.INFO, { title = M.config.title })
  end, { desc = "Reload tables from tables_dir" })

  vim.api.nvim_create_user_command("DiceHistory", function()
    M.show_history()
  end, { desc = "Show previous rolls" })

  vim.api.nvim_create_user_command("DiceTable", function(a)
    M.do_table(a.fargs[1], a.bang, a.fargs[2])
  end, {
    nargs = "*",
    bang = true,
    complete = function(lead, line)
      local parts = vim.split(line, "%s+")
      local candidates = table_names()
      if #parts > 2 then
        local t = M.config.tables[parts[2]]
        candidates = t and t.modes and vim.tbl_keys(t.modes) or {}
        vim.list_extend(candidates, { "h", "l", "h3", "l3" })
        table.sort(candidates)
      end
      return vim.tbl_filter(function(c)
        return c:find("^" .. vim.pesc(lead)) ~= nil
      end, candidates)
    end,
    desc = "Roll on a custom table",
  })
end

return M
