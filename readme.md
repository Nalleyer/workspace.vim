# workspace

load workspace from a lua config file.
then provide filelist only in configured path.

## Warning

* only windows + nvim is tested

## pre-require

1. `rg` in your environment path

## example config file:

``` lua
-- comments is allowed
return {
    folders = {
        {path = "c:\\Some\\Path\\To\\A\\Folder"},
        {path = "c:\\Another\\Path\\To\\A\\Folder"},
    },
    settings = {
        ["files.exclude"] = {
            "**/*.meta",
        },
    },
    name = "workspace1",
}

```
