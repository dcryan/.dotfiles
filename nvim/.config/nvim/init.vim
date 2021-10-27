call plug#begin('~/.vim/plugged')

" Neovim lsp Plugins
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'

Plug 'mattn/emmet-vim'

" Colors
Plug 'gruvbox-community/gruvbox'

call plug#end(  )



" EDITOR SPECIFIC:

" Enable syntax and plugins (for netrw)
syntax on
filetype plugin indent on

" needs to be above `colorscheme`
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Theme and Styling
colorscheme gruvbox    " DOPE colorscheme
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_strings = 1
set background=dark    " All Black Everything

set nocompatible       " Ignore Vi compatibility
set mouse=a            " Mouse control in all modes
set backspace=2        " Enable Backspace
set smartindent        " Indent by to syntax/style of code. Use w/ autoindent
set autoindent         " Apply the indentation of the current line to the next
set shiftwidth=2       " Number of spaces when shift indenting
set tabstop=2          " Number of visual spaces per tab
set softtabstop=2      " Number of spaces in tab when editing
set expandtab smarttab " Tab to spaces
set number             " Show line numbers
set relativenumber     " Show relative line numbers
set nowrap             " Don't line wrap
set cursorline         " Highlight current line
set showmatch          " Highlight matching [{()}]
set incsearch          " Search as characters are entered
set hlsearch           " Highlight matches
set ignorecase         " Ignore case in search
set smartcase          " Override 'ignorecase' if Capital Letter exists
set noruler            " Hides line/column in the status line
set noshowmode         " Hides the mode in the status line
set hidden             " Disables confirmation of '!' on exit (e.g. :q!)
set visualbell         " Displays bell and silences the sound
set nrformats-=octal   " Removes octal from increment/decrement functionality
set completeopt=menuone,noinsert,noselect " completion-nvim
set shortmess+=c       " completion-nvim
"set omnifunc=syntaxcomplete#Complete " (disabled because of completion-nvim) Enable Omni Completion
set lazyredraw         " Lazy redraws the screen
set scrolloff=3        " Top & Bottom scroll starts X spaces away
set sidescrolloff=3    " Left & Right scroll starts X spaces away
set listchars=tab:>▸,space:·,nbsp:_ " Only show Tabs and Spaces
set nolist             " List mode: Hide/Show whitespace listchars
set noswapfile         " Don't create swapfile when executing commands
set splitbelow         " Horizontal splits open below
set splitright         " Vertical splits open right
set nobackup           " Don't save backups
set undofile           " Save undofiles for each file
set undodir=~/.vim/undodir " Where the undofiles are saved (needs to be created)



" Color the 81st Character
highlight ColorColumn ctermbg=0 guibg=lightgrey
call matchadd('ColorColumn', '\%81v', 100)



"Python Provider
let g:python3_host_prog = '/usr/bin/python3'

" FINDING FILES:

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*

" Make RipGrep search from the root of the project
if executable('rg')
  let g:rg_derive_root='true'
endif



" FILE BROWSING:

" Tweaks For Browsing:
let g:netrw_banner=0        " disable annoying banner
" let g:netrw_browse_split=2  " vertically splitting the window first
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=',\(^\|\s\s\)\zs\.\S\+'
let g:netrw_winsize=15
" nmap <LEADER>n :Lex<CR>
" nmap <LEADER>m :Vex<CR>



" SNIPPETS:
nnoremap \html :-1read $HOME/.vim/snippets/skeleton.html<CR>
nnoremap \rc :-1read $HOME/.vim/snippets/react-component.js<CR>



" WINDOW MANAGEMENT:
" Set window sizes equal
nnoremap <Leader>= :wincmd =<CR>



" MOVE LINES:
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv



" NERDTree Config:
nmap <LEADER>m :NERDTreeFind<CR>
nmap <LEADER>n :NERDTreeToggle<CR>

" autoquit if only nerdtree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif



" Completion Nvim:
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
lua require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.pyright.setup{}

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" " possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
" let g:completion_enable_snippet = 'UltiSnips'



" Telescope Nvim:
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>f <cmd>Telescope live_grep<cr>
nnoremap <leader>F <cmd>Telescope grep_string<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>t <cmd>Telescope help_tags<cr>



" Nvim LSP:
nnoremap <leader>gd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>gsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>gr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>rr :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>gh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>gca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>gsd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>

nnoremap <leader>gws :lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <leader>gf :lua vim.lsp.buf.formatting()<CR>



" ALE Linting:
let g:ale_linters = {
  \   'javascript': ['eslint'],
  \   'python': ['flake8'],
  \}
let g:ale_fixers = {
  \   'css': ['eslint'],
  \   'javascript': ['eslint', 'importjs'],
  \   'python': ['black'],
  \}
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_lint_on_text_change = 'never'

" Do not lint or fix minified files.
let g:ale_pattern_options = {
  \ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
  \ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
  \}



" VimWiki:
let g:vimwiki_list = [{
    \   'path': '~/Development/vimwiki/',
    \   'syntax': 'markdown',
    \   'ext': '.md'
    \ }]



" SHORTCUTS:

" Edit/Source the vimrc file:
nnoremap <Leader>vr :so $MYVIMRC<CR>
nnoremap <Leader>ve :tabnew $MYVIMRC<CR>

" Format JSON
autocmd FileType json nnoremap <Leader>gF :%!jq .<CR>

" hide highlighted words
nnoremap <Leader>hh :nohl<CR>

" Quickfix List Shortcuts
" nnoremap <C-k> :cnext<CR>
" nnoremap <C-j> :cprev<CR>
" nnoremap <C-e> :cclose<CR>


" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type <Leader>z to toggle highlighting on/off.
nnoremap <Leader>z :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction
