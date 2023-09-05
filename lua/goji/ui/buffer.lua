local log = require("goji.log")
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local Buffer = {}
Buffer.__index = Buffer

function Buffer.new(config)
  local self = {
    buf_name = config.name,
    kind = config.kind or "tabnew",
    buf = nil,
  }

  setmetatable(self, Buffer)

  return self
end

function Buffer:open()
  self:_init_buffer()
  cmd(self.kind)
  api.nvim_set_current_buf(self.buf)
  local win = api.nvim_get_current_win()
  api.nvim_set_option_value("number", false, { win = win })
  api.nvim_set_option_value("relativenumber", false, { win = win })
end

function Buffer:close()
  api.nvim_buf_delete(self.buf, {})
end

function Buffer:_init_buffer()
  if self.buf == nil then
    self.buf = fn.bufnr(self.buf_name)
    if self.buf == -1 then
      self.buf = api.nvim_create_buf(false, false)
      api.nvim_buf_set_name(self.buf, self.buf_name)
    end
  end
  self:set_option("buftype", "nofile")
  self:set_option("swapfile", false)
  self:set_option("bufhidden", "wipe")
  self:set_option("filetype", self.buf_name)
end

function Buffer:render(content)
  if self.buf == nil then
    log.error("The buffer is not opened")
    return
  end
  api.nvim_buf_set_lines(self.buf, 0, -1, false, content)
  self:lock()
end

function Buffer:set_option(name, value)
  api.nvim_set_option_value(name, value, { buf = self.buf })
end

function Buffer:lock()
  self:set_option("readonly", true)
  self:set_option("modifiable", false)
end

return Buffer
