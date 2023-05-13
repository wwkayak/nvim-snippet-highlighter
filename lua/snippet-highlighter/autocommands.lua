local api = vim.api

local su = require("snippet-highlighter.buffer.snippet_util")
local bu = require("snippet-highlighter.buffer.buf_util")
local mark = require("snippet-highlighter.marks.marks")
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
    pattern = "lua",
    group = augroup,
    callback = function(args)
      if vim.bo[args.buf].buflisted then
        if su.has_luasnip(args.buf) then
          M.mark_snippets(args.buf)
        end
      end
    end
  })

  api.nvim_create_autocmd({ 'WinClosed' }, {
    group = augroup,
    callback = function(args)
      if win_id and snippets_buf == args.buf then
        vim.api.nvim_win_close(win_id, false)
      end
    end
  })

  ---[[
  api.nvim_create_autocmd({ 'BufWinEnter' }, {
    group = augroup,
    callback = function(args)
      if vim.bo[args.buf].buflisted then
        if su.has_luasnip(args.buf) then
          M.mark_snippets(args.buf)
        end
      end
    end
  })
  --]]
end

M.mark_snippets = function(buf)
  snippets_buf = buf
  su.find_luasnip_shortcuts(buf)
  win_id = bu.create_snippets_float(su:shortcuts_tolines())
  mark.set_random_extmarks(buf, 10)
  vim.api.nvim_buf_set_option(buf, "buflisted", true)
end

M.setup()

return M
