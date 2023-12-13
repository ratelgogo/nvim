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

function attach_to_debug()
  dap.adapters.java = function(callback)
  -- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
  -- The response to the command must be the `port` used below
  callback({
    type = 'server';
    host = '127.0.0.1';
    port = 5005;
  })
end
  dap.configurations.java = {
    {
      type = "java",
      request = "attach",
      name = "Attach to the process",
      hostName = "127.0.0.1",
      port = 5005,
    },
  }
  dap.continue()
end

vim.keymap.set("n", "<leader>da", ":lua attach_to_debug()<CR>")
local jdtls = require("jdtls")

local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
local config = {
  init_options = {
    bundles = {
      vim.fn.glob(java_debug_path .. "com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
    },
  },
  on_attach = function() jdtls.setup_dap { hotcodereplace = "auto" } end,
}

jdtls.start_or_attach(config)

return {}
