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
" Scheme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 0
let g:airline_theme = 'gruvbox'
let g:airline_detect_spell=0
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
	\ '__'     : '-',
	\ 'c'      : 'C',
	\ 'i'      : 'I',
	\ 'ic'     : 'I',
	\ 'ix'     : 'I',
	\ 'n'      : 'N',
	\ 'multi'  : 'M',
	\ 'ni'     : 'N',
	\ 'no'     : 'N',
	\ 'R'      : 'R',
	\ 'Rv'     : 'R',
	\ 's'      : 'S',
	\ 'S'      : 'S',
	\ ''     : 'S',
	\ 't'      : 'T',
	\ 'v'      : 'V',
	\ 'V'      : 'V',
	\ ''     : 'V',
	\ }
let g:airline_skip_empty_sections = 1
" Fzf
Plug '$HOME/.local/share/fzf'
Plug 'junegunn/fzf.vim'
" Indent guide
Plug 'Yggdroot/indentLine'
let g:indentLine_fileTypeExclude = ['markdown']
" Tmux config help
Plug 'tmux-plugins/vim-tmux'
" More languages highlighting
Plug 'sheerun/vim-polyglot'
" Autocompletion and stuff
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Color Schemes
Plug 'rafi/awesome-vim-colorschemes'
" Proper focus for vim inside tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
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
" Floaterm
Plug 'voldikss/vim-floaterm'
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.9
let g:floaterm_height=0.9
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

" Change working directory
Plug 'airblade/vim-rooter'
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
" Blame for the line
Plug 'APZelos/blamer.nvim'
let g:blamer_enabled = 1
let g:blamer_delay = 100
let g:blamer_date_format = '%y-%m-%d'
let g:blamer_relative_time = 1
" Buffer line
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'

" Dev icons, ALWAYS LOAD LAST
Plug 'ryanoasis/vim-devicons'

autocmd User StartifyBufferOpened CocCommand explorer
autocmd User SessionLoadPost CocCommand explorer

call plug#end()
