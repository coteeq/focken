local _M = {}

local cmd_meta = {
  __call = function(self, ...)
    return self.fn(...)
  end
}

local function cmd(name, doc, fn)
  local f = {
    name = name,
    doc = doc or name,
    fn = fn,
  }

  setmetatable(f, cmd_meta)
  _M[name] = f
  return f
end

cmd(
  "toggle_cmdline",
  -- "Toggle cmdline height",
  nil,
  function()
    vim.o.cmdheight = vim.o.cmdheight > 0 and 0 or 1
  end
)

function _M.map(mode, keys, name)
  vim.keymap.set(mode, keys, _M[name].fn, { desc = _M[name].doc })
end

return _M
