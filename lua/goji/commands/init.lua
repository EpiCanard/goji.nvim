local http = require("goji.request.http")
local user_queries = require("goji.request.queries.user")
local issue_queries = require("goji.request.queries.issue")
local builder = require("goji.request.query_builder")
local log = require("goji.log")
local M = {}

local function filter_commmands(commands, search)
  local filtered = {}

  for _, cmd in pairs(commands) do
    if string.sub(cmd, 1, #search) == search then
      table.insert(filtered, cmd)
    end
  end

  return filtered
end

local function tab_complete(arg, cmd_line)
  local args = vim.split(vim.trim(cmd_line), " ")
  local commands = vim.tbl_keys(M.commands)

  if #args == 1 then
    return commands
  elseif #args == 2 then
    return filter_commmands(commands, arg)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("Goji", function(opts)
    require("goji.commands").goji(unpack(opts.fargs))
  end, { complete = tab_complete, nargs = "*" })

  M.commands = {
    issue = function(args)
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
      local status, body =
        http.graphql("default", builder.build_request(params, "default"), params.variables, "JiraIssue")
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

function M.goji(subcmd, ...)
  subcmd = subcmd or "issue"
  local args = { ... }

  if not M.commands[subcmd] then
    print("Unknown command")
  else
    M.commands[subcmd](args)
  end
end

return M
