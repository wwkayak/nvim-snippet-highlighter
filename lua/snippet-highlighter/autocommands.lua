local api = vim.api

local su = require("snippet-highlighter.buffer.snippet_util")
local bu = require("snippet-highlighter.buffer.buf_util")
local ntfy = require("notify")
local utils = require("snippet-highlighter.util")
local float_buf = nil

local augroup = api.nvim_create_augroup('snippet-highlighter', { clear = true })

local M = {}

M.setup = function()

  vim.api.nvim_create_user_command("SnippetShortcuts",
    function(opts)
      if su.has_luasnip(0) then
        su.find_luasnip_shortcuts(0)
        su:print_snippet_info(0)
      end
    end,
    {}
  )

  api.nvim_clear_autocmds({ group = augroup })

  api.nvim_create_autocmd({ 'FileType' }, {
    group = augroup,
    callback = function(args)
      if su.has_luasnip(args.buf) then
        su.find_luasnip_shortcuts(args.buf)
        float_buf = bu.create_snippets_float(su:print_snippet_info(args.buf))
      end
    end
  })

  api.nvim_create_autocmd({ 'BufHidden' }, {
    group = augroup,
    callback = function(args)
      vim.print(args)
    end
  })
end

M.setup()

return M
