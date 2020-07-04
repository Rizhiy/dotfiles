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

let g:which_key_map = {}
let g:which_key_use_floating_win = 0

let g:which_key_map["v"] = [':vsplit', 'Vertical Split']
let g:which_key_map["h"] = [':split', 'Horizontal Split']
let g:which_key_map[" "] = [':nohlsearch', 'Unhighlight search']
let g:which_key_map["a"] = ['za', 'Add word to dictionary']

let g:which_key_map.s = {
	\ 'name': 'session',
	\ 'm': [':!mkdir -p .vim', 'Make Folder'],
	\ 's': [':mksession! .vim/session', 'Save'],
	\ 'r': [':source .vim/session', 'restore'],
	\ }
let g:which_key_map.b = {
	\ 'name': 'bars',
	\ 't': [':TagbarToggle', 'Tags'],
	\ 'd': [':call DiffToggle()', 'Diffs'],
	\ 'b': [':Git blame', 'Blame'],
	\ 'u': [':UndotreeToggle', 'Undo Tree'],
	\ 'f': [':CocCommand explorer', 'explorer'],
	\ }
let g:which_key_map.n = {
	\ 'name': 'navigate',
	\ 'r': [':RangerNewTab', 'Ranger'],
	\ 'e': [':CocCommand explorer', 'explorer'],
	\ 'f': [':Files', 'Files'],
	\ }
let g:which_key_map.r = {
	\ 'name': 'run',
	\ 'p': [":w<CR>:exec '!python' shellescape(@%, 1)<CR>", 'python'],
	\ 'f': [":CocAction('format')", 'Format'],
	\ 's': [":call CocAction('runCommand', 'editor.action.organizeImport')", 'Sort imports'],
	\ 'c': [':source $MYVIMRC', 'Reload VIMRC'],
	\ 'e': [':tabnew $MYVIMRC', 'Edit VIMRC'],
	\ }
let g:which_key_map.t = {
	\ 'name' : '+terminal',
	\ 'g' : [':FloatermNew lazygit'                           , 'git'],
	\ 'p' : [':FloatermNew ipython'                           , 'ipython'],
	\ 'r' : [':FloatermNew ranger'                            , 'ranger'],
	\ 't' : [':FloatermToggle'                                , 'toggle'],
	\ 'b' : [':FloatermNew bashtop'                           , 'bashtop'],
	\ }

call which_key#register(' ', "g:which_key_map")
