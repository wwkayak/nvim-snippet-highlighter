
local M = {}
local marks = {}

M.set_extmark = function(id, r, c)
  table.insert(marks, {id = id, row = r,col = c})
end


M.get_extmark = function(id)
  for k, v in pairs(marks) do
    if v.id == id then
      return marks[k]
    end
  end
end

M.get_extmarks = function ()
  return marks
end

M.tostring = function()
  local str = "Marks:\n{id, row. col}\n"
  for _, v in pairs(marks) do
    str = str .. string.format("{%d, %d, %d}\n", v.id, v.row, v.col)
  end
  vim.print(str)
end

M.print_mark = function(m)
  if m then
    print(string.format(
      "Mark:{id=%d, row=%d, col=%d}", m.id, m.col, m.row )
    )
  end
end

return M
