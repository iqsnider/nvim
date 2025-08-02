-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
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
