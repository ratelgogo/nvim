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
}
