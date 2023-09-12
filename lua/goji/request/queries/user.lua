local M = {}

---@return string
function M.get_user_info()
  return [[
    query GetUserInfo {
      me {
        user {
          name
        }
      }
    }
    ]]
end

return M
