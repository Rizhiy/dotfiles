" Change d to delete without copy and x to cut
nnoremap d "_d
nnoremap D "_D
nnoremap x d

function! DiffToggle()
	if &diff
		diffoff
	else
		diffthis
	endif
:endfunction

" Easier save, quit and esc
nnoremap <C-s> :w<CR>
nnoremap <C-d> :q<CR>
nnoremap <C-c> <Esc>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Commenting
nmap <C-_> gccj
vmap <C-_> gcj

let g:which_key_map = {}
let g:which_key_use_floating_win = 0

let g:which_key_map["v"] = [':vsplit', 'Vertical Split']
let g:which_key_map["h"] = [':split', 'Horizontal Split']
let g:which_key_map["="] = ['<C-w>=', 'Even out splits']
let g:which_key_map[" "] = [':nohlsearch', 'Unhighlight search']
let g:which_key_map["a"] = ['za', 'Add word to dictionary']
let g:which_key_map["f"] = [':Ag', 'Project-wide search']
let g:which_key_map["z"] = [':call VCenterCursor()<CR>', "Toggle Vertical Align"]

let g:which_key_map.s = {
	\ 'name': 'session',
	\ 's': [':SSave!'                                                       , 'Save'],
	\ 'l': [':SLoad'                                                        , 'Load'],
	\ 'd': [':SDelete'                                                      , 'Delete'],
	\ 'c': [':SClose'                                                       , 'Close'],
	\ }
let g:which_key_map.b = {
	\ 'name': 'bars',
	\ 't': [':TagbarToggle'                                                 , 'Tags'],
	\ 'd': [':call DiffToggle()'                                            , 'Diffs'],
	\ 'b': [':Git blame'                                                    , 'Blame'],
	\ 'u': [':UndotreeToggle'                                               , 'Undo Tree'],
	\ 'f': [':CocCommand explorer'                                          , 'explorer'],
	\ }
let g:which_key_map.n = {
	\ 'name': 'navigate',
	\ 'r': [':Ranger'                                                       , 'Ranger'],
	\ 'e': [':CocCommand explorer'                                          , 'explorer'],
	\ 'f': [':Files'                                                        , 'Files'],
	\ 'b': [':Buffers'                                                      , 'Buffers'],
	\ }
let g:which_key_map.r = {
	\ 'name': 'run',
	\ 'p': [":w<CR>:exec '!python' shellescape(@%, 1)<CR>"                  , 'python'],
	\ 'f': [":call CocAction('format')"                                     , 'Format'],
	\ 's': [":call CocAction('runCommand', 'editor.action.organizeImport')" , 'Sort imports'],
	\ 'c': [':source $MYVIMRC'                                              , 'Reload VIMRC'],
	\ 'e': [':tabnew $MYVIMRC'                                              , 'Edit VIMRC'],
	\ }
let g:which_key_map.t = {
	\ 'name' : 'terminal',
	\ 'g' : [':FloatermNew lazygit'                                         , 'git'],
	\ 'p' : [':FloatermNew ipython3'                                        , 'ipython'],
	\ 'r' : [':FloatermNew ranger'                                          , 'ranger'],
	\ 'y' : [':FloatermNew! ytop'                                           , 'ytop'],
	\ 'h' : [':FloatermNew htop'                                            , 'htop'],
	\ 't' : [':FloatermToggle'                                              , 'toggle'],
	\ }
let g:which_key_map.d = {
	\ 'name': 'diagnostics',
	\ 'n' : [ ''                                                            , 'next'],
	\ 'p' : [ ''                                                            , 'prev'],
	\ 'l' : [':CocList diagnostics'                                         , 'list'],
	\ }

call which_key#register(' ', "g:which_key_map")
