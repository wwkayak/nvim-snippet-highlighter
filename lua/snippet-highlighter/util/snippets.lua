local node_types = require("luasnip.util.types")
local bu = require("snippet-highlighter.util.buffers")
--local c = require("tokyonight.colors").setup()

local ls_regex = "(%a+)%s*=%s*require%(%s*%\"luasnip%\"%s*%)"
local fmt_regex = "(%a+)%s*=%s*require%(%s*%\"luasnip%.extras%.fmt%\"%s*%)"
local node_regex = "%s(%a+)%s*=.+%."

local M = {}

local ls_names = {
  { sn = "s", ln = "snippet", pn = node_types.names_pascal_case[1]},
  { sn = "sn", ln = "snippet_node", pn = node_types.names_pascal_case[2] },
  { sn = "t", ln = "text_node", pn = node_types.names_pascal_case[3] },
  { sn = "f", ln = "function_node", pn = node_types.names_pascal_case[4] },
  { sn = "i", ln = "insert_node", pn = node_types.names_pascal_case[5] },
  { sn = "c", ln = "choice_node", pn = node_types.names_pascal_case[5] },
  { sn = "d", ln = "dynamic_node", pn = node_types.names_pascal_case[6] },
  { sn = "r", ln = "restore_node", pn = node_types.names_pascal_case[7] },
}


local snippet_nodes = {}

M.get_snippet_nodes = function()
  local names = node_types.names_pascal_case
end

local shortcuts = {
  luasnip = { shortcut = "N/A", hl = "LuaSnip", regex = ls_regex },
  snippet = { shortcut = "N/A", hl = "SnippetSnippet", regex = node_regex .. "snippet" },
  text_node = { shortcut = "N/A", hl = "SnippetTextNode", regex = node_regex .. "text_node" },
  insert_node = { shortcut = "N/A", hl = "SnippetInsertNode", regex = node_regex .. "insert_node" },
  function_node = { shortcut = "N/A", hl = "SnippetFunctionNode", regex = node_regex .. "function_node" },
  choice_node = { shortcut = "N/A", hl = "SnippetChoiceNode", regex = node_regex .. "choice_node" },
  dynamic_node = { shortcut = "N/A", hl = "SnippetDynamicNode", regex = node_regex .. "dynamic_node" },
  restore_node = { shortcut = "N/A", hl = "SnippetRestoreNode", regex = node_regex .. "restore_node" },
  --fmt = { shortcut = "N/A", hl = c.fg, regex = fmt_regex },
}

M.has_luasnip = function(buf)
  local matches = bu:find_pattern(buf, ls_regex)
  local count = 0
  for _, _ in pairs(matches) do
    count = count + 1
  end
  return count > 0 or false
end

M.find_luasnip_shortcuts = function(buf)
  if not buf then
    return nil
  end

  local count = vim.api.nvim_buf_line_count(buf)
  if count > 0 then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, count, true)
    for k, v in pairs(shortcuts) do
      for i = 1, #lines do
        local _, _, str = string.find(lines[i], v.regex)
        if str ~= nil then
          shortcuts[k].shortcut = str
          break
        end
      end
    end
  end
end

function M:shortcuts_tolines()
  local lines = {}
  local i = 1
  for k, v in pairs(shortcuts) do
    lines[i] = string.format("%s = %s", k, v.shortcut)
    i = i + 1
  end
  return lines
end

M.set_snippet_highlights = function(buf)
  local rows = bu:find_pattern(buf, "=%s*s%(")
  for r = 1, #rows do
    vim.api.nvim_buf_set_extmark(buf,
      vim.api.nvim_create_namespace("snippet-highlighter"),
      rows[r], 0, {}
    )
  end
  local marks = vim.api.nvim_buf_get_extmarks(buf,
    vim.api.nvim_create_namespace("snippet-highlighter"),
    0, -1, {}
  )
  local message = ""
  for _, v in pairs(marks) do
    message = message .. string.format("{%d, %d, %d},\n", v[1], v[2], v[3])
    --require{ shortcut = "notify"(string.format("%s",vim.print(v[2])))
  end
end

return M
