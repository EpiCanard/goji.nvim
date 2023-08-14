local http = require("goji.request.http")
local Buffer = require("goji.ui.buffer")
local issue_queries = require("goji.request.queries.issue")
local builder = require("goji.request.query_builder")
local log = require("goji.log")

local function get_jira_issue(issue_key)
  local params = {
    type = "jira",
    query = issue_queries.get_issue_details(),
    name = "GetIssueDetails",
    variables = {
      cloudId = { type = "ID" },
      key = { issue_key, type = "String" },
    },
  }
  local result = http.graphql("default", builder.build_request(params, "default"), params.variables, "JiraIssue")

  if not result then
    return
  end

  local out = {}
  for _, v in pairs(result.jira.issueByKey.fields.edges) do
    out[v.node.name] = v.node
  end
  return out
end

return function(args)
  if not args[1] then
    print("Missing argument")
    return
  end
  local out = get_jira_issue(args[1])
  local title = out["Summary"].text
  local desc = out["Description"].richText.adfValue.convertedPlainText.plainText
  local descs = {}
  for s in desc:gmatch("[^\r\n]+") do
    table.insert(descs, s)
  end
  local buf = Buffer:new({
    name = "GojiIssue",
  })
  buf:open()
  buf:render({
    "Title : ",
    title,
    "",
    "Description : ",
    unpack(descs),
  })
  buf:lock()
end
