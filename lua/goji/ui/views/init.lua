---@meta

---@class GojiView
---@field new function
---@field open fun(): nil
---@field render fun(table): nil
---@field config_category string Category inside config to use to find mappings
---@field actions {[string]: function} List of available actions that can be executed on this view
---@field action_descriptions {[string]: function} List of descriptions by action
---@field buffer GojiBuffer
