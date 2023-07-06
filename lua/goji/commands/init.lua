local http = require("goji.request.http")
local user_queries = require("goji.request.queries.user")
local builder = require("goji.request.query_builder")
local log = require("goji.log")
local M = {}

function M.setup()
  vim.api.nvim_create_user_command("Goji", function(opts)
    require("goji.commands").goji(unpack(opts.fargs))
  end, { nargs = "*" })

  M.commands = {
    issue = function()
      local status, body = http.graphql("default", user_queries.get_user_info())
      print(status)
      log.info(vim.inspect(body))
    end,
    query = function()
      log.info(vim.inspect(builder.build_request({
        type = "jira",
        query = [[
          issueByKey($cloudId, $key) {
            name
          }
        ]],
        name = "GetIssueInfo",
        variables = {
          cloudId = { type = "ID" },
          key = { "AA-1111", type = "String" },
        },
      }, "default")))
    end,
  }
end

function M.goji(subcmd)
  subcmd = subcmd or "issue"

  if not M.commands[subcmd] then
    print("Unknown command")
  else
    M.commands[subcmd]()
  end
end

return M
