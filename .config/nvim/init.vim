set encoding=utf-8

call plug#begin('$HOME/.vim/plugged')

" Make sure you use single quotes

" Git
Plug 'tpope/vim-fugitive'
" Parens
Plug 'tpope/vim-surround'
" Useful file operations
Plug 'tpope/vim-eunuch'
" File Tree
Plug 'preservim/nerdtree'
nnoremap <leader>f :NERDTreeToggle<CR>
" Git status in file tree
Plug 'Xuyuanp/nerdtree-git-plugin'
" Comments
Plug 'preservim/nerdcommenter'
" Git line status
Plug 'airblade/vim-gitgutter'
" Indent guide
Plug 'nathanaelkane/vim-indent-guides'
" Scheme
Plug 'vim-airline/vim-airline'
" Fzf
Plug '$HOME/.local/share/fzf'
Plug 'junegunn/fzf.vim'
map <leader>g :Files<CR>
" Indent guide
Plug 'Yggdroot/indentLine'
" Tmux config help
Plug 'tmux-plugins/vim-tmux'
" Undo tree
Plug 'mbbill/undotree'
nnoremap <leader>u :UndotreeToggle<cr>
" More languages highlighting
Plug 'sheerun/vim-polyglot'
" Tagbar
Plug 'majutsushi/tagbar'
nnoremap <leader>t :TagbarToggle<CR>
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

call plug#end()

" ====================== COC ====================

" Color Scheme
" Need to first enable another so all colors work properly
colorscheme gruvbox

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> gb <C-O>
nnoremap <silent> gf <C-I>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" =================== COC DONE ===========================

" Increase search
set path+=**

" Display all possible matches
set wildmenu

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
set ruler			" show the cursor position all the time
set showcmd			" display incomplete commands
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

" Edit vimrc
nnoremap <leader>e :tabnew $MYVIMRC<CR>
" Reload vimrc
nnoremap <leader>r :source $MYVIMRC<CR>

" show tab and eol
set list
set listchars=tab:▸\ ,trail:·

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
autocmd FileType python nnoremap <buffer> <leader>p :w<CR> :exec '!python' shellescape(@%, 1)

" Automatically update files
set autoread

" Bigger preview window
let g:fzf_preview_window = 'right:65%'

" Save and load session
nmap <leader>ss :mksession! ~/.local/share/vim_session <CR>
nmap <leader>sr :source ~/.local/share/vim_session <CR>

" Easier Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Change d to delete without copy and x to cut
nnoremap d "_d
nnoremap D "_D
nnoremap x d

" Disable record for now
map q <Nop>

" Faster tab navigation
nnoremap <C-t> :tabnew<CR>:edit
nnoremap H :tabprev<CR>
nnoremap L :tabnext<CR>
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt
nnoremap <A-0> 10gt

" Unmap J
map J <Nop>
