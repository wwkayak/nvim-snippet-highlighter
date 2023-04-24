
local m = require("marks.mark_manager")

m.set_extmark(22, 1, 2)
m.set_extmark(44, 3, 4)
m.set_extmark(66, 5, 6)
m.set_extmark(88, 7, 8)

m.tostring()
m.print_mark(m.get_extmark(22))

