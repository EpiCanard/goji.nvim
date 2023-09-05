local UIBuilder = {}
UIBuilder.__index = UIBuilder

function UIBuilder.new()
  local self = {
    components = {},
  }

  setmetatable(self, UIBuilder)

  return self
end

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

function UIBuilder:nl()
  table.insert(self.components, "")
  return self
end

return UIBuilder
