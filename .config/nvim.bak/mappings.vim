let g:which_key_map.r = {
	\ 'name': 'run',
	\ 'p': [":w<CR>:exec '!python' shellescape(@%, 1)<CR>"                  , 'python'],
	\ 'f': [":call CocAction('format')"                                     , 'Format'],
	\ 's': [":call CocAction('runCommand', 'editor.action.organizeImport')" , 'Sort imports'],
	\ 'c': [':source $MYVIMRC | CocRestart'                                 , 'Reload VIMRC'],
	\ 'e': [':tabnew $MYVIMRC'                                              , 'Edit VIMRC'],
	\ 'r': [':CocCommand pyright.restartserver'                             , 'Restart Python Language Server']
	\ }
let g:which_key_map.d = {
	\ 'name': 'diagnostics',
	\ 'n': [":call CocAction('diagnosticNext')"                             , 'next'],
	\ 'p': [":call CocAction('diagnosticPrevious')"                         , 'prev'],
	\ 'l': [':CocList diagnostics'                                          , 'list'],
	\ }
let g:which_key_map.o = {
	\ 'name': 'other',
	\ 'd': ['zg'                                                            , 'Add word to the dictionary'],
	\ 's': [''                                                              , 'Global search'],
	\ }


" Suggestions
inoremap <silent><expr> <C-j>
			\ coc#pum#visible() ? coc#pum#next(1) :
			\ CheckBackspace() ? "" :
			\ coc#refresh()
inoremap <silent><expr> <C-k>
			\ coc#pum#visible() ? coc#pum#prev(1) : ""
