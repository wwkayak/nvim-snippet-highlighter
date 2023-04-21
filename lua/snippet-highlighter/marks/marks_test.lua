local marks = require("marks")

local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node

marks:set_extmark(0, 5, 6, {id=marks.get_id()})
marks:set_extmark(0, 5, 6, {id=marks.get_id()})
marks:set_extmark(0, 10, 11, {id=marks.get_id()})


marks.print_saved_extmarks()

marks.get_extmarks(0, 0, -1, {})

--marks.print_saved_extmarks()
