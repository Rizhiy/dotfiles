" Update leader
let g:mapleader = " "
nnoremap <Space> <Nop>

syntax enable
set encoding=utf-8                               " The encoding displayed
set fileencoding=utf-8                           " The encoding written to file
set mouse=a                                      " Enable your mouse
set tabstop=4                                    " Insert 4 spaces for a tab
set shiftwidth=4
autocmd Filetype python setlocal expandtab       " Expand tabs to spaces in python files
autocmd Filetype javascript setlocal expandtab
set smarttab                                     " Makes tabbing smarter will realize you have 2 vs 4
set smartindent                                  " Makes indenting smart
set autoindent                                   " Good auto indent
set timeout
set timeoutlen=300                               " By default timeoutlen is 1000 ms
set wildmenu                                     " Dispay all possible matches
set ttyfast                                      " Assume terminal has fast connection
set backspace=indent,eol,start                   " Allow backspacing over everything in insert mode
set history=200                                  " keep 200 lines of command line history
set autoread                                     " Automatically update files
set spell                                        " Spell checking
set spelllang=en_gb,en_us                        " Spell check against British and American English
set spellfile=$HOME/.config/nvim/words.add       " Additional words
set noswapfile                                   " Dis:wable swap file
set autowrite                                    " Autowrite
set autowriteall                                 " Autowrite everywhere
set showtabline=2                                " Always show tabline

au! BufWritePost $MYVIMRC source %               " auto source when writing to init.vm alternatively you can run :source $MYVIMRC
au FocusGained,BufEnter * :checktime             " Update on focus switch

" Disable record
map q <Nop>

" You can't stop me
cmap w!! w !sudo tee %

" Disable ex mode for now
map q: <Nop>
nnoremap Q <nop>

" Disable built in help
nmap <F1> <nop>
imap <F1> <nop>
vmap <F1> <nop>
nmap <F9> <nop>
imap <F9> <nop>
vmap <F9> <nop>

