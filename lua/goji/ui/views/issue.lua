local Buffer = require("goji.ui.buffer")

local M = {}
function M.build_components(data)
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

function M.render(data)
  if data == nil then
    return
  end

  local buf = Buffer:new({
    name = "GojiIssue",
  })
  buf:open()
  buf:render(M.build_components(data))
  buf:lock()
end

return M
