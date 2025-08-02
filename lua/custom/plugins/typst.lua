return {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  version = '1.*',
  build = function()
    require('typst-preview').update()
  end,
  opts = {
    follow_cursor = true,
    open_cmd = nil, -- default to browser
  },
  config = function(_, opts)
    require('typst-preview').setup(opts)

    -- Telescope picker for preview options
    local function typst_preview_picker()
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local conf = require('telescope.config').values
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      local preview_options = {
        { name = 'Browser', cmd = nil, desc = 'Preview in default browser' },
        { name = 'Zathura', cmd = 'zathura %s', desc = 'Preview in Zathura PDF viewer' },
        { name = 'Firefox', cmd = 'firefox %s', desc = 'Preview in Firefox' },
        { name = 'Chrome', cmd = 'google-chrome %s', desc = 'Preview in Chrome' },
      }

      pickers
        .new({}, {
          prompt_title = 'Typst Preview Method',
          finder = finders.new_table {
            results = preview_options,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry.name .. ' - ' .. entry.desc,
                ordinal = entry.name,
              }
            end,
          },
          sorter = conf.generic_sorter {},
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              local option = selection.value

              -- Configure and start preview
              require('typst-preview').setup {
                open_cmd = option.cmd,
                follow_cursor = true,
              }
              vim.cmd 'TypstPreview'
            end)
            return true
          end,
        })
        :find()
    end

    -- Create the command
    vim.api.nvim_create_user_command('TypstPreviewSelect', typst_preview_picker, {})

    -- Optional: Add keybinding for typst files only
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'typst',
      callback = function()
        vim.keymap.set('n', '<leader>tp', ':TypstPreviewSelect<CR>', { desc = 'Select Typst Preview Method' })
      end,
    })
  end,
}
