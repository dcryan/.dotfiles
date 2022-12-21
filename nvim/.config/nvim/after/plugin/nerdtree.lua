-- vim.keymap.set('n', '<leader>n', vim.cmd.NERDTreeToggle, {noremap = true})
-- vim.keymap.set('n', '<leader>m', vim.cmd.NERDTreeFind, {noremap = true})


-- -- autoquit if only nerdtree is open
-- function test()
--   print('almost')
--   if #vim.api.nvim_list_wins() == 1 then
--     print("last one")
--     vim.cmd("q")
--   end
-- end

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "nerdtree",
--   callback = test
-- })

-- -- Example of how to use the autocmd with filetypes
-- vim.api.nvim_create_autocmd('filetype', {
--   pattern = 'netrw',
--   desc = 'Better mappings for netrw',
--   callback = function()
--     local bind = function(lhs, rhs)
--       vim.keymap.set('n', lhs, rhs, {remap = true, buffer = true})
--     end

--     -- edit new file
--     bind('n', '%')

--     -- rename file
--     bind('r', 'R')
--   end
-- })
