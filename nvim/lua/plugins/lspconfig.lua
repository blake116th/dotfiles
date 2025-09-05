return {
  "neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
  lazy = false,            -- REQUIRED: tell lazy.nvim to start this plugin at startup
  dependencies = {
    -- main one
    { "ms-jpq/coq_nvim",       branch = "coq" },

    -- 9000+ Snippets
    { "ms-jpq/coq.artifacts",  branch = "artifacts" },

    -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
    -- Need to **configure separately**
    { 'ms-jpq/coq.thirdparty', branch = "3p" }
    -- - shell repl
    -- - nvim lua api
    -- - scientific calculator
    -- - comment banner
    -- - etc
  },
  init = function()
    vim.g.coq_settings = {
      auto_start = 'shut-up', -- if you want to start COQ at startup
      clients = {
        lsp = {
          always_on_top = {} -- lsp results should always be on top
        },
        snippets = { enabled = true }
      }
    }
  end,
  config = function()
    local lsp = require 'lspconfig'
    local coq = require 'coq'

    vim.lsp.config('pyright', coq.lsp_ensure_capabilities())
    vim.lsp.enable('pyright')

    vim.lsp.config('lua_ls', coq.lsp_ensure_capabilities({
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
        },
      },
      on_attach = function(_, bufnr)
        vim.bo[bufnr].expandtab   = true
        vim.bo[bufnr].tabstop     = 2
        vim.bo[bufnr].shiftwidth  = 2
        vim.bo[bufnr].softtabstop = 2
      end,
    }))
    vim.lsp.enable('lua_ls')

    -- vim.lsp.config('tailwindcss', coq.lsp_ensure_capabilities())
    -- vim.lsp.enable('tailwindcss')

    vim.lsp.config('html', coq.lsp_ensure_capabilities({
      on_attach = function(_, bufnr)
        -- use the correct tab / spaces settings
        vim.bo[bufnr].expandtab   = true
        vim.bo[bufnr].tabstop     = 2
        vim.bo[bufnr].shiftwidth  = 2
        vim.bo[bufnr].softtabstop = 2
      end,
    }))
    vim.lsp.enable('html')

    vim.lsp.config('ruby_lsp', coq.lsp_ensure_capabilities())
    vim.lsp.enable('ruby_lsp')

    -- typescript server
    vim.lsp.config('ts_ls', coq.lsp_ensure_capabilities())
    vim.lsp.enable('ts_ls')

    --eslint server (runs in parallel with typescript!)
    local base_on_attach = vim.lsp.config.eslint.on_attach

    vim.lsp.config('eslint', coq.lsp_ensure_capabilities({
      on_attach = function(client, bufnr)
        -- when eslint is attached, fix buffer on save
        if not base_on_attach then return end

        base_on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "LspEslintFixAll",
        })

        -- use the correct tab / spaces settings
        vim.bo[bufnr].expandtab   = false
        vim.bo[bufnr].tabstop     = 4
        vim.bo[bufnr].shiftwidth  = 4
        vim.bo[bufnr].softtabstop = 4
      end,
    }))

    vim.lsp.enable('eslint')
  end,
}
