local dap = require 'dap'
local codelldb_path = vim.fn.expand '$MASON/packages/codelldb/extension/adapter/codelldb'

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = codelldb_path,
    args = { '--port', '${port}' },
  },
}

dap.configurations.cpp = {
  {
    name = 'Launch file',
    type = 'codelldb',
    request = 'launch',
    program = function()
      local source = vim.api.nvim_buf_get_name(0)
      local exe = source:gsub('%.cpp$', '')
      if exe then
        return exe
      end
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
