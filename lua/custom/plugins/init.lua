-- custom plugins
vim.opt.relativenumber = true
-- tinymist for typst
vim.lsp.config['tinymist'] = {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  settings = {
    -- ...
  },
}
return {}
