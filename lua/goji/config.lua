local M = {}

---@class Host
---@field url string Url of jira/atlassian server
---@field token string Token to access jira api
---@field cloudId string CloudId used to identify server

---@class Mappings
---@field issue {[string]: string|table|function}

---@class GojiConfig
---@field default_remote string The remote to check
---@field hosts { [string]: Host } List of hosts available
---@field mappings Mappings List of mappings used

---@type GojiConfig
local default = {
  default_remote = "origin",
  hosts = {},
  mappings = {
    issue = {
      ["q"] = "close",
    },
  },
}
local hosts_path = vim.fn.stdpath("data") .. "/" .. "goji-hosts.txt"

M.values = default

---Load hosts saved in data path
---@return {hosts:{[string]: Host}}
local function load_hosts()
  local file = io.open(hosts_path, "r")

  if not file then
    return {}
  end
  local hosts = {}
  while true do
    local line = file:read()
    if not line then
      break
    end
    local name, url, cloud_id, token = line:match("^(.-):(.-):(.-):(.-)$")

    hosts[name] = {
      url = url,
      cloudId = cloud_id,
      token = token,
    }
  end
  file:close()

  return {
    hosts = hosts,
  }
end

---Save current hosts in host file
local function save_hosts()
  local file = io.open(hosts_path, "w")
  if not file then
    return
  end
  for name, host in pairs(M.values.hosts) do
    file:write(string.format("%s:%s:%s:%s\n", name, host.url, host.cloudId, host.token))
  end
  file:close()
end

--- Setup to override default config
---@param user_config GojiConfig
function M.setup(user_config)
  local data_hosts = load_hosts()
  M.values = vim.tbl_deep_extend("force", default, data_hosts or {})
  M.values = vim.tbl_deep_extend("force", M.values, user_config or {})
  save_hosts()
end

function M.add_host(name, url, cloud_id, token)
  M.values.hosts[name] = {
    url = url,
    cloudId = cloud_id,
    token = token,
  }
  save_hosts()
end

return M
