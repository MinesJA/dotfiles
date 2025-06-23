return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim",
        config = function()
          -- Disable Copilot's LSP-like features to prevent conflicts
          vim.g.copilot_filetypes = {
            ["*"] = true,
            ["rust"] = true,  -- Explicitly enable for Rust but without LSP features
          }
          -- Ensure Copilot doesn't interfere with LSP
          --vim.g.copilot_no_tab_map = true
          vim.g.copilot_assume_mapped = true
        end
      },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      debug = true,
      model = "gpt-4",
        -- Agent configuration goes inside opts
      agent = "copilot",
      agents = {
        copilot = {
          model = "gpt-4",
          system_prompt = "You are an AI assistant that can execute code and perform actions.",
        },
      },
      -- Allow code execution
      allow_insecure = true, -- Be cautious with this setting
      -- Add any other CopilotChat configuration options here}
    }
}


