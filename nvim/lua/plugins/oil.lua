return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    require("oil").setup({
      columns = {
        "permissions",
        "size",
        "mtime",
        "icon"
      },
      keymaps = {
        ["q"] = "actions.close",
      },
      float = {
        padding = 4,
        preview_split = "right",
      },
    })

    vim.keymap.set("n", "-",
      function()
        vim.cmd("Oil --float")
      end
      , { desc = "Open parent directory" })

    vim.api.nvim_create_autocmd("User", {
      pattern = "OilEnter",
      callback = vim.schedule_wrap(function(args)
        local oil = require("oil")
        if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
          oil.open_preview({ split = "botright" })
        end
      end),
    })
  end,
}
