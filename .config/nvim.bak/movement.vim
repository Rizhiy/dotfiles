set scrolloff=5

" Easier Window navigation
nnoremap <S-h> <C-w>h
nnoremap <S-l> <C-w>l
nnoremap <S-j> <C-w>j
nnoremap <S-k> <C-w>k

" Buffers
nnoremap <silent> <C-j> :BufferGoto 1<CR>
nnoremap <silent> <C-h> :BufferPrevious<CR>
nnoremap <silent> <C-l> :BufferNext<CR>
nnoremap <silent> <C-k> :BufferLast<CR>

nnoremap <silent> <C-p> :BufferPin<CR>
nnoremap <silent> <C-c> :BufferClose<CR>

" Move visual selection around
vnoremap <silent> J :m '>+1<CR>gv=gv
vnoremap <silent> K :m '<-2<CR>gv=gv
