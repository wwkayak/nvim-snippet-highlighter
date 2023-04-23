
local notify = require("notify")
local su = require("buffer.snippet_util")
local bu = require("buffer.buf_util")

vim.api.nvim_create_namespace("snippet-highlighter")
print(vim.api.nvim_get_namespaces()["snippet-highlighter"])

local filename = "snippet-snippets.lua"
local bn = bu.find_file_number(filename)
local ls_vars = su.get_luasnip_shortcuts(bn)

notify(string.format("Found luasnip file: \"%s\"(bufnr:%d)", filename, bn),
vim.log.levels.INFO)

local s = vim.print(ls_vars)
notify(string.format("luasnip = %s", s.luasnip), vim.log.levels.WARN)
local str = ""
for i = 1, #s.nodes do
  str = str .. s.nodes[i] .. ", "
end
notify(string.format("nodes = %s", str), vim.log.levels.ERROR)
--notify(string.format("shortcuts: nodes = {%s, %s, %s, %s,: %s}"))

su.set_snippet_highlights(bn)


