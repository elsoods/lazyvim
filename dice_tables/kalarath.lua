-- ~/.config/nvim/dice_tables/kal-arath.lua
-- Every file returns { table_name = { ... }, ... }
return {
  -- likely = 2d6 keep highest, unlikely = 2d6 keep lowest, extreme_* = 3d6
  -- e.g. :DiceTable oracle unlikely
  oracle = {
    entries = { "No, and", "No", "No, but", "Yes, but", "Yes", "Yes, and" },
    modes = {
      likely = "h",
      unlikely = "l",
      extreme_likely = "h3",
      extreme_unlikely = "l3",
    },
  },
}
