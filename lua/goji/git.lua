local Job = require("plenary.job")
local tbl = require("plenary.tbl")

local M = {}

local function git(...)
  local job = Job:new({
    enable_recording = true,
    command = "git",
    args = tbl.pack(...),
  })
  return job:sync()
end

---@return string?
function M.get_branch()
  local result = git("rev-parse", "--abbrev-ref", "HEAD")
  if not result or not result[1] then
    return nil
  end
  return result[1]
end

return M
