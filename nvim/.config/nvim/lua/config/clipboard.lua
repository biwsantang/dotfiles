local M = {}

function M.setup()
  -- Set clipboard to use system clipboard
  vim.opt.clipboard = "unnamedplus"
  
  -- This makes all yank, delete, change and put operations use the system clipboard
  -- y, yy, Y, d, dd, D, c, cc, C, x, X, p, P will all use system clipboard
  
  -- Optional: Create specific keymaps if you want to preserve both behaviors
  -- These allow you to use the vim register when needed
  -- Removed <leader>y to avoid conflicts with special yank commands
  vim.keymap.set({"n", "v"}, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
  vim.keymap.set({"n", "v"}, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })
  
  -- Optional: Keep delete operations from affecting clipboard
  -- Uncomment these if you don't want delete to overwrite your clipboard
  -- vim.keymap.set({"n", "v"}, "d", '"_d', { desc = "Delete without affecting clipboard" })
  -- vim.keymap.set({"n", "v"}, "D", '"_D', { desc = "Delete to end of line without affecting clipboard" })
  -- vim.keymap.set({"n", "v"}, "x", '"_x', { desc = "Delete char without affecting clipboard" })
  
  -- Special yank with context for AI chats
  vim.keymap.set("v", "<leader>yc", function()
    -- First, yank the selection to get it in the register
    vim.cmd('normal! "vy')
    
    -- Get the selected text lines by using vim.fn.getpos and proper range
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local start_col = vim.fn.col("'<")
    local end_col = vim.fn.col("'>")
    
    -- Get the lines including partial line selections
    local lines = {}
    for i = start_line, end_line do
      local line = vim.fn.getline(i)
      if i == start_line and i == end_line then
        -- Single line selection
        line = string.sub(line, start_col, end_col)
      elseif i == start_line then
        -- First line of multi-line selection
        line = string.sub(line, start_col)
      elseif i == end_line then
        -- Last line of multi-line selection
        line = string.sub(line, 1, end_col)
      end
      table.insert(lines, line)
    end
    
    -- Get file path and info
    local filepath = vim.fn.expand("%:p")
    local relative_path = vim.fn.expand("%:.")
    local filename = vim.fn.expand("%:t")
    
    -- Format the output for AI
    local formatted = string.format(
      "File: %s\nLines: %d-%d\n\n```%s\n%s\n```",
      relative_path,
      start_line,
      end_line,
      vim.bo.filetype,
      table.concat(lines, "\n")
    )
    
    -- Copy to clipboard
    vim.fn.setreg("+", formatted)
    vim.notify(string.format("Copied %d lines with context to clipboard", #lines), vim.log.levels.INFO)
  end, { desc = "Yank with file context for AI" })
  
  -- Yank current line with context
  vim.keymap.set("n", "<leader>yc", function()
    local line_num = vim.fn.line(".")
    local line_content = vim.fn.getline(".")
    local relative_path = vim.fn.expand("%:.")
    
    local formatted = string.format(
      "File: %s\nLine: %d\n\n```%s\n%s\n```",
      relative_path,
      line_num,
      vim.bo.filetype,
      line_content
    )
    
    vim.fn.setreg("+", formatted)
    vim.notify("Copied line with context to clipboard", vim.log.levels.INFO)
  end, { desc = "Yank line with file context for AI" })
  
  -- Yank entire function/method with context
  vim.keymap.set("n", "<leader>yf", function()
    -- Use treesitter to select function
    local ts_utils = require('nvim-treesitter.ts_utils')
    local node = ts_utils.get_node_at_cursor()
    
    -- Find the function node
    while node do
      local node_type = node:type()
      if node_type:match("function") or node_type:match("method") or 
         node_type:match("declaration") or node_type:match("definition") then
        break
      end
      node = node:parent()
    end
    
    if node then
      local start_row, start_col, end_row, end_col = node:range()
      local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
      local relative_path = vim.fn.expand("%:.")
      
      local formatted = string.format(
        "File: %s\nLines: %d-%d\n\n```%s\n%s\n```",
        relative_path,
        start_row + 1,
        end_row + 1,
        vim.bo.filetype,
        table.concat(lines, "\n")
      )
      
      vim.fn.setreg("+", formatted)
      vim.notify(string.format("Copied function (%d lines) with context to clipboard", #lines), vim.log.levels.INFO)
    else
      vim.notify("No function found at cursor", vim.log.levels.WARN)
    end
  end, { desc = "Yank function with file context for AI" })
  
  -- Yank with git blame context (useful for understanding code history)
  vim.keymap.set({"n", "v"}, "<leader>yg", function()
    local mode = vim.fn.mode()
    local start_line, end_line
    
    if mode == "v" or mode == "V" then
      start_line = vim.fn.line("'<")
      end_line = vim.fn.line("'>")
    else
      start_line = vim.fn.line(".")
      end_line = start_line
    end
    
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local relative_path = vim.fn.expand("%:.")
    
    -- Get git blame info if available
    local git_info = ""
    local handle = io.popen(string.format("git blame -L %d,%d %s 2>/dev/null | head -1", 
      start_line, end_line, vim.fn.expand("%:p")))
    if handle then
      local blame = handle:read("*a")
      handle:close()
      if blame and blame ~= "" then
        git_info = "\nGit: " .. blame:match("%((.-)%s+%d+%)")  or ""
      end
    end
    
    local formatted = string.format(
      "File: %s\nLines: %d-%d%s\n\n```%s\n%s\n```",
      relative_path,
      start_line,
      end_line,
      git_info,
      vim.bo.filetype,
      table.concat(lines, "\n")
    )
    
    vim.fn.setreg("+", formatted)
    vim.notify("Copied with git context to clipboard", vim.log.levels.INFO)
  end, { desc = "Yank with git blame context for AI" })
  
  vim.notify("System clipboard integration enabled", vim.log.levels.INFO)
end

return M