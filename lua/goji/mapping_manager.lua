local config = require("goji.config")
local M = {}

---@param view GojiView
function M.apply_mapping(view)
  local mappings = config.values.mappings[view.config_category] or {}
  for name, mapping in pairs(mappings) do
    local action
    if type(mapping) == "string" then
      action = view.actions[mapping]
    elseif type(mapping) == "function" then
      action = mapping
    elseif type(mapping) == "table" then
      action = mapping[1]
    end

    if action then
      vim.keymap.set("n", name, action, {
        silent = true,
        noremap = true,
        nowait = true,
        buffer = view.buffer.buf,
      })
    end
  end
end

return M
