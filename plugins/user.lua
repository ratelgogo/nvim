return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    -- Neovim's answer to the mouse
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      local leap = require "leap"
      leap.add_default_mappings()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function() leap.init_highlight(true) end,
      })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        names = false,
        RRGGBBAA = true,
        css = true,
      },
    },
  },
  {
    "karb94/neoscroll.nvim",
    enabled = false,
    lazy = false,
    config = function() require("neoscroll").setup() end,
  },
  {
    "ibhagwan/smartyank.nvim",
    lazy = false,
  },
  {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua,
          },
          javascript = {
            require("formatter.filetypes.javascript").prettier,
          },
          javascriptreact = {
            require("formatter.filetypes.javascript").prettier,
          },
          typescript = {
            require("formatter.filetypes.typescript").prettier,
          },
          typescriptreact = {
            require("formatter.filetypes.typescript").prettier,
          },
          less = {
            require("formatter.filetypes.css").prettier,
          },
          css = {
            require("formatter.filetypes.css").prettier,
          },
          scss = {
            require("formatter.filetypes.css").prettier,
          },
          html = { require("formatter.filetypes.html").prettier },
          vue = {
            require("formatter.filetypes.vue").prettier,
          },
          java = {
            require("formatter.filetypes.java").google_java_format()
          }
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        java = {
          "checkstyle"
        }
      }
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    lazy = false,
    config = function()
      local saga = require "lspsaga"

      local diagnostic_icons = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
      }
      for type, icon in pairs(diagnostic_icons) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      end

      saga.setup {
        preview = { lines_above = 0, lines_below = 10 },
        ui = {
          -- currently only round theme
          theme = "round",
          -- border type can be single,double,rounded,solid,shadow.
          -- border = 'solid',
          border = "rounded",
          winblend = 0,
          expand = "",
          collapse = "",
          preview = " ",
          code_action = "💡",
          diagnostic = "🐞",
          incoming = " ",
          outgoing = " ",
          colors = {
            --float window normal bakcground color
            normal_bg = "#1d1536",
            --title background color
            title_bg = "#afd700",
            red = "#e95678",
            magenta = "#b33076",
            orange = "#FF8700",
            yellow = "#f7bb3b",
            green = "#afd700",
            cyan = "#36d0e0",
            blue = "#61afef",
            purple = "#CBA6F7",
            white = "#d1d4cf",
            black = "#1c1c19",
          },
          kind = {},
        },
        outline = {
          layout = "float",
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-jdtls", -- load jdtls on module
    event = "VeryLazy",
    ft = { "java" },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "jdtls" },
      },
    },
  },
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = false,
          },
          hover = {
            enabled = false,
          },

          signature = {
            enabled = false,
          },
          progress = {
            enabled = false,
          },
        },
        messages = {
          enabled = false,
        },
        popupmenu = {
          --- 'nui'|'cmp'
          backend = "cmp",
          kind_icons = {},
        },
        cmdline = {
          enabled = true, -- enables the Noice cmdline UI
          view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
          opts = {}, -- global options for the cmdline. See section on views
          format = {
            -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            -- view: (default is cmdline view)
            -- opts: any options passed to the view
            -- icon_hl_group: optional hl_group for the icon
            -- title: set to anything or empty string to hide
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = "🔍 ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = "🔍 ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "❓" },
            input = {}, -- Used by input()
            -- lua = false, -- to disable a format, set to `false`
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    ft = { "typescriptreact", "tsx", "html" },
    config = function() require("nvim-ts-autotag").setup() end,
  },
  {
    "kylechui/nvim-surround",
    lazy = false,
    config = function() require("nvim-surround").setup() end,
  },
}
