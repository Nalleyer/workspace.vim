function! workspace#GetList()
    return luaeval('require("workspace").get_file_list()')
endfunction

function! workspace#OpenFile(showname)
    let l:luacommand = "require(\"workspace\").open_file_with_showname(\"" . a:showname ."\")"
    execute "lua ". l:luacommand
endfunction