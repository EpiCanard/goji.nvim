local issue_command = require("goji.commands.issue")
local add_host_command = require("goji.commands.add_host")
local builder = require("goji.request.query_builder")
local Buffer = require("goji.ui.buffer")
local log = require("goji.log")
local config = require("goji.config")
local M = {}

---@param commands table<string>
---@param search string
---@return table<string>
local function filter_commmands(commands, search)
  local filtered = {}

  for _, cmd in pairs(commands) do
    if string.sub(cmd, 1, #search) == search then
      table.insert(filtered, cmd)
    end
  end

  return filtered
end

---@param arg string
---@param cmd_line string
---@return table<string>?
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
    issue = issue_command,
    add_host = add_host_command,
    hosts = function()
      log.info(vim.inspect(config.values.hosts))
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
    buf = function()
      local buff = Buffer.new({
        name = "Hello",
        kind = "tab",
      })
      buff:open()
      buff:render({ "Hello world" })
    end,
  }
end

---@param subcmd string
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
