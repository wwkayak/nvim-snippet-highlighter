local bu = require("snippet-highlighter.buffer.buf_util")
local notify = require("notify")
local colors = require("tokyonight.colors").setup()

local M = {}

local ls_name_pattern = "(%a+)%s*=%s*require%(%s*%\"luasnip%\"%s*%)"
local node_pattern = "(%a+)%s*=%s*"

local shortcuts = {
  luasnip = { shortcut = "N/A", hl = colors.fg },
  snippet = { shortcut = "N/A", hl = colors.fg },
  text_node = { shortcut = "N/A", hl = colors.fg },
  insert_node = { shortcut = "N/A", hl = colors.fg },
  function_node = { shortcut = "N/A", hl = colors.fg },
  choice_node = { shortcut = "N/A", hl = colors.fg },
  dynamic_node = { shortcut = "N/A", hl = colors.fg },
  restore_node = { shortcut = "N/A", hl = colors.fg },
  -- fmt = { shortcut = "N/A", hl = colors.fg},
}

M.has_luasnip = function(buf)
  local matches = bu:find_pattern(buf, ls_name_pattern)
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
  local luasnip_shortcut

  local count = vim.api.nvim_buf_line_count(buf)
  if count > 0 then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, count, true)
    for i = 1, #lines do
      _, _, luasnip_shortcut = string.find(lines[i], ls_name_pattern)
      if luasnip_shortcut ~= nil then
        break
      end
    end
    if luasnip_shortcut == nil then
      return nil
    end

    shortcuts["luasnip"].shortcut = luasnip_shortcut
    for i = 1, #lines do
      for node, _ in pairs(shortcuts) do
        local np = node_pattern .. luasnip_shortcut .. "." .. node
        local _, _, shortcut = string.find(lines[i], np)
        if shortcut ~= nil then
          shortcuts[node].shortcut = shortcut
        end
      end
    end
  end
end

function M:print_snippet_info(bn)
  local ns_id = vim.api.nvim_create_namespace("snippet-highlighter")
  local ns_name = bu.get_namespace_name(ns_id)
  local filename = bu.find_buf_name(bn)
  local str = ""
  local lines = {}

  local i = 1
  for k, v in pairs(shortcuts) do
    lines[i] = string.format("%s = %s", k, v.shortcut)
    i = i % 7 + 1
  end

  local title = string.format("Snippets found. ns=\"%s\"", ns_name)

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
