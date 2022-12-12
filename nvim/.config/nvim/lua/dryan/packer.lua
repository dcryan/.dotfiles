-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use "neovim/nvim-lspconfig"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/nvim-cmp"

  use "nvim-lua/plenary.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-telescope/telescope.nvim"

  use "github/copilot.vim"

  use { 'scrooloose/nerdtree', on = 'NERDTreeToggle' }
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'

  use 'airblade/vim-gitgutter'
  use 'bronson/vim-trailing-whitespace'
  use 'dense-analysis/ale'

  -- Themes
  use 'folke/tokyonight.nvim'
end)
