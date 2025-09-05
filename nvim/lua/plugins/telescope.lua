return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require("telescope.builtin")

    -- search current directory
    vim.keymap.set('n', '<leader>.', builtin.find_files, {})

    vim.keymap.set('n', '<leader>ff', builtin.git_files, {})

    -- grep current directory. Autoload the '/' buffer as the default search string
    vim.keymap.set('n', '<leader>fg', function()


        -- Convert vim word boundaries to PCRE-ish word boundaries
        -- (rg uses PCRE)
        local search_regex = vim.fn.getreg("/"):gsub("\\[<>]", "\\b")

        builtin.live_grep({
          default_text = search_regex
        })
      end,
      {}
    )

    -- search open buffers
    vim.keymap.set('n', '<leader><space>', builtin.buffers, {})

    -- search help
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
  end,
}
