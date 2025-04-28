require "nvchad.options"

-- add yours here!

-- Automatically set VIRTUAL_ENV if not already set
local function auto_set_virtualenv()
  if os.getenv("VIRTUAL_ENV") ~= nil then
    return -- already set, nothing to do
  end

  local cwd = vim.fn.getcwd() -- current project folder
  local handle = vim.loop.fs_scandir(cwd)
  if not handle then return end

  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end

    -- Look for directories containing "env"
    if type == "directory" and string.find(name, "env") then
      local possible_venv = cwd .. "/" .. name
      -- Check if it has bin/activate (real venv)
      if vim.fn.filereadable(possible_venv .. "/bin/activate") == 1 then
        vim.env.VIRTUAL_ENV = possible_venv
        print("🌟 Detected and set VIRTUAL_ENV to: " .. possible_venv)
        return
      end
    end
  end
end

auto_set_virtualenv()

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
