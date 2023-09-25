local log = require("goji.log")
local config = require("goji.config")

---Command add_host
---@param args table<string>
return function(args)
  if #args < 4 then
    print("Missing arguments. Usage: Goji add_host <name> <url> <cloudId> <token>")
  else
    local name, url, cloudId, token = unpack(args)
    log.info("name: " .. name .. " url: " .. url .. " cloudId: " .. cloudId .. " token: " .. token)
    config.add_host(name, url, cloudId, token)
  end
end
