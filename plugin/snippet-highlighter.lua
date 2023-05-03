
local ntfy = require("notify")

ntfy.notify("Creating User Commands...", "", {title="snippet-highlighter"})

vim.api.nvim_create_user_command("SnippetHighlighter",
  function(opts)
    ntfy.notify("UserCommand: SnippetHighlighter")
  end,
  {}
)

