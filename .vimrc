set encoding=utf-8

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

" Git
Plugin 'tpope/vim-fugitive'
" Autocomplete
Plugin 'valloric/youcompleteme'
" Git line status
Plugin 'airblade/vim-gitgutter'
" Indent guide
Plugin 'nathanaelkane/vim-indent-guides'
" Parens
Plugin 'tpope/vim-surround'
" File Tree
Plugin 'scrooloose/nerdtree'
nnoremap <leader>f :NERDTreeToggle<CR>
" Git status
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Scheme
Plugin 'vim-airline/vim-airline'
" Fzf
set rtp+=~/.local/share/fzf
Plugin 'junegunn/fzf'
" Useful file operations
Plugin 'tpope/vim-eunuch'
" Comments
Plugin 'preservim/nerdcommenter'
" Indent guide
Plugin 'Yggdroot/indentLine'
" Tmux config help
Plugin 'tmux-plugins/vim-tmux'
" Undo tree
Plugin 'mbbill/undotree'
nnoremap <leader>u :UndotreeToggle<cr>
" More languages highlighting
Plugin 'sheerun/vim-polyglot'
" Tagbar
Plugin 'majutsushi/tagbar'
nnoremap <leader>t :TagbarToggle<CR>


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Increase search
set path+=**

" Display all possible matches
set wildmenu

" Create 'tags' file
command! MakeTags !ctags -R .

" Line hybrid line numbers
set number relativenumber

" Set tab length to 4 spaces
set tabstop=4
set shiftwidth=4
" Expand tabs to spaces in python files
autocmd Filetype python setlocal expandtab

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=lastline

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif
" Highlight all matches
set hlsearch
" Remove sarch highlight
nnoremap <leader><space> :nohlsearch<CR>

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Paste without messing with indentaion
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" Disable ex mode for now
map q: <Nop>
nnoremap Q <nop>

" Edit vimjc
nnoremap <leader>e :tabnew $MYVIMRC<CR>
" Reload vimrc
nnoremap <leader>r :source $MYVIMRC<CR>

" show tab and eol
set list
set listchars=tab:▸\ ,trail:·

" swap directory
set directory=/tmp

" use system clipboard
set clipboard=unnamedplus

" Highlight current line
set cursorline

" Redraw less
set lazyredraw

" Assume terminal has fast connection
set ttyfast

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=10
nnoremap <space> za

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Run current python file
autocmd FileType python nnoremap <buffer> <leader>r :w<CR> :exec '!python' shellescape(@%, 1)

" Automatically update files
set autoread
