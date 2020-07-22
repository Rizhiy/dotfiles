call plug#begin('$HOME/.vim/plugged')

" Make sure you use single quotes

" Git
Plug 'tpope/vim-fugitive'
" Parens
Plug 'tpope/vim-surround'
" Useful file operations
Plug 'tpope/vim-eunuch'
" Git status in file tree
Plug 'Xuyuanp/nerdtree-git-plugin'
" Comments
Plug 'tpope/vim-commentary'
" Git line status
Plug 'airblade/vim-gitgutter'
" Indent guide
Plug 'nathanaelkane/vim-indent-guides'
" Scheme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_theme = 'gruvbox'
" Fzf
Plug '$HOME/.local/share/fzf'
Plug 'junegunn/fzf.vim'
" Indent guide
Plug 'Yggdroot/indentLine'
" Tmux config help
Plug 'tmux-plugins/vim-tmux'
" Undo tree
Plug 'mbbill/undotree'
" More languages highlighting
Plug 'sheerun/vim-polyglot'
" Tagbar
Plug 'majutsushi/tagbar'
" Autocompletion and stuff
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Color Schemes
Plug 'rafi/awesome-vim-colorschemes'
" Proper focus for vim inside tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
" Better tab format
Plug 'gcmt/taboo.vim'
set sessionoptions+=tabpages,globals
let g:taboo_tab_format=" %N %f%U%m "
" Add matching parenthesis
Plug 'jiangmiao/auto-pairs'
" Shortcut help
Plug 'liuchengxu/vim-which-key'
nnoremap <silent> <leader> :WhichKey '<leader>'<CR>
" Ranger file navigation
Plug 'francoiscabrol/ranger.vim'
let g:ranger_map_keys = 0
" Colors
Plug 'norcalli/nvim-colorizer.lua'
" Faster navigation
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1                            " More choices
let g:sneak#use_ic_scs = 1                       " Ignore capitalisation
let g:sneak#s_next = 1                           " Automatically just to first instance
" Floats
Plug 'voldikss/vim-floaterm'
let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_next   = '<F2>'
let g:floaterm_keymap_prev   = '<F3>'
let g:floaterm_keymap_new    = '<F4>'
imap <F1> <ESC>:FloatermToggle<CR>

" Floaterm
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1
" Change working directory
Plug 'airblade/vim-rooter'
" Dev icons, ALWAYS LOAD LAST
Plug 'ryanoasis/vim-devicons'
" Project Management
Plug 'mhinz/vim-startify'
let g:startify_lists = [
	\ { 'header': ['    MRU ' . getcwd()], 'type': 'dir' },
	\ { 'header': ['    Global MRU'],      'type': 'files' },
	\ { 'header': ['    Sessions'],        'type': 'sessions' },
	\ { 'header': ['    Bookmarks'],       'type': 'bookmarks' },
	\ { 'header': ['    Commands'],        'type': 'commands' },
	\ ]
let g:startify_bookmarks = [
	\ { 'C': '~/.config/nvim/init.vim' },
	\ { 'Z': '~/.zshrc' },
	\]
autocmd User StartifyReady CocCommand explorer

call plug#end()
