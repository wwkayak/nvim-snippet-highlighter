
local api = vim.api

local su = require("snippet-highlighter.buffer.snippet_util")
local ntfy = require("notify")
local utils = require("snippet-highlighter.util")

local group = api.nvim_create_augroup('snippet-highlighter', { clear = true })

local M = {}

M.setup = function()

  ntfy.notify("Creating User Commands...", "", {title="plugin/init.lua"})

  vim.api.nvim_create_user_command("SnippetHighlighter",
    function(opts)
      ntfy.notify("UserCommand: SnippetHighlighter")
    end,
    {}
  )

  ntfy.notify("Creating autocommands...", "",
    { title = "snippet-highlighter/autocommands.lua" }
  )
  api.nvim_clear_autocmds({ group = group })

  api.nvim_create_autocmd({ 'FileType' }, {
    pattern = "lua",
    group = group,
    callback = function(args)
      local str = string.format("callback for %s event", args.event)
      ntfy.notify(str, "", { title = utils.strip_name(args.file) .. ': ' .. args.match })
      su.has_snippets(args.buf)
    end
  })

  api.nvim_create_autocmd({ 'InsertLeave', 'BufModifiedSet' }, {
    group = group,
    callback = function(args)
      local str = string.format("callback for %s event", args.event)
      ntfy.notify(str, "", { title = utils.strip_name(args.file) })
      --refind snippets based on marks?
    end
  })
end

M.setup()

return M
