local http = require("goji.request.http")
local issue_queries = require("goji.request.queries.issue")
local builder = require("goji.request.query_builder")
local log = require("goji.log")

return function(args)
  if not args[1] then
    print("Missing argument")
    return
  end
  local params = {
    type = "jira",
    query = issue_queries.get_issue_details(),
    name = "GetIssueDetails",
    variables = {
      cloudId = { type = "ID" },
      key = { args[1], type = "String" },
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
  log.info(vim.inspect(out))
end
