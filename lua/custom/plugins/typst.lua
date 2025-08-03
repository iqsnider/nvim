return {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  version = '1.*',
  build = function()
    require('typst-preview').update()
  end,
  opts = {
    follow_cursor = true,
    open_cmd = nil, -- default browse
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
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              local option = selection.value
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

    -- Telescope picker for export options
    local function typst_export_picker()
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local conf = require('telescope.config').values
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      local export_options = {
        { name = 'PDF', ext = 'pdf', desc = 'Export to PDF' },
        { name = 'SVG', ext = 'svg', desc = 'Export to SVG' },
        { name = 'PNG', ext = 'png', desc = 'Export to PNG' },
        { name = 'HTML', ext = 'html', desc = 'Export to HTML' },
      }

      pickers
        .new({}, {
          prompt_title = 'Export Typst Document',
          finder = finders.new_table {
            results = export_options,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry.name .. ' - ' .. entry.desc,
                ordinal = entry.name,
              }
            end,
          },
          sorter = conf.generic_sorter {},
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              local option = selection.value

              -- Get current file name without extension
              local current_file = vim.fn.expand '%:r' -- removes extension
              local output_file = current_file .. '.' .. option.ext
              local input_file = vim.fn.expand '%' -- current file with extension

              -- Run typst compile command
              local cmd = string.format('typst compile %s %s', input_file, output_file)
              vim.fn.system(cmd)

              -- Show result
              print(string.format('Exported to: %s', output_file))
            end)
            return true
          end,
        })
        :find()
    end

    -- Create commands
    vim.api.nvim_create_user_command('TypstPreviewSelect', typst_preview_picker, {})
    vim.api.nvim_create_user_command('TypstExport', typst_export_picker, {})

    -- Create keybindings
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'typst',
      callback = function()
        vim.keymap.set('n', '<leader>tp', ':TypstPreviewSelect<CR>', { desc = 'Select Typst Preview Method' })
        vim.keymap.set('n', '<leader>te', ':TypstExport<CR>', { desc = 'Export Typst Document' })
      end,
    })
  end,
}
