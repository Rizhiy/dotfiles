source $HOME/.config/nvim/general.vim
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/coc.vim
source $HOME/.config/nvim/movement.vim
source $HOME/.config/nvim/mappings.vim
source $HOME/.config/nvim/appearance.vim


" ============== SEARCH ===============
set path+=**                            " Increase search path
" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif
set hlsearch                             " Highlight all matches

" =============== SPLITS ===============
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set fillchars+=vert:\                   " Remove pipes that act as separators

" Easier split resize
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>


" =============== OTHER ===============
" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

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

" Enable colorizer
lua require('colorizer').setup()
