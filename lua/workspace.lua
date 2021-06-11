local M = {
    -- workspace config table. name -> config
    configs = {},
    current_config = nil,
    -- cached filelist. name -> []
    file_list_cache = {}
}

local api = vim.api

local function escape(str)
    return string.gsub(str, "\"", "\\\"")
end

local function split(str, sep)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(str, sep, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, string.len(str))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(sep)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function M.echoerror(str)
    api.nvim_err_writeln(str)
end

function M.echo(str)
    api.nvim_out_write(str .. "\n")
end

function M.command(str)
    return api.nvim_command(str)
end

function M.eval(str)
    return api.nvim_eval(str)
end

function M.system_eval(str)
    -- local escaped = M.eval(string.format("shellescape('%s')", str))
    local to_system = string.format("system('%s')", str)
    return M.eval(to_system)
end

function M.buffer_content()
    local lines = M.eval("getline(1, '$')")
    local content = table.concat(lines, "\n")
    return content
end

function M.load_from_current_buffer()
    local content = M.buffer_content()
    local f = assert(loadstring(content))
    local config = f()
    local config_name = tostring(config.name)
    if config_name == nil then
       config_name = "__default"
       config.name = config_name
    end
    M.configs[config_name] = config
    M.current_config = config

    M.generate_file_list()
end

function M.do_rg(params)
    local command = string.format("rg %s", table.concat(params, " "))
    return M.system_eval(command)
end

function M.build_ignore_glob()
    local params = {}
    for _, glob_str in ipairs(M.current_config.settings["files.exclude"]) do
        table.insert(params, "--glob")
        table.insert(params, string.format("\"!%s\"", glob_str))
    end
    return params
end

function M.rg_list(start_path)
    -- M.command(string.format("cd %s", start_path.path))
    local ignore_glob_params = M.build_ignore_glob()
    local params = ignore_glob_params
    table.insert(params, "--files")
    table.insert(params, start_path.path)
    return M.do_rg(params)
end

--- generate a filelist for grep plugin
function M.generate_file_list()
    if M.current_config == nil then
        M.echoerror("workspace not loaded")
        return {}
    end
    local file_list_string = ""
    for _, path in ipairs(M.current_config.folders) do
        local filelist_for_one_path = M.rg_list(path)
        file_list_string = string.format("%s\n%s", file_list_string, filelist_for_one_path )
    end
    local list = split(file_list_string, "\n")
    M.file_list_cache[M.current_config.name] = list
    return list
end

function M.get_file_list()
    if M.current_config == nil then
        M.echoerror("workspace not loaded")
        return {}
    end
    if M.file_list_cache[M.current_config.name] == nil then
        M.generate_file_list()
    end
    local list = M.file_list_cache[M.current_config.name]
    return list
end

function M.test()
    local list = M.generate_file_list()
end

return M