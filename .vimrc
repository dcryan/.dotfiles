call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'sheerun/vim-polyglot'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'
Plug 'vimwiki/vimwiki'

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
set background=dark    " All Black Everything
colorscheme gruvbox    " DOPE colorscheme
let g:gruvbox_contrast_dark = 'hard'

set nocompatible       " Ignore Vi compatibility
set mouse=a            " mouse control in all modes
set backspace=2        " Enable Backspace
set smartindent        " indent by to syntax/style of code. Use w/ autoindent
set autoindent         " apply the indentation of the current line to the next
set shiftwidth=2       " number of spaces when shift indenting
set tabstop=2          " number of visual spaces per tab
set softtabstop=2      " number of spaces in tab when editing
set expandtab smarttab " tab to spaces
set number             " show line numbers
set relativenumber     " show relative line numbers
set nowrap             " Don't line wrap
set cursorline         " highlight current line
set showmatch          " highlight matching [{()}]
set incsearch          " search as characters are entered
set hlsearch           " highlight matches
set ignorecase         " Ignore case in search
set smartcase          " Override 'ignorecase' if Capital Letter exists
set noruler            " Hides line/column in the status line
set noshowmode         " Hides the mode in the status line
set hidden             " Disables confirmation of '!' on exit (e.g. :q!)
set visualbell         " Displays bell and silences the sound
set nrformats-=octal   " Removes octal from increment/decrement functionality
set omnifunc=syntaxcomplete#Complete " Enable Omni Completion
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
let g:netrw_browse_split=0  " re-using the same window (default))
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'



" SNIPPETS:

nnoremap \html :-1read $HOME/.vim/snippets/skeleton.html<CR>
nnoremap clog <ESC>iconsole.log("");<ESC>==$hhi
inoremap clog console.log("");<ESC>hhi



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

nmap <LEADER>n :NERDTreeToggle<CR>
nmap <LEADER>m :NERDTreeFind<CR>

" autoquit if only nerdtree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif



" FZF Config:
nmap <C-p> :GFiles<CR>
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'



" COC Configs:
" GoTo Code Navigation:
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rr <Plug>(coc-rename)
nmap <leader>g[ <Plug>(coc-diagnostic-prev)
nmap <leader>g] <Plug>(coc-diagnostic-next)
nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>gn <Plug>(coc-diagnostic-next)
nnoremap <leader>cr :CocRestart

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()

" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use <Tab> and <S-Tab> to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Global Search
nnoremap <Leader>f :CocSearch <C-R><C-W>



" ALE Linting:
let g:ale_linters = {
\   'javascript': ['eslint'],
\}
let g:ale_fixers = {
\   '*' : ['importjs'],
\   'css': ['eslint'],
\   'javascript': ['eslint'],
\}
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1



" VimWiki:
let g:vimwiki_list = [{
      \   'path': '~/Development/vimwiki/',
      \   'syntax': 'markdown',
      \   'ext': '.md'
      \ }]



" SHORTCUTS:

" Edit/Source the vimrc file:
nnoremap <Leader>vr :so $MYVIMRC<CR>
"nnoremap <Leader>ve :tabnew $MYVIMRC<CR>
nnoremap <Leader>ve :tabnew $HOME/Development/dotfiles/.vimrc<CR>

" Format JSON
nnoremap <Leader>F :%!jq .<CR>

" hide hilighted words
nnoremap <Leader>hh :nohl<CR>


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
