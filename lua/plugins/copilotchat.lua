return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options

      headers = {
        user = " You: ",
        assistant = " Copilot: ",
        tool = "🔧 Tool: ",
      },
      separator = "━━",
      mappings = {
        complete = {
          insert = "<Tab>",
        },
      },
    },
  },
}
