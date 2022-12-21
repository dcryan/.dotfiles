local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', builtin.find_files, { noremap = true })
vim.keymap.set('n', '<leader>f', builtin.live_grep, { noremap = true })
vim.keymap.set('n', '<leader>F', builtin.grep_string, { noremap = true })
vim.keymap.set('n', '<leader>b', builtin.buffers, { noremap = true })
vim.keymap.set('n', '<leader>h', builtin.help_tags, { noremap = true })
