
local bu = require("buffer.buf_util")
local marks = require("marks.marks")

marks.mt.__tostring = marks.tostring

local buf = bu.find_buf_number("marks.lua")

local count = 10

local clr = marks.clear_marks
local set = marks.set_random_extmarks

set(buf, count)
print(marks.get_extmarks())

