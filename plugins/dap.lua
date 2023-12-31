local dap = require "dap"
-- local function get_spring_boot_runner(profile, debug)
--   local debug_param = ""
--   if debug then
--     debug_param = ' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005" '
--   end
--
--   local profile_param = ""
--   if profile then
--     profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
--   end
--
--   return './gradlew bootRun --args=' .. profile_param .. debug_param
-- end
--
-- local function run_spring_boot(debug)
--   vim.cmd('term ' .. get_spring_boot_runner(nil, debug))
-- end
-- -- vim.keymap.set("n", "<F9>", function() run_spring_boot() end)
-- -- vim.keymap.set("n", "<leader>dS", function() run_spring_boot(true) end)
--

return {
  "jay-babu/mason-nvim-dap.nvim",
  config = function ()
    dap.adapters.java = function(callback)
      callback {
        type = "server",
        host = "127.0.0.1",
        port = 5005,
      }
    end
    dap.configurations.java = {
      {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
      },
    }
  end,
}
