local api = vim.api
local su = require("snippet-highlighter.buffer.snippet_util")
local ntfy = require("notify")


local group = api.nvim_create_augroup('snippet-highlighter', { clear = true })

local M = {}

M.setup = function()
  ntfy.notify("autocommands.lua: Creating autocommands...", "",
    { title = "snippet-highlighter/autocommands.lua" }
  )

    api.nvim_clear_autocmds({ group = group })

    api.nvim_create_autocmd({ 'FileType' }, {
    pattern = "lua",
    group = group,
    callback = function(args)
      local str = string.format("autocommands.lua: %s event", args.event)
      ntfy.notify(str, "", { title = args.file .. ': ' .. args.match})
      su.has_snippets(args.buf)
    end
  })
end

M.setup()

return M
