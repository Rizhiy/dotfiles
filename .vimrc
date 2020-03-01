set encoding=utf-8

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/config/Vundle.vim
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
map <C-o> :NERDTreeToggle<CR>
" Git status
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Scheme
Plugin 'vim-airline/vim-airline'
" Fzf
set rtp+=~/config/fzf
Plugin 'junegunn/fzf.vim'
" Useful file operations
Plugin 'tpope/vim-eunuch'
" Comments
Plugin 'preservim/nerdcommenter'
" Indent guide
Plugin 'Yggdroot/indentLine'
" Tmux config help
Plugin 'tmux-plugins/vim-tmux'
" Reload after reboot
Plugin 'tpope/vim-obsession'

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

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

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
nnoremap <Leader>e :tabnew $MYVIMRC<CR>
" Reload vimrc
nnoremap <Leader>r :source $MYVIMRC<CR>

" show tab and eol
set list
set listchars=tab:▸\ ,trail:·

" swap directory
set directory=/tmp

" use system clipboard
set clipboard=unnamedplus
