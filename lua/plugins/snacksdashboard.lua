return {
  "folke/snacks.nvim",
  init = function()
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { link = "Special" })
  end,
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = [[
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
]],
      },
      formats = {
        header = {
          align = "center",
        },
      },
      sections = {
        {
          section = "header",
          padding = 4,
        },
        { section = "keys", gap = 1, padding = 2 },
        { section = "startup" },
      },
    },
  },
}
