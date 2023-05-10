local api = vim.api

local su = require("snippet-highlighter.buffer.snippet_util")
local bu = require("snippet-highlighter.buffer.buf_util")
local snippets_buf = nil
local win_id = nil

local augroup = api.nvim_create_augroup('snippet-highlighter', { clear = true })

local M = {}

M.setup = function()
  vim.api.nvim_create_user_command("SnippetShortcuts",
    function(_)
      if su.has_luasnip(0) then
        su.find_luasnip_shortcuts(0)
        su:shortcuts_tolines()
      end
    end,
    {}
  )

  api.nvim_clear_autocmds({ group = augroup })

  api.nvim_create_autocmd({ 'FileType' }, {
    group = augroup,
    callback = function(args)
      if su.has_luasnip(args.buf) then
        snippets_buf = args.buf
        su.find_luasnip_shortcuts(args.buf)
        win_id = bu.create_snippets_float(su:shortcuts_tolines())
      end
    end
  })

  api.nvim_create_autocmd({ 'WinClosed' }, {
    group = augroup,
    callback = function(args)
      if  win_id and snippets_buf == args.buf then
        vim.api.nvim_win_close(win_id, false)
      end
    end
  })
end

M.setup()

return M
