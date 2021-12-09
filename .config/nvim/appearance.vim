set pumheight=10                        " Makes popup menu smaller
set ruler                               " Show the cursor position all the time
set cursorline
set cmdheight=2                         " More space for displaying messages
set iskeyword+=-                        " treat dash separated words as a word text object
set conceallevel=0                      " So that I can see `` in markdown files
set laststatus=2                        " Always display the status line
set number                              " Line numbers
set relativenumber                      " Relative line numbers
set background=dark                     " tell vim what the background color looks like
set showtabline=4                       " Always show tabs
set formatoptions-=cro                  " Stop newline continuation of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
set display=lastline                    " Show @@@ in the last line if it is truncated.
set list                                " Show empty characted tab/eol
set listchars=tab:▸\ ,trail:·           " Specify empty charactes
set lazyredraw                          " Redraw less
set showcmd                             " display incomplete commands
let g:fzf_preview_window = 'right:65%'  " Bigger preview window
if exists('+termguicolors')
  set t_8f=^[[38;2;%lu;%lu;%lum        " set foreground color
  set t_8b=^[[48;2;%lu;%lu;%lum        " set background color
  set t_Co=256
  set termguicolors
endif

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=10

" Color Scheme
colorscheme gruvbox

" Floaterm
hi FloatermBorder guibg=gray16
