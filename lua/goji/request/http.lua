local curl = require("plenary.curl")
local config = require("goji.config")

local M = {}

local function parse_url(host)
  return "https://" .. host .. "/gateway/api/graphql"
end

function M.graphql(host, query, variables)
  local host_config = config.values.hosts[host]
  if not host or not host_config then
    return nil
  end
  local url = parse_url(host_config.url)
  local opts = {
    headers = {
      content_type = "application/json",
      authorization = "Basic " .. host_config.token,
    },
    raw_body = vim.fn.json_encode({
      query = query,
      variables = variables,
    }),
  }
  print(url)
  print(vim.inspect(opts))
  local resp = curl.post(url, opts)

  print(vim.inspect(resp.body))
  local body = resp.status == 200 and vim.fn.json_decode(resp.body) or nil
  return resp.status, body
end

return M
