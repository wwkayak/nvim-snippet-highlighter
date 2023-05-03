local su = require("snippet-highlighter.buffer.snippet_util")
local bu = require("snippet-highlighter.buffer.buf_util")
local ntfy = require("notify")


local M = {}

M.setup = function()
  ntfy.notify("M.setup() called.", "", {title = "snippet-highlighter/init.lua"} )
  require("autocommands")
end

M.setup()

return M





