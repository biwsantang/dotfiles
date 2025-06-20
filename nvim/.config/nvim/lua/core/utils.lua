local M = {}

function M.not_in_vscode()
  return vim.g.vscode == nil
end

function M.in_vscode()
  return vim.g.vscode ~= nil
end

return M
