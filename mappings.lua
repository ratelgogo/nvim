-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    ["<Esc>"] = { ":noh<cr>", desc = "Clear highlights" },
    ["<C-c>"] = { ":%y+<cr>", desc = "Copy whole file" },

    -- navigate buffer tabs with `H` and `L`
    ["<tab>"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    ["<s-tab>"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    ["<leader>x"] = {
      function() require("astronvim.utils.buffer").close() end,
      desc = "close current buffer",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
    ["gD"] = {
      "<Cmd>Lspsaga goto_definition<CR>",
      desc = "LSP definition",
    },

    ["gd"] = {
      "<Cmd>Lspsaga peek_definition<CR>",
      desc = "LSP definition",
    },

    ["K"] = {
      "<Cmd>Lspsaga hover_doc<CR>",
      desc = "LSP hover",
    },
    ["gi"] = {
      "<cmd>Lspsaga finder imp<CR>",
      desc = "LSP implementation",
    },

    ["ga"] = {
      "<cmd>Lspsaga code_action<CR>",
      desc = "LSP code action",
    },

    ["gr"] = {
      "<cmd>Lspsaga finder ref<CR>",
      desc = "LSP references",
    },

    ["[d"] = {
      "<cmd>Lspsaga diagnostic_jump_prev<CR>",
      desc = "Goto prev",
    },

    ["]d"] = {
      "<cmd>Lspsaga diagnostic_jump_next<CR>",
      desc = "Goto next",
    },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  i = {
    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", desc = "Move left" },
    ["<C-l>"] = { "<Right>", desc = "Move right" },
    ["<C-j>"] = { "<Down>", desc = "Move down" },
    ["<C-k>"] = { "<Up>", desc = "Move up" },
    ["<C-s>"] = { "<esc>:w!<cr>", desc = "Save File" }, -- change description but the same command
  },
}
