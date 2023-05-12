local bu = require("snippet-highlighter.buffer.buf_util")
local m = require("snippet-highlighter.marks.marks")
local buf

buf = bu.find_buf_number("snippet-defines.lua")

if not buf then
  buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, './snippet-defines.lua')
  vim.api .nvim_buf_call(buf, vim.cmd.edit)
end

vim.print(vim.fn.getbufinfo(buf)[1].hidden)
if vim.fn.getbufinfo(buf)[1].hidden == 0 then
  m.set_random_extmarks(buf , 10)
end
--m.clear_marks(buf)

