return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = {"lua", "vim", "vimdoc", "luadoc", "markdown", "javascript", "html", "python", "css", "json", "requirements", "gitignore"},
          sync_install = false,
          additional_vim_regex_highlighting = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
 }
