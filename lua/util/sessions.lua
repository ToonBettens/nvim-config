local MiniPick = require('mini.pick')
local M = {}

function M.start_session()
  vim.ui.input({ prompt = 'Session name: '}, function(input)
    if input and input ~= '' then
      MiniSessions.write(input)
    end
  end)
end

function M.delete_session_picker()
  local detected = {}
  for session, _ in pairs(MiniSessions.detected or {}) do
    table.insert(detected, session)
  end
  vim.print(detected)
  MiniPick.start({
    source = {
      name = "Delete sessions",
      items = detected,
      choose = function(item)
        if not item then return end
        MiniSessions.delete(item)
      end,
      choose_marked = function(items)
        if not items or #items == 0 then return end
        for _, item in ipairs(items) do
          MiniSessions.delete(item)
        end
      end,
    },
  })
end

return M
