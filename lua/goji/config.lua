local M = {}

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

function M.setup(user_config)
  M.values = vim.tbl_deep_extend("force", default, user_config or {})
end

return M
