local IssueView = require("goji.ui.views.issue")
local issue_queries = require("goji.request.queries.issue")
local builder = require("goji.request.query_builder")
local git = require("goji.git")

---@param issue_key string i.e:AA-0000
---@return table?
local function get_jira_issue(issue_key)
  local result = builder
    .build_request({
      type = "jira",
      query = issue_queries.get_issue_details(),
      name = "GetIssueDetails",
      variables = {
        cloudId = { type = "ID" },
        key = { issue_key, type = "String" },
      },
      experimentals = "JiraIssue",
    }, "default")
    .call()

  if not result then
    return
  end

  local out = {}
  for _, v in pairs(result.jira.issueByKey.fields.edges) do
    out[v.node.fieldId] = v.node
  end
  return out
end

---Command issue
---@param args table<string>
return function(args)
  local issue = args[1] or git.get_branch()
  if not issue then
    print("Missing argument")
  else
    local data = get_jira_issue(issue)
    if data then
      local view = IssueView.new()
      view:render(data)
    end
  end
end
