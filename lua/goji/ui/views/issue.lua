local Buffer = require("goji.ui.buffer")
local mapping_manager = require("goji.mapping_manager")

local IssueView = {}
IssueView.__index = IssueView

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

  return self
end

function IssueView.build_components(data)
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

function IssueView:open()
  self.buffer:open()
  mapping_manager.apply_mapping(self)
end

function IssueView:render(data)
  if data == nil then
    return
  end

  self:open()
  self.buffer:render(IssueView.build_components(data))
  self.buffer:lock()
end

return IssueView
