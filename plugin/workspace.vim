if exists('g:loaded_workspace')
    finish
endif

command! WorkspaceLoad lua require("workspace").load_from_current_buffer()
command! WorkspaceTest lua require("workspace").test()

augroup filetype_nvimworkspace
    autocmd!
    autocmd BufNewFile,BufRead *.nvim-workspace set filetype=nvim-workspace
    autocmd FileType nvim-workspace WorkspaceLoad
augroup END

let g:loaded_workspace = 1