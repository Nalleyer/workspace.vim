if exists('g:loaded_workspace')
    finish
endif

" let s:luaplugin = "lua require('workspace')")

" echom s:luaplugin

command! WorkspaceLoad lua require("workspace").load_from_current_buffer()
command! WorkspaceTest lua require("workspace").test()

" function! WorkspeceList()
    " let l:list = luaeval("require('workspace').get_file_list()")
    " echom l:list
"     return ["test", "list"]
" endfunction

augroup filetype_nvimworkspace
    autocmd!
    autocmd FileType nvim-workspace WorkspaceLoad
    autocmd FileType echom "test"
augroup END

let g:loaded_workspace = 1