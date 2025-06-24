return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      require('telescope').setup({})

      local keymap = vim.keymap
      local builtin = require('telescope.builtin')

      keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Fuzzy find files in cwd" })

      keymap.set("n", "<leader>pr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
      keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Find string in cwd" })

      keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Find string under cursor in cwd" })

      keymap.set('n', '<C-p>', builtin.git_files, { desc = "Fuzzy find only git files" })
      keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "List available help tags" })

      keymap.set('n', '<leader>pws', function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end)

      keymap.set('n', '<leader>pWs', function()
          local word = vim.fn.expand("<cWORD>")
          builtin.grep_string({ search = word })
      end)

      -- Alternative grep string search
      keymap.set('n', '<leader>pgs', function()
          builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)

    end
}