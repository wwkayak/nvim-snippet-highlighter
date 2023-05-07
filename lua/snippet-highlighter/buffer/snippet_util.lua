local bu = require("snippet-highlighter.buffer.buf_util")
local notify = require("notify")

local M = {}

local ls_name_pattern = "(%a+)%s*=%s*require%(%s*%\"luasnip%\"%s*%)"

local shortcuts = {
  luasnip = "",
  snippet_node = "",
  text_node = "",
  insert_node = "",
  function_node = "",
  choice_node = "",
  dynamic_node = "",
  restore_node = "",
  fmt = "",

}



M.has_luasnip = function(buf)
  local matches = bu:find_pattern(buf, ls_name_pattern)
  local count = 0
  for _, _ in pairs(matches) do
    count = count + 1
  end
  return count > 0 or false
end

--[[
perfect and use has_luasnip
Check when this gets run (everytime, or can I keep track of has_luasnip)
For all the things I findi, set / store highlight info with the thing 
    Structure for nodes... and snippets???? maybe.

    Node:
      Type:
      Name:
      Highlight:
        location for highlights e.g.  t(********)

--]]


M.find_luasnip_shortcuts = function(buf)
  if not buf then
    return nil
  end
  local ls_shortcuts_pattern
  local ls_name
  local ls_shortcuts = {}

  local count = vim.api.nvim_buf_line_count(buf)
  if count > 0 then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, count, true)
    for i = 1, #lines do
      _, _, ls_name = string.find(lines[i], ls_name_pattern)
      if ls_name ~= nil then
        break
      end
    end
    if ls_name == nil then
      return nil
    end
    ls_shortcuts_pattern = "(%a+)%s*=%s*" .. ls_name .. ".%a+_node"
    local snippet_pattern = "(%a+)%s*=%s*" .. ls_name .. ".snippet$"
    for i = 1, #lines do
      local _, _, shortcut = string.find(lines[i], ls_shortcuts_pattern)
      local _, _, snippet_shortcut = string.find(lines[i], snippet_pattern)
      if shortcut ~= nil then
        table.insert(ls_shortcuts, shortcut)
      end
      if snippet_shortcut ~= nil then
        table.insert(ls_shortcuts, snippet_shortcut)
      end
    end
  end
  shortcuts = { luasnip = ls_name, nodes = ls_shortcuts }
end

function M:print_snippet_info(bn)
  local ns_id = vim.api.nvim_create_namespace("snippet-highlighter")
  local ns_name = bu.get_namespace_name(ns_id)
  local filename = bu.find_buf_name(bn)
  local s = shortcuts
  local str = ""
  local lines = {}

  for i = 1, #s.nodes do
    str = str .. s.nodes[i] .. ", "
  end

  local title = string.format("Snippets found. ns=\"%s\"", ns_name)
  local luasnip = string.format("\t\tluasnip = %s\n", s.luasnip)
  local nodes = string.format("\t\tnodes = %s", str)
  local message = string.format( "Filename: \"%s\"(bufnr:%d)\nSnippets:\n%s%s",
    bu.find_buf_name(bn), bn, luasnip, nodes)

  lines = {"Filname: " .. filename, "Snippets Shortcuts Found:", "luasnip = " .. s.luasnip, "nodes = " .. str }
  notify(message, vim.log.levels.INFO, { title = title })
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
    --require"notify"(string.format("%s",vim.print(v[2])))
  end
  require "notify" (message, "", { title = "snippet extmarks:" })
end

return M
