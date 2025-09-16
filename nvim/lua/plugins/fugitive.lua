return {
  'tpope/vim-fugitive',
  cmd = { "Git", "G", "Gdiffsplit", "Gblame", "GBrowse", "Gread", "Gwrite", "Gmove", "Gdelete" },
  keys = {
    { "<leader>gs", "<cmd>Git<cr>",    desc = "Git status" },
    { "<leader>gb", "<cmd>Gblame<cr>", desc = "Git blame" },
  },
}
