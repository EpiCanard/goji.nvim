local Buffer = require("goji.ui.buffer")
local UIBuilder = require("goji.ui.util.ui_builder")
local mapping_manager = require("goji.mapping_manager")
local keybindings = require("goji.ui.components.keybindings")

local IssueView = {}
IssueView.__index = IssueView

--[[ Local functions --]]
local function build_components(data)
  local title = data["summary"].text
  local desc = data["description"].richText.adfValue.convertedPlainText.plainText
  local descs = {}
  for s in desc:gmatch("[^\r\n]+") do
    table.insert(descs, s)
  end

  return {
    "Title :",
    title,
    "",
    "Description :",
    unpack(descs),
  }
end

--[[ Methods --]]
function IssueView.new()
  local self = {
    buffer = Buffer.new({
      name = "GojiIssue",
    }),
    config_category = "issue",
  }
  setmetatable(self, IssueView)

  self.actions = {
    ["close"] = function()
      self.buffer:close()
    end,
  }

  self.action_descriptions = {
    ["close"] = "Close view",
  }
  return self
end

function IssueView:open()
  self.buffer:open()
  mapping_manager.apply_mapping(self)
end

function IssueView:render(data)
  if data == nil then
    return
  end

  self:open()
  local builder = UIBuilder.new()
  keybindings.render(builder, self)
  builder:append(build_components(data))
  self.buffer:render(builder.components)
  self.buffer:lock()
end

return IssueView
