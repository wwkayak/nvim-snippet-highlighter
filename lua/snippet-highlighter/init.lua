local su = require("snippet-highlighter.buffer.snippet_util")
local bu = require("snippet-highlighter.buffer.buf_util")
local ntfy = require("notify")

local M = {}

M.setup = function()
  require("snippet-highlighter.autocommands")
end

M.setup()

return M
