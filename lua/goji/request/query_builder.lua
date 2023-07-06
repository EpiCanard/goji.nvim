local config = require("goji.config")
local M = {}

local function build_variables(variables, host)
  local result
  for k, v in pairs(variables) do
    result = result and result .. ", " or ""
    local value
    if not v[1] then
      value = config.values.hosts[host][k] or ""
    else
      value = v[1]
    end
    result = string.format('%s$%s: %s = "%s"', result, k, v.type, value)
  end
  return result
end

local function base_type(type, body)
  if not type then
    return body
  end
  return string.format("%s {\n%s\n}", type, body)
end

-- @params request table
-- {
-- name = ""
-- query = ""
-- mutation = ""
-- type = "jira"
-- variables = {cloudId = {type = "ID"}, key =  {"CT-1111", type="String"}}
-- }
function M.build_request(params, host)
  local base = params.query and "query" or "mutation"
  local body = params.query or params.mutation

  return string.format(
    "%s %s(%s) {\n%s\n}",
    base,
    params.name,
    build_variables(params.variables, host),
    base_type(params.type, body)
  )
end

return M
