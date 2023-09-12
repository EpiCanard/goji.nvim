local config = require("goji.config")
local M = {}

---@param builder UIBuilder
---@param view GojiView
function M.render(builder, view)
  local keys = config.values.mappings[view.config_category]
  local out
  for key, action in pairs(keys) do
    local desc
    if type(action) == "string" then
      desc = view.action_descriptions[action]
    elseif type(action) == "table" then
      desc = action.description
    end
    if desc then
      out = (out and out .. " / " or "") .. "[" .. key .. "] " .. desc
    end
  end
  builder:append("Keybindings: " .. out):nl()
end

return M
