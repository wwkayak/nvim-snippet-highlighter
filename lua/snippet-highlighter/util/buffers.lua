--local colors = require("tokyonight.colors").setup()
--local color_util = require("tokyonight.util")

local M = {}

local lines = nil
local name_pattern = "[^/]+%.lua"

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

M.get_buf_line = function(buf, line_no)
  lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  return lines[line_no]
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

M.set_rainbow_highlights = function(buf, new_lines)
  local ns = vim.api.nvim_create_namespace("")
  for line_num = 0, #new_lines - 1 do
    local idx = line_num % 7 + 1
    local hl = "rainbowcol" .. idx
    vim.api.nvim_buf_add_highlight(buf, ns, hl, line_num, 0, -1)
  end
  return buf
end

M.create_snippets_float = function(snip_lines)
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, snip_lines)
  local opts = {
    relative = 'win',
    width = 30,
    height = #snip_lines + 2,
    row = 1,
    col = 100,
    anchor = "NE",
    focusable = false,
    style = "minimal",
    border = "rounded",
    title = "Snippet Shortcuts:",
    noautocmd = true
  }

  local win_id = vim.api.nvim_open_win(buf, false, opts)
  local ns = vim.api.nvim_create_namespace("")
  vim.api.nvim_win_set_hl_ns(win_id, ns)
--  vim.api.nvim_set_hl(ns, 'NormalFloat', { background = color_util.lighten(colors.bg, .96) })
  M.set_rainbow_highlights(buf, snip_lines)

  return win_id
end

return M
