-- ~/.config/nvim/dice_tables/generic.lua
return {
  -- Ranges + explicit dice
  encounter = {
    dice = "1d100",
    entries = {
      { 1, 50, "Nothing happens" },
      { 51, 80, "A pack of wolves" },
      { 81, 95, "A wandering merchant" },
      { 96, 100, "An ogre blocks the road" },
    },
  },

  -- Entries can be functions (nested rolls)
  loot = {
    dice = "1d6",
    entries = {
      {
        1,
        3,
        function()
          return require("config.dice").roll("2d6").text .. " copper"
        end,
      },
      { 4, 5, "A healing potion" },
      { 6, 6, "A magic trinket" },
    },
  },
}
