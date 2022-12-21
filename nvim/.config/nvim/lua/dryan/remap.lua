local Remap = require("dryan.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
local vnoremap = Remap.vnoremap


-- Window Management
-- Set window sizes equal
nnoremap("<leader>=", "<cmd>wincmd =<CR>")


-- Hide highlighted words
nnoremap("<leader>hh", "<cmd>nohl<CR>")


-- Move lines:
nnoremap("<C-j>", ":m .+1<CR>==")
nnoremap("<C-k>", ":m .-2<CR>==")
inoremap("<C-j>", "<Esc>:m .+1<CR>==gi")
inoremap("<C-k>", "<Esc>:m .-2<CR>==gi")
vnoremap("<C-j>", ":m '>+1<CR>gv=gv")
vnoremap("<C-k>", ":m '<-2<CR>gv=gv")


-- -- Netrw
-- vim.g.netrw_banner = 1
-- vim.g.netrw_winsize = 15
-- vim.g.netrw_liststyle = 3

-- nnoremap("<leader>n", "<cmd>Lex<cr>")
