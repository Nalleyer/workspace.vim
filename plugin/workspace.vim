if exists('g:loaded_workspace')
    finish
endif

command! WorkspaceTest lua require('workspace').test()

let g:loaded_workspace = 1