-- each snippet_node is unique and can have some default values
-- THE snippet_nodes table is a singleton for all methods/callbacks
--  Does it contain just the 9 luasnip types, or nodes/definitions of the
--  buffer?
--

local snippet_node = {
  luasnip_name = "",
  var_name = "N/A",
  hl_name = "",
  search_pattern = "",
  loc = { row = 0, col = 0 },
}





