" Easier Window navigation
nnoremap <S-h> <C-w>h
nnoremap <S-l> <C-w>l

" Scrolling
nnoremap <S-j> <C-e>
nnoremap <S-k> <C-y>

" Buffers
nnoremap <silent> <C-j> :BufferGoto 1<CR>
nnoremap <silent> <C-h> :BufferPrevious<CR>
nnoremap <silent> <C-l> :BufferNext<CR>
nnoremap <silent> <C-k> :BufferLast<CR>

nnoremap <silent> <C-p> :BufferPin<CR>
nnoremap <silent> <C-c> :BufferClose<CR>

" Keep cursor vertically centered
set scrolloff=5
if !exists('*VCenterCursor')
  augroup VCenterCursor
  au!
  au OptionSet *,*.*
    \ if and( expand("<amatch>")=='scrolloff' ,
    \         exists('#VCenterCursor#WinEnter,WinNew,VimResized') )|
    \   au! VCenterCursor WinEnter,WinNew,VimResized|
    \ endif
  augroup END
  function VCenterCursor()
    if !exists('#VCenterCursor#WinEnter,WinNew,VimResized')
      let s:default_scrolloff=&scrolloff
      let &scrolloff=winheight(win_getid())/2
      au VCenterCursor WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
    else
      au! VCenterCursor WinEnter,WinNew,VimResized
      let &scrolloff=s:default_scrolloff
    endif
  endfunction
endif
