local config = require("goji.config")
local commands = require("goji.commands")
local log = require("goji.log")

local M = {}

local function check_dependency(name, url)
  local res, _ = pcall(require, name)
  if not res then
    log.error("Missing dependency '", name, "'. See: ", url)
  end
  return res
end

---@return boolean
local function check_dependencies()
  local deps_loaded = {
    check_dependency("plenary", "https://github.com/nvim-lua/plenary.nvim"),
  }

  local loaded = true
  for _, v in ipairs(deps_loaded) do
    loaded = not v and false or loaded
  end
  return loaded
end

---Setup goji plugin
---@param user_config GojiConfig personal config to customize plugin
function M.setup(user_config)
  if check_dependencies() then
    config.setup(user_config)
    commands.setup()
  end
end

return M
