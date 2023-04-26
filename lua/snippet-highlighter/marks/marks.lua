require("math")

local M = {}

M.extmarks = {}
M.mt = {}
setmetatable(M.extmarks, M.mt)
setmetatable(M, M.mt)
M.mt.__tostring =  M.tostring

local ns = vim.api.nvim_create_namespace("snippet-highlighter")

M.set_random_extmarks = function(count)
  math.randomseed(os.time())
  for _ = 0, count do
    local id = math.random(1, 10)
    if not M.get_extmark(id) then
      M.set_extmark(id , math.random(0, 1000), math.random(0, 80))
    end
  end
  return M.extmarks
end

M.set_extmark = function(id, r, c)
  if not M.get_extmark(id) then
    table.insert(M.extmarks, { id = id, { row = r, col = c } })
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

M.clear_marks = function()
  for _, v in pairs(M.extmarks) do
    M.del_ext_mark(0, v.id)
  end
end

M.tostring = function()
  local str = "Marks:\n[ID, ROW, COL]\n"
  for _, v in pairs(M.extmarks) do
    str = str .. string.format("{ {%d}, { %d, %d } }\n", v.id, v[1].row, v[1].col)
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

return M
