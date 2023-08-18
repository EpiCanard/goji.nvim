local Buffer = require("goji.ui.buffer")

local IssueView = {}
IssueView.__index = IssueView

function IssueView:new()
  local view = {
    buf = Buffer:new({
      name = "GojiIssue",
    }),
  }
  setmetatable(view, self)

  return view
end

function IssueView.build_components(data)
  local title = data["summary"].text
  local desc = data["description"].richText.adfValue.convertedPlainText.plainText
  local descs = {}
  for s in desc:gmatch("[^\r\n]+") do
    table.insert(descs, s)
  end

  return {
    "Title : ",
    title,
    "",
    "Description : ",
    unpack(descs),
  }
end

function IssueView:render(data)
  if data == nil then
    return
  end

  self.buf:open()
  self.buf:render(IssueView.build_components(data))
  self.buf:lock()
end

return IssueView
