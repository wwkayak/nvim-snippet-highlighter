local colors = require("tokyonight.colors").setup()
local color_util = require("tokyonight.util")

local M = {}

local lines = nil
local name_pattern = "[^/]+%.lua"

M.get_buf_line = function(buf, line_no)
  lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  return lines[line_no]
end

M.find_buf_name = function(bn)
  local path = vim.api.nvim_buf_get_name(bn)
  local name = string.match(path, name_pattern)
  return name
end

M.find_buf_number = function(name)
  local bn = nil
  local buffers = vim.api.nvim_list_bufs()
  for _, v in pairs(buffers) do
    if vim.api.nvim_buf_is_loaded(v) then
      local fname = vim.api.nvim_buf_get_name(v) -- TOO UGLY(for,if,for,if...), refactor!
      if fname then
        local split = string.match(fname, name_pattern)
        if split then
          if name == split then
            bn = v
            break
          end
        end
      end
    end
  end
  return bn
end

M.get_buf_lines = function(buf)
  lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  return lines
end

function M:find_pattern(buf, pattern)
  local matches = {}
  lines = self.get_buf_lines(buf)
  for _, line in pairs(lines) do
    local row, col = string.find(line, pattern)
    if row and col then
      table.insert(matches, { line, row, col })
    end
  end
  return matches
end

M.get_namespace_name = function(id)
  local namespaces = vim.api.nvim_get_namespaces()
  for k, v in pairs(namespaces) do
    if (v == id) then
      return k
    end
  end
end
--[[
let buf = nvim_create_buf(v:false, v:true)
call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])
let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
    \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
let win = nvim_open_win(buf, 0, opts)
" optional: change highlight, otherwise Pmenu is used
call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
--]]
M.create_snippets_float = function(snip_lines)
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, snip_lines)
  local opts = {
    relative = 'win',
    width = 30,
    height = #snip_lines + 5,
    row = 1,
    col = 120,
    anchor = "NE",
    focusable = false,
    style = "minimal",
    border = "rounded",
    title = "Snippet Shortcuts Found:",
    noautocmd = true
  }
  local win_id = vim.api.nvim_open_win(buf, false, opts)
  local ns = vim.api.nvim_create_namespace('')
  vim.api.nvim_win_set_hl_ns(win_id, ns)
  vim.api.nvim_set_hl(ns, 'NormalFloat', { background = color_util.lighten(colors.bg, .93) })
  vim.api.nvim_buf_add_highlight(buf, ns, 'DiagnosticHint', 0, 0, -1)
  return buf
end

return M
