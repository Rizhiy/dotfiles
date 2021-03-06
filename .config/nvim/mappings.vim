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
nnoremap <silent> <C-s> :w<CR>
nnoremap <silent> <C-d> :q<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Commenting
nmap <C-_> gccj
vmap <C-_> gcj

" Toggle search highlight
nnoremap <leader><space> :nohlsearch<CR>

let g:which_key_map = {}
let g:which_key_use_floating_win = 0

let g:which_key_map["v"] = [':vsplit', 'Vertical Split']
let g:which_key_map["h"] = [':split', 'Horizontal Split']
let g:which_key_map["="] = ['<C-w>=', 'Even out splits']
let g:which_key_map[" "] = ['', 'Unhighlight search']
let g:which_key_map["a"] = ['za', 'Toggle Fold']
let g:which_key_map["f"] = [':Ag', 'Project-wide search']
let g:which_key_map["z"] = [':call VCenterCursor()', 'Toggle Vertical Align']

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
let g:which_key_map.g = {
	\ 'name': 'git',
	\ 'v': [':GitGutterPreviewHunk'                                         , 'Preview'],
	\ 's': [':GitGutterStageHunk'                                           , 'Stage'],
	\ 'n': [':GitGutterNextHunk'                                            , 'Next'],
	\ 'p': [':GitGutterPrevHunk'                                            , 'Previous']
	\ }
let g:which_key_map.r = {
	\ 'name': 'run',
	\ 'p': [":w<CR>:exec '!python' shellescape(@%, 1)<CR>"                  , 'python'],
	\ 'f': [":call CocAction('format')"                                     , 'Format'],
	\ 's': [":call CocAction('runCommand', 'editor.action.organizeImport')" , 'Sort imports'],
	\ 'c': [':source $MYVIMRC'                                              , 'Reload VIMRC'],
	\ 'e': [':tabnew $MYVIMRC'                                              , 'Edit VIMRC'],
	\ 'r': [':CocCommand pyright.restartserver'                             , 'Restart Python Language Server']
	\ }
let g:which_key_map.t = {
	\ 'name' : 'terminal',
	\ 'g': [':FloatermNew lazygit'                                          , 'git'],
	\ 'p': [':FloatermNew . ~/.bin/coc_python.sh -m IPython'                , 'ipython'],
	\ 'r': [':FloatermNew ranger'                                           , 'ranger'],
	\ 'y': [':FloatermNew! ytop'                                            , 'ytop'],
	\ 'h': [':FloatermNew htop'                                             , 'htop'],
	\ 't': [':FloatermToggle'                                               , 'toggle'],
	\ }
let g:which_key_map.d = {
	\ 'name': 'diagnostics',
	\ 'n': [":call CocAction('diagnosticNext')"                             , 'next'],
	\ 'p': [":call CocAction('diagnosticPrevious')"                         , 'prev'],
	\ 'l': [':CocList diagnostics'                                          , 'list'],
	\ }
let g:which_key_map.o = {
	\ 'name': 'other',
	\ 'd': ['zg'                                                            , 'Add word to the dictionary']
	\ }

call which_key#register(' ', "g:which_key_map")

" Floaterm
let g:floaterm_keymap_toggle = '<F1>'
let g:floaterm_keymap_prev   = '<F2>'
let g:floaterm_keymap_next   = '<F3>'
let g:floaterm_keymap_new    = '<F4>'
let g:floaterm_keymap_kill   = '<F9>'
nmap <F1> <ESC>:FloatermToggle<CR>
imap <F1> <ESC>:FloatermToggle<CR>
vmap <F1> <ESC>:FloatermToggle<CR>
