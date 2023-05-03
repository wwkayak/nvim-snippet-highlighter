
local su = require("buffer.snippet_util")
local bu = require("buffer.buf_util")

local filename = "snippet-snippets.lua"
local bn = bu.find_buf_number(filename)

su:print_snippet_info(bn)
require"notify"("marking snippets...")
su.set_snippet_highlights(bn)

