local ns = vim.api.nvim_create_namespace("lonelog")

local groups = {
  LonelogAction = "Keyword", -- @ / @(Name)
  LonelogOracle = "Special", -- ?
  LonelogRoll = "Function", -- d: tbl: gen:
  LonelogResult = "Operator", -- ->
  LonelogConseq = "Statement", -- =>
  LonelogTag = "Type", -- [anything]
  LonelogScene = "Title", -- S1, S5a, T1-S2
  LonelogMeta = "Comment", -- (note: ...)
}
for g, target in pairs(groups) do
  vim.api.nvim_set_hl(0, g, { link = target, default = true })
end

-- { lua pattern, group }, matched anywhere on the line
local rules = {
  { "^%s*@%b()", "LonelogAction" },
  { "^%s*@", "LonelogAction" },
  { "^%s*%?", "LonelogOracle" },
  { "^%s*d:", "LonelogRoll" },
  { "^%s*tbl:", "LonelogRoll" },
  { "^%s*gen:", "LonelogRoll" },
  { "^%s*T%d+%-S%d+[%w%.]*", "LonelogScene" },
  { "^%s*S%d+[%w%.]*", "LonelogScene" },
  { "^%s*%(.*%)%s*$", "LonelogMeta" },
  { "%->", "LonelogResult" },
  { "=>", "LonelogConseq" },
  { "%[[^%]]*%]", "LonelogTag" },
}

local function render(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local inside = false
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if not inside then
      inside = line:match("^%s*```+lonelog%s*$") ~= nil
    elseif line:match("^%s*```+%s*$") then
      inside = false
    else
      for _, r in ipairs(rules) do
        local init = 1
        while true do
          local s, e = line:find(r[1], init)
          if not s then
            break
          end
          -- skip leading whitespace captured by ^%s* patterns
          s = line:find("%S", s) or s
          vim.api.nvim_buf_set_extmark(buf, ns, i - 1, s - 1, {
            end_col = e,
            hl_group = r[2],
            priority = 200,
          })
          init = e + 1
          if r[1]:sub(1, 1) == "^" then
            break
          end
        end
      end
    end
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("lonelog", { clear = true }),
  pattern = { "*.md", "*.markdown" },
  callback = function(ev)
    render(ev.buf)
  end,
})
