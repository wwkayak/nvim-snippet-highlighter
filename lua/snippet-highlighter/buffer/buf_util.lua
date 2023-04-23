
local M = {}

local lines = nil

M.find_file_number = function(name)
  local bn = nil
  local  buffers = vim.api.nvim_list_bufs()
  local pattern = "[^/]-%.lua"
  for _, v in pairs(buffers) do
    if vim.api.nvim_buf_is_loaded(v) then
      local fname = vim.api.nvim_buf_get_name(v)  -- TOO UGLY(for,if,for,if...), refactor!
      if fname then
        local split = string.match(fname, pattern)
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
  local rows = {}
  lines = self.get_buf_lines(buf)
  for _, line in pairs(lines) do
    local row, col = string.find(line, pattern)
    if row and col then
      table.insert(rows, row)
    end
  end
  return rows
end

return M
