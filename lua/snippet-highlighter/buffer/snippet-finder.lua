

local M = {}

  M.get_luasnip_shortcuts = function(buf)
    local ls_name_pattern = "(%a+)%s*=%s*require%(%s*%\"luasnip%\"%s*%)"
    local ls_shortcuts_pattern
    local ls_name
    local ls_shortcuts = {}

    local count = vim.api.nvim_buf_line_count(buf)
    if count > 0 then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, count, true)
      for i = 1, #lines do
        _, _, ls_name = string.find(lines[i], ls_name_pattern )
        if ls_name ~= nil then
          break
        end
      end
      ls_shortcuts_pattern = "(%a+)%s*=%s*" .. ls_name ..".%a+_node"
      local snippet_pattern = "(%a+)%s*=%s*" .. ls_name ..".snippet$"
      for i = 1, #lines do
        local _, _, shortcut =  string.find(lines[i], ls_shortcuts_pattern)
        local _, _, snippet_shortcut = string.find( lines[i], snippet_pattern)
        if shortcut ~= nil then
          table.insert(ls_shortcuts, shortcut)
        end
        if snippet_shortcut ~= nil then
          table.insert(ls_shortcuts, snippet_shortcut)
        end
      end
    end
    return(ls_shortcuts)
  end

return M
