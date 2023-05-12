require("math")
local bu = require("buffer.buf_util")
local colors = require("tokyonight.colors").setup() -- options as on git too
local util = require("tokyonight.util")

local M = {}

M.extmarks = {}
M.mt = {}
setmetatable(M.extmarks, M.mt)
setmetatable(M, M.mt)
M.mt.__tostring = M.tostring

local ns = vim.api.nvim_create_namespace("snippet-highlighter")

M.set_random_extmarks = function(buf, count)
  math.randomseed(os.time())
  local lines = bu.get_buf_lines(buf)
  local buf_len = #lines
  local r, c
  local char
  local i = 0
  for _, _ in pairs(M.extmarks) do
    i = i + 1
  end
  if i == count then
    return
  end
  while i ~= count do
    local id = math.random(1, 10)
    if not M.get_extmark(id) then
      repeat
        r = math.random(0, buf_len - 1)
      until lines[r + 1] ~= ""
      i = i + 1
      repeat
        c = math.random(0, buf_len - 1)
        char = string.sub(lines[r + 1], c + 1, c + 1)
      until char ~= ""
      --print(string.format("string.sub(lines[r+1], c+1, c+1) = %s", char))
      --print(string.format("buffer: %d { %d, %d }", buf, r + 1, c + 1))
      M.set_extmark(buf, id, r, c)
    end
  end
  return M.extmarks
end

M.set_extmark = function(buf, id, r, c)
  if not M.get_extmark(id) then
    vim.api.nvim_buf_set_extmark(buf, ns, r, c, { sign_text = "" })
    table.insert(M.extmarks, { id = id, { row = r, col = c } }) --buffer too?
  end
end

M.get_extmark = function(id)
  if not id then return end
  for k, v in pairs(M.extmarks) do
    if v.id == id then
      return M.extmarks[k]
    end
  end
  return nil
end

M.get_extmarks = function()
  return M.extmarks
end

M.del_ext_mark = function(buf, id)
  local found = vim.api.nvim_buf_del_extmark(buf, ns, id)
  if found then
    table.remove(M.extmarks, id)
  end
end

M.clear_marks = function(buf)
  local marks = vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
  if marks then
    for i = 1, #marks do
      --vim.print(marks[i])
      --vim.print(marks[i][1])
      vim.api.nvim_buf_del_extmark(buf, ns, marks[i][1])
    end
  end
  if M.marks then
    for k, _ in pairs(M.marks) do
      M.extmarks[k] = nil
    end
  end
end


M.tostring = function()
  local str = "Marks:\n[ID, ROW, COL]\n"
  for _, v in pairs(M.extmarks) do
    str = str .. string.format("{ {%d}, { %d, %d } }\n", v.id, v[1].row - 1, v[1].col - 1)
  end
  return str
end

M.print_mark = function(m)
  if m then
    print(string.format(
      "Mark:{id=%d, row=%d, col=%d}", m.id, m.col, m.row)
    )
  end
end

-- look below























-- just making it longer file
return M
