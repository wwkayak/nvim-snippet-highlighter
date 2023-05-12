local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

--define snippet_node here
--table.insert(snippets, "<snippet_node>")
--return snippets, autosnippets

local lines = vim.api.nvim_buf_get_lines(0, 2, 16, true)

local req_luasnip = s("rls", {t("local ls = require(\"luasnip\")")})
table.insert(snippets, req_luasnip)

-- insert the boilerplate above into any file
local snippet_boilerplate = s(
  { trig = "lsbp", snippetType = "autosnippet" },
  { t(lines) }
)
table.insert(snippets, snippet_boilerplate)

--fmt(format:string, nodes:table of nodes, opts:table|nil) -> table of nodes
--Snippet to add a snippet to the snippets table:
local tblAdd = s("tbi",
  fmt("table.insert({}, {})",
    {
      c(1, {t("snippets"), t("autosnippets")}),
      i(2,"trig"),
    }
  )
)
table.insert(snippets, tblAdd)

return snippets, autosnippets
