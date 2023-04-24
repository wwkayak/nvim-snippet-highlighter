
local bu = require("buffer.buf_util")
local mm = require("snippet-highlighter.marks.mark_manager")
local notify = require("notify")

local M = {}

local shortcuts = nil
local snippets_info = nil

M.get_luasnip_shortcuts = function(buf)
  if shortcuts then
    return shortcuts
  end
  local ls_name_pattern = "(%a+)%s*=%s*require%(%s*%\"luasnip%\"%s*%)"
  local ls_shortcuts_pattern
  local ls_name
  local ls_shortcuts = {}

  local count = vim.api.nvim_buf_line_count(buf)
  if count > 0 then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, count, true)
    for i = 1, #lines do
      _, _, ls_name = string.find(lines[i], ls_name_pattern )
      if ls_name ~= nil then
        break
      end
    end
    ls_shortcuts_pattern = "(%a+)%s*=%s*" .. ls_name ..".%a+_node"
    local snippet_pattern = "(%a+)%s*=%s*" .. ls_name ..".snippet$"
    for i = 1, #lines do
      local _, _, shortcut =  string.find(lines[i], ls_shortcuts_pattern)
      local _, _, snippet_shortcut = string.find( lines[i], snippet_pattern)
      if shortcut ~= nil then
        table.insert(ls_shortcuts, shortcut)
      end
      if snippet_shortcut ~= nil then
        table.insert(ls_shortcuts, snippet_shortcut)
      end
    end
  end
  shortcuts = {luasnip = ls_name, nodes = ls_shortcuts}
  return shortcuts
end

function M:print_snippet_info(bn)
  local ns_id = vim.api.nvim_create_namespace("snippet-highlighter")
  local ns_name =  bu.get_namespace_name(ns_id)
  local ls_vars = self.get_luasnip_shortcuts(bn)
  local s = ls_vars
  local str = ""
  for i = 1, #s.nodes do
    str = str .. s.nodes[i] .. ", "
  end

  local title = string.format("Snippets found. ns=\"%s\"", ns_name)
  local luasnip = string.format("\t\tluasnip = %s\n", s.luasnip)
  local nodes = string.format("\t\tnodes = %s", str)
  local message= string.format(
    "Filename: \"%s\"(bufnr:%d)\nSnippets:\n%s%s", bu.find_buf_name(bn), bn, luasnip, nodes
  )
  notify(message, vim.log.levels.INFO , {title=title})
end

M.set_snippet_highlights = function (buf)
  print("setting highlights for buffer: " .. buf)
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
  for _,v in pairs(marks) do
    message = message ..string.format("{%d, %d, %d},\n", v[1], v[2], v[3])
    --require"notify"(string.format("%s",vim.print(v[2])))
  end
  require"notify"(message,"", {title = "snippet extmarks:"})
end

return M
