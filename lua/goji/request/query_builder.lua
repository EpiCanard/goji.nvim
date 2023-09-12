---@class JiraRequest
---@field name string
---@field type string
---@field query string
---@field mutation string
---@field variables table
---@field experimentals string

local config = require("goji.config")
local http = require("goji.request.http")
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

---Build graphql request
---@param request JiraRequest
---@param host string
---@return { call: fun(): table }
function M.build_request(request, host)
  local base = request.query and "query" or "mutation"
  local body = request.query or request.mutation

  local fullQuery = string.format(
    "%s %s(%s) {\n%s\n}",
    base,
    request.name,
    build_variables(request.variables, host),
    base_type(request.type, body)
  )
  return {
    call = function()
      return http.graphql(host, fullQuery, request.variables, request.experimentals)
    end,
  }
end

return M
