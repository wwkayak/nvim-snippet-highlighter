local bu = require("snippet-highlighter.buffer.buf_util")
local m = require("snippet-highlighter.marks.marks")
local buf

buf = bu.find_buf_number("snippet-defines.lua")

if not buf then
  buf = vim.fn.bufadd("snippet-defines.lua")
  vim.fn.bufload(buf)
  vim.api.nvim_buf_set_option(buf, 'buflisted', true)
end

--vim.print(vim.api.nvim_get_all_options_info())
vim.print(string.format("hidden: %s", vim.fn.getbufinfo(buf)[1].hidden == 1 ))
vim.print(string.format("buflisted: %s", vim.api.nvim_buf_get_option(buf, "buflisted")))


