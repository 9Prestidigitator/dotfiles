local dap = require "dap"
require("dapui").setup()
require("mason-nvim-dap").setup {
  automatic_setup = true,
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      -- Use the virtualenv if available
      local venv_path = os.getenv "VIRTUAL_ENV"
      if venv_path then
        return venv_path .. "/bin/python"
      else
        return "/usr/bin/python"
      end
    end,
  },
}

dap.configurations.cpp = {
  {
    type = "codelldb",
    request = "launch",
    name = "Launch CPP",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
  },
}

dap.adapters.codelldb = {
  name = "codelldb server",
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}
