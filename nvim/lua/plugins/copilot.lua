return {
    "zbirenbaum/copilot.lua",
    config = function()
        require('copilot').setup({
            panel = {
                keymap = {
                    open = false,
                }
            },
            suggestion = {
                keymap = {
                    accept = "<c-j>",
                    next = "<c-n>",
                    prev = "<c-p>",
                    dismiss = "<esc>",
                },
            }
        })
        vim.keymap.set('n', '<leader>ss', function() require("copilot.panel").open() end, {})
    end,
}
