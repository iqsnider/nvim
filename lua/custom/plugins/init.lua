-- custom plugins
vim.opt.relativenumber = true
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
-- tinymist for typst
vim.lsp.config['tinymist'] = {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  settings = {
    -- ...
  },
}
return {}
