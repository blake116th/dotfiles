local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- relative linenumber (hybrid)
vim.api.nvim_command('set number relativenumber')

function FormatWithBlack()
    -- Save the current cursor position
    local saved_view = vim.fn.winsaveview()

    -- Format the buffer with black
    vim.api.nvim_command('silent! %!black - 2> /dev/null')

    -- Restore the saved cursor position
    vim.fn.winrestview(saved_view)
end

function FormatWithSQLFluff()
    -- Save the current cursor position
    local saved_view = vim.fn.winsaveview()

    -- Format the buffer with black
    vim.api.nvim_command('silent! %!sqlfluff fix --dialect postgres - 2> /dev/null')

    -- Restore the saved cursor position
    vim.fn.winrestview(saved_view)
end

-- automatically format python buffers when saved
vim.api.nvim_command('autocmd BufWritePre *.py lua FormatWithBlack()')

-- automatically format sql buffers when saved (ASSUMES POSTGRES DIALECT!)
vim.api.nvim_command('autocmd BufWritePre *.sql lua FormatWithSQLFluff()')

-- same thing for html (seems to botch jinja templates)
-- vim.api.nvim_command('autocmd BufWritePre *.html silent! %!tidy -i --tidy-mark no --show-body-only yes 2> /dev/null')

-- disable linenumbers for terminal mode
vim.api.nvim_command('autocmd TermOpen * setlocal nonumber norelativenumber')

-- highlight current line
vim.api.nvim_command('set cursorline')

-- copy / paste from system clipboard
vim.api.nvim_command('set clipboard+=unnamedplus')

-- a tabstop should be 4 spaces
vim.api.nvim_command('set tabstop=4')
-- > button uses 4 spaces of width
vim.api.nvim_command('set shiftwidth=4')
-- a tab expands to 4 spaces when typed
vim.api.nvim_command('set expandtab')

-- for html buffers make tabstop 2
vim.api.nvim_command('autocmd BufNew *.html setlocal tabstop=2 shiftwidth=2')

-- a tab expands to 4 spaces when typed
vim.api.nvim_command('tnoremap <Esc> <C-\\><C-n>')

-- Setup lazy.nvim
require("lazy").setup({
	spec = { { import = 'plugins' } },
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "gruvbox" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

local lsp = require 'lspconfig'
local coq = require 'coq'

lsp.pyright.setup(coq.lsp_ensure_capabilities())
lsp.lua_ls.setup(coq.lsp_ensure_capabilities({
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
		},
	},
}))

lsp.tailwindcss.setup(coq.lsp_ensure_capabilities())

vim.g.coq_settings.clients = {
		lsp = {
				always_on_top = {} -- lsp results should always be on top
		}
}

-- set theme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

require('lualine').setup()

vim.opt.termguicolors = true
require("bufferline").setup {}

local builtin = require('telescope.builtin')

require('leap').create_default_mappings()

-- search current directory
vim.keymap.set('n', '<leader>.', builtin.find_files, {})

vim.keymap.set('n', '<leader>ff', builtin.git_files, {})

-- grep current directory
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- search open buffers
vim.keymap.set('n', '<leader><space>', builtin.buffers, {})

-- search help
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- ctrl + j does the opposite of J (inserts newline)
vim.keymap.set('n', '<c-j>', 'i<cr><esc>', {})

-- save buffer
vim.keymap.set('n', '<leader>bs', '<cmd>w<cr>', {})

-- clear highlights
vim.keymap.set('n', '<leader>h', '<cmd>noh<cr>', {})

-- goto prev and next errors
vim.keymap.set('n', '<leader>xn', function() vim.diagnostic.goto_next() end , {})
vim.keymap.set('n', '<leader>xp', function() vim.diagnostic.goto_prev() end, {})

-- make it easier to move windows with leader + hjkl
vim.keymap.set('n', '<leader>h', '<c-w>h', {})
vim.keymap.set('n', '<leader>j', '<c-w>j', {})
vim.keymap.set('n', '<leader>k', '<c-w>k', {})
vim.keymap.set('n', '<leader>l', '<c-w>l', {})


-- kill buffer but not window
vim.keymap.set('n', '<leader>bd', '<cmd>bp<bar>sp<bar>bn<bar>bd<CR>', {})

-- format buffer with :Format
vim.api.nvim_create_user_command('Format', function()
	vim.lsp.buf.format()
end, {})

vim.cmd([[
if has('wsl')
    let g:clipboard = {
          \   'name': 'wslclipboard',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 1,
          \ }
endif
]])

-- switch to adjacent buffers
vim.keymap.set('n', 'gp', ':bprevious<cr>', { silent = true })
vim.keymap.set('n', 'gn', ':bnext<cr>', { silent = true })
