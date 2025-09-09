return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('fzf-lua').setup{
        defaults = {
          git_icons = false,  -- Updated from deprecated global_git_icons
        },
        file_ignore_patterns = {
          "node_modules",
          ".git",
          ".next",
          "dist",
          "build"
        },
        files = {
          fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude .next --exclude dist --exclude build]],
          rg_opts = [[--files --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!.next/*" --glob "!dist/*" --glob "!build/*"]],
          find_opts = [[-type f -not -path "*/node_modules/*" -not -path "*/.git/*"]],
        },
        grep = {
          rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!.next/*" --glob "!dist/*" --glob "!build/*" -e]],
          exclude = {"node_modules", ".git", ".next", "dist", "build"},
        },
      }
      
      local fzf = require('fzf-lua')
      vim.keymap.set({ 'n', 'v' }, '<Leader>ff', fzf.files, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fa', function()
        fzf.files({ fd_opts = "--color=never --type f --hidden --follow --no-ignore" })
      end, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fr', fzf.live_grep, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fb', fzf.buffers, { noremap = true, silent = true })
      
      -- Treesitter integration
      vim.keymap.set({ 'n', 'v' }, '<Leader>ft', fzf.treesitter, { desc = "FZF Treesitter symbols" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fs', fzf.lsp_document_symbols, { desc = "FZF Document symbols" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fS', fzf.lsp_workspace_symbols, { desc = "FZF Workspace symbols" })
      
      -- Jump list with FZF
      vim.keymap.set('n', '<Leader>fj', function()
        local jumplist = vim.fn.getjumplist()
        local jumps = jumplist[1]
        
        if #jumps == 0 then
          vim.notify("Jump list is empty", vim.log.levels.INFO)
          return
        end
        
        local entries = {}
        
        -- Process jumps in reverse order (most recent first)
        for i = #jumps, 1, -1 do
          local jump = jumps[i]
          local bufnr = jump.bufnr
          
          if vim.api.nvim_buf_is_valid(bufnr) then
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
            local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
            
            -- Skip non-file buffers (tree panes, terminal, quickfix, etc.)
            local skip_filetypes = { 'NvimTree', 'neo-tree', 'nerdtree', 'CHADtree', 'fern', 'dirvish', 'netrw' }
            local skip_buftypes = { 'terminal', 'quickfix', 'nofile', 'help', 'prompt' }
            
            local should_skip = false
            for _, ft in ipairs(skip_filetypes) do
              if filetype == ft then
                should_skip = true
                break
              end
            end
            for _, bt in ipairs(skip_buftypes) do
              if buftype == bt then
                should_skip = true
                break
              end
            end
            
            -- Only include actual file buffers
            if bufname ~= "" and not should_skip and vim.fn.filereadable(bufname) == 1 then
              local filename = vim.fn.fnamemodify(bufname, ":~:.")
              local line = jump.lnum
              local col = jump.col + 1
              
              -- Try to get the line content
              local line_content = ""
              if vim.api.nvim_buf_is_loaded(bufnr) then
                local lines = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)
                if lines[1] then
                  line_content = lines[1]:gsub("^%s+", ""):sub(1, 80)
                end
              end
              
              -- Format: filename:line:col: content
              local entry = string.format("%s:%d:%d: %s", filename, line, col, line_content)
              table.insert(entries, entry)
            end
          end
        end
        
        if #entries == 0 then
          vim.notify("No valid jumps in jump list", vim.log.levels.INFO)
          return
        end
        
        -- Use fzf-lua's built-in file preview
        fzf.fzf_exec(entries, {
          prompt = "Jump List> ",
          previewer = "builtin",
          actions = {
            ['default'] = function(selected)
              if selected and selected[1] then
                -- Parse filename:line:col format
                local filename, line, col = selected[1]:match("^([^:]+):(%d+):(%d+):")
                if filename and line and col then
                  -- Open file and jump to position
                  vim.cmd("edit " .. vim.fn.fnameescape(filename))
                  vim.api.nvim_win_set_cursor(0, {tonumber(line), tonumber(col) - 1})
                end
              end
            end
          }
        })
      end, { desc = "FZF Jump list" })
      
      -- Custom treesitter search with query
      vim.keymap.set({ 'n', 'v' }, '<Leader>fq', function()
        -- Get all treesitter symbols in current buffer
        local parser = vim.treesitter.get_parser()
        if not parser then
          vim.notify("No treesitter parser available", vim.log.levels.WARN)
          return
        end
        
        local tree = parser:parse()[1]
        if not tree then return end
        
        local root = tree:root()
        local symbols = {}
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo.filetype
        
        -- Traverse tree and collect all named nodes
        local function traverse(node, depth)
          if node:named() then
            local start_row, start_col = node:start()
            local end_row, end_col = node:end_()
            local node_type = node:type()
            
            -- Get the text of the node (first line only for display)
            local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)
            local text = lines[1] or ""
            text = text:sub(start_col + 1):gsub("^%s+", ""):sub(1, 50)
            
            -- Create entry for fzf
            local entry = string.format("%s:%d:%d: [%s] %s", 
              vim.fn.expand("%:t"), 
              start_row + 1, 
              start_col + 1,
              node_type,
              text
            )
            
            table.insert(symbols, {
              entry = entry,
              row = start_row + 1,
              col = start_col + 1,
              type = node_type,
              text = text,
            })
          end
          
          for child in node:iter_children() do
            traverse(child, (depth or 0) + 1)
          end
        end
        
        traverse(root, 0)
        
        -- Create fzf entries
        local entries = {}
        for _, symbol in ipairs(symbols) do
          table.insert(entries, symbol.entry)
        end
        
        -- Show fzf with treesitter symbols
        fzf.fzf_exec(entries, {
          prompt = "Treesitter Symbols> ",
          preview = "bat --color=always --style=numbers,changes --line-range {2}:+20 " .. vim.fn.expand("%:p"),
          actions = {
            ['default'] = function(selected)
              if selected and selected[1] then
                -- Parse the selected line
                local row, col = selected[1]:match(":(%d+):(%d+):")
                if row and col then
                  vim.api.nvim_win_set_cursor(0, {tonumber(row), tonumber(col) - 1})
                end
              end
            end
          }
        })
      end, { desc = "FZF Treesitter query (all nodes)" })
    end,
  }
}
