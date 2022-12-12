local Remap = require("dryan.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
local vnoremap = Remap.vnoremap

-- NERDTree Config:
nnoremap("<leader>n", "<cmd>NERDTreeToggle<CR>")

-- autoquit if only nerdtree is open
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nerdtree",
  command = "if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif"
})



-- Telescope:
nnoremap("<C-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap("<leader>f", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap("<leader>F", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nnoremap("<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap("<leader>t", "<cmd>lua require('telescope.builtin').help_tags()<cr>")



-- NeoVim LSP:
nnoremap("<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
nnoremap("<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
nnoremap("<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")
nnoremap("<leader>gca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
nnoremap("<leader>gf", "<cmd>lua vim.lsp.buf.formatting()<CR>")



-- NeoVim LSP ESLint:
require("lspconfig").eslint.setup{}
local group = vim.api.nvim_create_augroup("ESLint", {clear = true})
vim.api.nvim_create_autocmd(
"BufWritePre",
{
  pattern = "*.ts,*.tsx,*.js,*.jsx",
  command = "ESLintFixAll",
  group = group
})




-- Window Management
-- Set window sizes equal
nnoremap("<leader>=", "<cmd>wincmd =<cr>")



-- hide highlighted words
nnoremap("<Leader>hh", "<cmd>nohl<CR>")



-- MOVE LINES:
nnoremap("<C-j>", ":m .+1<CR>==")
nnoremap("<C-k>", ":m .-2<CR>==")
inoremap("<C-j>", "<Esc>:m .+1<CR>==gi")
inoremap("<C-k>", "<Esc>:m .-2<CR>==gi")
vnoremap("<C-j>", ":m '>+1<CR>gv=gv")
vnoremap("<C-k>", ":m '<-2<CR>gv=gv")
