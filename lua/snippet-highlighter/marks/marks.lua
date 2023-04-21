-- Handle creation, deletion, and tracking of extmarks
--
-- Data:
--  marks
--      ids
--      name?
--      signs
--      Virt_text
--
--  Highlights
--  Namespace
--  Luasnip types, etc?
--

local M = {}

local next_id = 1
local marks = {}
local ns = vim.api.nvim_create_namespace("MarkerMaker")

M.get_id = function()
  local id = next_id
  next_id = next_id + 1
  return id
end

-- Add a ton of other stuff here hl,virt,signs, :...
function M:set_extmark(buf, row, col, opts)
  print(opts.id)
  opts.id = opts.id or self.get_id()

  local new_id = vim.api.nvim_buf_set_extmark(buf, ns, row, col, opts)
  local is_new = true
  for _, v in pairs(marks) do
    if (new_id == v.id) then is_new = false end
  end
  if is_new then
    table.insert(marks, { id = new_id, row = row, col = col })
  end
end

M.get_extmarks = function(buf, first, last)
  local mks = vim.api.nvim_buf_get_extmarks(buf, ns, first, last, {details=true})
  vim.print("on page: ")
  for i = 1, #mks do
    vim.print(mks[i])
  end
  return marks
end

M.print_saved_extmarks = function()
  vim.print("saved marks: ")
  for i = 1, #marks do
    vim.print(marks[i])
  end
end


M.del_ext_mark = function(buf, id)
  local found = vim.api.nvim_buf_del_extmark(buf, nmsp, id)
  if found then
    table.remove(marks, id)
  end
end




return M
