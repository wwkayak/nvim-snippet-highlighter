local bu = require("snippet-highlighter.buffer.buf_util")
local notify = require("notify")
local c = require("tokyonight.colors").setup()

local M = {}

local ls_regex = "(%a+)%s*=%s*require%(%s*%\"luasnip%\"%s*%)"
local fmt_regex = "(%a+)%s*=%s*require%(%s*%\"luasnip%.extras%.fmt%\"%s*%)"
local node_regex = "%s(%a+)%s*=.+%."

local shortcuts = {
  luasnip = { shortcut = "N/A", hl = c.fg, regex = ls_regex },
  snippet = { shortcut = "N/A", hl = c.fg, regex = node_regex .. "snippet" },
  text_node = { shortcut = "N/A", hl = c.fg, regex = node_regex .. "text_node" },
  insert_node = { shortcut = "N/A", hl = c.fg, regex = node_regex .. "insert_node"},
  function_node = { shortcut = "N/A", hl = c.fg, regex = node_regex .. "function_node"},
  choice_node = { shortcut = "N/A", hl = c.fg, regex = node_regex .. "choice_node"},
  dynamic_node = { shortcut = "N/A", hl = c.fg, regex = node_regex .. "dynamic_node"},
  restore_node = { shortcut = "N/A", hl = c.fg, regex = node_regex .. "restore_node"},
  fmt = { shortcut = "N/A", hl = c.fg, regex = fmt_regex },
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
