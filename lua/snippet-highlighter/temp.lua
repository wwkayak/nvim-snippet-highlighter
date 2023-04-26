
local marks = require("marks.marks")
marks.mt.__tostring = marks.tostring

local count = 10
marks.set_random_extmarks(count)

print(marks)

