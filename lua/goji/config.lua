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

M.values = default

--- Setup to override default config
---@param user_config GojiConfig
function M.setup(user_config)
  M.values = vim.tbl_deep_extend("force", default, user_config or {})
end

return M
