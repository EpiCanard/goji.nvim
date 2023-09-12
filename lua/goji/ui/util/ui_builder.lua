---@class UIBuilder Builder used to build and concat all elements before rendering
---@field components table<string>
local UIBuilder = {}
UIBuilder.__index = UIBuilder

---@return UIBuilder
function UIBuilder.new()
  local self = {
    components = {},
  }

  setmetatable(self, UIBuilder)

  return self
end

---Add one or multiple rows
---@param row string|table Row(s) to add
---@return UIBuilder
function UIBuilder:append(row)
  if type(row) == "string" then
    table.insert(self.components, row)
  elseif type(row) == "table" then
    for _, value in ipairs(row) do
      table.insert(self.components, value)
    end
  else
    error("invalid type: " .. type(row), 2)
  end
  return self
end

---Add a new line
---@return UIBuilder
function UIBuilder:nl()
  table.insert(self.components, "")
  return self
end

return UIBuilder
