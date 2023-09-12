local levels = {
  error = "ErrorMsg",
  warn = "WarningMsg",
  info = "None",
  debug = "Comment",
}

local function format_message(...)
  local msg = ""
  for _, v in ipairs({ ... }) do
    if type(v) == "table" then
      msg = msg .. vim.inspect(v)
    else
      msg = msg .. tostring(v)
    end
  end
  return msg
end

local function log(level)
  return function(...)
    local msg = format_message(...)
    vim.api.nvim_echo({
      { string.format("[goji][%s] %s", level:upper(), msg), levels[level] },
    }, false, {})
  end
end

---@class Log
---@field error fun(...: string): nil Log error message
---@field warn fun(...: string): nil Log warning message
---@field info fun(...: string): nil Log info message
---@field debug fun(...: string): nil Log debug message
local M = {}

for k, _ in pairs(levels) do
  M[k] = log(k)
end

return M
