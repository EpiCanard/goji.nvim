local http = require("goji.request.http")
local IssueView = require("goji.ui.views.issue")
local issue_queries = require("goji.request.queries.issue")
local builder = require("goji.request.query_builder")

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
    out[v.node.fieldId] = v.node
  end
  return out
end

return function(args)
  if not args[1] then
    print("Missing argument")
    return
  end
  local data = get_jira_issue(args[1])
  if data then
    local view = IssueView.new()
    view:render(data)
  end
end
