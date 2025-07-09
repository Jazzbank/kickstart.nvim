local breakpoints = require 'dap.breakpoints'
local HOME = os.getenv 'HOME'

function SaveBreakpoints()
  local bps = {}
  for buf, buf_bps in pairs(breakpoints.get()) do
    local file = vim.api.nvim_buf_get_name(buf)
    bps[file] = buf_bps
  end
  local fp = io.open(HOME .. '/.cache/dap/breakpoints.json', 'w')
  fp:write(vim.fn.json_encode(bps))
  fp:close()
end

function LoadBreakpoints()
  local fp = io.open(HOME .. '/.cache/dap/breakpoints.json', 'r')
  if not fp then
    return
  end
  local content = fp:read '*a'
  fp:close()
  local bps = vim.fn.json_decode(content)
  for path, buf_bps in pairs(bps) do
    for _, bp in pairs(buf_bps) do
      local opts = {
        condition = bp.condition,
        log_message = bp.logMessage,
        hit_condition = bp.hitCondition,
      }
      breakpoints.set(opts, vim.fn.bufnr(path, true), bp.line)
    end
  end
end
