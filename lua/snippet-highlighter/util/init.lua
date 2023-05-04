
local M = {}

local pat = "([^/]+%.lua)"

M.strip_name = function(pathname)
  return string.match(pathname, pat)
end

return M
