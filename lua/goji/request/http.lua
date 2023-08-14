local curl = require("plenary.curl")
local config = require("goji.config")
local log = require("goji.log")

local M = {}

local function parse_url(host)
  return "https://" .. host .. "/gateway/api/graphql"
end

local function vars(variables, conf)
  local result = {}
  for k, v in pairs(variables) do
    local value
    if not v[1] then
      value = conf[k] or ""
    else
      value = v[1]
    end
    result[k] = value
  end
  return result
end

local function call_graphql(host_config, query, variables, experimentals)
  local url = parse_url(host_config.url)
  local opts = {
    headers = {
      content_type = "application/json",
      authorization = "Basic " .. host_config.token,
    },
    raw_body = vim.fn.json_encode({
      query = query,
      variables = vars(variables, host_config),
    }),
  }
  if experimentals then
    opts.headers["X-Experimentalapi"] = experimentals
  end

  return curl.post(url, opts)
end

local function handle_result(resp)
  local body = resp.status == 200 and vim.fn.json_decode(resp.body)

  if not body then
    log.error("Unexpected error during call of Jira : HttpStatus " .. resp.status)
    return nil
  end
  if body.errors then
    local message
    for _, v in pairs(body.errors) do
      if message then
        message = message .. ", "
      end
      message = (message and message or "") .. v.message
    end
    log.error("Unexpected error during call to Jira : " .. message)
    return nil
  else
    return body.data
  end
end

function M.graphql(host, query, variables, experimentals)
  local host_config = config.values.hosts[host]
  if not host or not host_config then
    return nil
  end

  local resp = call_graphql(host_config, query, variables, experimentals)

  return handle_result(resp)
end

return M
