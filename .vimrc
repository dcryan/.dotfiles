 call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'sheerun/vim-polyglot'
Plug 'bronson/vim-trailing-whitespace'
Plug 'ycm-core/YouCompleteMe'

" Colors
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'

call plug#end(  )



" EDITOR SPECIFIC:

" Enable syntax and plugins (for netrw)
syntax on
filetype plugin indent on

" Set CursorShape for each mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" needs to be above `colorscheme`
if (has("termguicolors"))
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set nocompatible       " Ignore Vi compatibility
set mouse=a            " mouse control in all modes
set formatoptions+=j   " remove comment leaders when joining lines
set backspace=2        " Enable Backspace
set smartindent        " indent by to syntax/style of code. Use w/ autoindent
set autoindent         " apply the indentation of the current line to the next
set shiftwidth=2       " number of spaces when shift indenting
set tabstop=2          " number of visual spaces per tab
set softtabstop=2      " number of spaces in tab when editing
set expandtab smarttab " tab to spaces
set number             " show line numbers
set wrap!              " Don't line wrap
set cursorline         " highlight current line
set showmatch          " highlight matching [{()}]
set incsearch          " search as characters are entered
set hlsearch           " highlight matches
set ignorecase         " Ignore case in search
set noruler            " Hides line/column in the status line
set noshowmode         " Hides the mode in the status line
set hidden             " Disables confirmation of '!' on exit (e.g. :q!)
set visualbell         " Displays bell and silences the sound
set nrformats-=octal   " Removes octal from increment/decrement functionality
set omnifunc=syntaxcomplete#Complete " Enable Omni Completion
set lazyredraw         " Lazy redraws the screen
set scrolloff=3        " Top & Bottom scroll starts X spaces away
set listchars=tab:>▸,space:·,nbsp:_ " Only show Tabs and Spaces
set list               " List mode: Show whitespace

" Theme and Styling
set t_Co=256
set background=dark    " All Black Everything
colorscheme gruvbox    " DOPE colorscheme




" FINDING FILES:

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*


" FILE BROWSING:

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=0  " re-using the same window (default))
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" now we can:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings



" SNIPPETS:

nnoremap \html :-1read $HOME/.vim/snippets/skeleton.html<CR>
nnoremap clog <ESC>iconsole.log("")<ESC>hi



" Bracket Matching
" inoremap ( ()<ESC>i
" inoremap { {}<ESC>i
" inoremap [ []<ESC>i



" Move Lines
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv



" NERDTree Config:

nmap <LEADER>n :NERDTreeToggle<CR>

" autoquit if only nerdtree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif 


" FZF Config:
nmap <C-p> :Files<CR>
