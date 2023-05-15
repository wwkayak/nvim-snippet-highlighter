local colors = require("tokyonight.colors").setup()
local color_util = require("tokyonight.util")
local types = require("luasnip.util.types")
local api = vim.api

local M = {}

local set_snippet_highlights = function()
  local names = types.names_pascal_case
  for i = 1, #names do
    local imod = (i-1)%7+1
    api.nvim_set_hl(0, 'Snippet'..names[i], { link = "rainbowcol".. imod , default = true})
  end

end

M.setup = function()
  set_snippet_highlights()
end


M.setup()


return M
