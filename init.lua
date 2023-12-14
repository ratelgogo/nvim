local function directory_exists(path)
  local f = io.popen("cd " .. path)
  if f == nil then return false end
  local ff = f:read "*all"

  if ff:find "ItemNotFoundException" then
    return false
  else
    return true
  end
end
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  -- delay update diagnostics
  update_in_insert = true,
})
local neovide_config = function()
  vim.o.guifont = "FiraCode Nerd Font:h16"
  -- vim.o.guifont = "Hack Nerd Font:h15"
  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_cursor_vfx_mode = "railgun"
  -- vim.g.neovide_cursor_vfx_mode = "torpedo"
  vim.g.neovide_no_idle = true
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_trail_length = 0.05
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_vfx_opacity = 200.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_speed = 20.0
  vim.g.neovide_cursor_vfx_particle_density = 5.0
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_confirm_quit = true
  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  -- vim.g.neovide_transparency = 0.8
  -- vim.g.transparency = 0.8
  -- vim.g.neovide_background_color = '#282c34'
end

if vim.fn.exists "g:neovide" then neovide_config() end
return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  -- colorscheme = "astrodark",
  colorscheme = "onedark",
  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    mappings = function(maps)
      if maps.n.gd then maps.n.gd[1] = function() vim.cmd "Lspsaga peek_definition" end end
      if maps.n.gI then maps.n.gI[1] = function() vim.lsp.buf.implementation() end end
      if maps.n.gr then maps.n.gr[1] = function() vim.lsp.buf.references() end end
      if maps.n.gy then maps.n.gy[1] = function() vim.lsp.buf.type_definition() end end
      -- if maps.n["<leader>lG"] then maps.n["<leader>lG"][1] = function() vim.lsp.buf.workspace_symbol() end end
      if maps.n["<leader>lR"] then maps.n["<leader>lR"][1] = function() vim.lsp.buf.references() end end

      return maps
    end,

    setup_handlers = {
      -- add custom handler
      jdtls = function(_, opts)
        vim.api.nvim_create_autocmd("Filetype", {
          pattern = "java", -- autocmd to start jdtls
          callback = function()
            if opts.root_dir and opts.root_dir ~= "" then
              opts["on_attach"] = function()
                -- require("jdtls.dap").setup_dap_main_class_configs()
                require("jdtls").setup_dap()
              end
              require("jdtls").start_or_attach(opts)
            end
          end,
        })
      end,
    },
    config = {
      -- set jdtls server settings
      jdtls = function()
        -- use this function notation to build some variables
        local root_markers = { "mvnw", "gradlew", "pom.xml", "build.gradle" }
        local root_dir = require("jdtls.setup").find_root(root_markers)

        local home = os.getenv "HOME"
        -- calculate workspace dir
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
        if
          workspace_dir
          and workspace_dir ~= nil
          and workspace_dir ~= ""
          and directory_exists(workspace_dir) == false
        then
          os.execute("mkdir " .. workspace_dir)
        end

        local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
        -- get the mason install path
        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

        -- get the current OS
        local os
        if vim.fn.has "macunix" then
          os = "mac"
        elseif vim.fn.has "win32" then
          os = "win"
        else
          os = "linux"
        end

        -- local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
        --   .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"

        local bundles = {}

        ---
        -- Include java-test bundle if present
        ---
        local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()

        local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")

        if java_test_bundle[1] ~= "" then vim.list_extend(bundles, java_test_bundle) end
        ---
        -- Include java-debug-adapter bundle if present
        ---
        local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()

        local java_debug_bundle =
          vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")

        if java_debug_bundle[1] ~= "" then vim.list_extend(bundles, java_debug_bundle) end
        -- return the server config
        return {
          init_options = {
            boundles = bundles,
          },
          settings = {
            java = {
              format = {
                settings = {
                  -- Use Google Java style guidelines for formatting
                  -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
                  -- and place it in the ~/.local/share/eclipse directory
                  -- url = "/.local/share/eclipse/eclipse-java-google-style.xml",
                  -- profile = "GoogleStyle",
                },
              },
              signatureHelp = { enabled = true },
              -- contentProvider = { preferred = "fernflower" }, -- Use fernflower to decompile library code
              -- Specify any completion options
              completion = {
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                  "org.mockito.Mockito.*",
                },
                filteredTypes = {
                  "com.sun.*",
                  "io.micrometer.shaded.*",
                  "java.awt.*",
                  "jdk.*",
                  "sun.*",
                },
              },
              -- Specify any options for organizing imports
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              maven = {
                downloadSources = true,
              },
              -- How code generation should act
              codeGeneration = {
                toString = {
                  template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                -- hashCodeEquals = {
                --   useJava7Objects = true,
                -- },
                useBlocks = true,
              },
              -- If you are developing in projects with different Java versions, you need
              -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
              -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
              -- And search for `interface RuntimeOption`
              -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-1.8",
                    path = home .. "/.sdkman/candidates/java/8.0.362-zulu",
                  },
                },
              },
            },
          },
          cmd = {
            home .. "/.sdkman/candidates/java/21-open/bin/java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-javaagent:" .. install_path .. "/lombok.jar",
            "-Xms1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
            "-configuration",
            install_path .. "/config_" .. os,
            "-data",
            workspace_dir,
          },
          root_dir = root_dir,
        }
      end,
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    git = {
      url_format = "git@github.com:%s.git",
    },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
  -- modify variables used by heirline but not defined in the setup call directly
  heirline = {
    -- define the separators between each section
    separators = {
      left = { "", " " }, -- separator for the left side of the statusline
      -- right = { " ", "" }, -- separator for the right side of the statusline
      right = { " █", "" },
      tab = { "", "" },
    },
    -- add new colors that can be used by heirline
    colors = function(hl)
      local get_hlgroup = require("astronvim.utils").get_hlgroup
      -- use helper function to get highlight group properties
      local comment_fg = get_hlgroup("Comment").fg
      hl.git_branch_fg = comment_fg
      hl.git_added = comment_fg
      hl.git_changed = comment_fg
      hl.git_removed = comment_fg
      hl.blank_bg = get_hlgroup("Folded").fg
      hl.file_info_bg = get_hlgroup("Visual").bg
      hl.nav_icon_bg = get_hlgroup("String").fg
      hl.nav_fg = hl.nav_icon_bg
      hl.folder_icon_bg = get_hlgroup("Error").fg
      return hl
    end,
    attributes = {
      mode = { bold = true },
    },
    icon_highlights = {
      file_icon = {
        statusline = true,
      },
    },
  },
}
