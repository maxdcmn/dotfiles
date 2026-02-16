return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
        auto_install = true,
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      local node = nil
      local function select_node()
        if not node then return end
        local sr, sc, er, ec = node:range()
        vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
        vim.fn.setpos("'>", { 0, er + 1, ec, 0 })
        vim.cmd("normal! gv")
      end

      vim.keymap.set("n", ",i", function()
        node = vim.treesitter.get_node()
        select_node()
      end, { desc = "Init treesitter selection" })

      vim.keymap.set("v", "+", function()
        node = node and node:parent() or vim.treesitter.get_node()
        select_node()
      end, { desc = "Expand treesitter selection" })

      vim.keymap.set("v", "_", function()
        if node and node:child(0) then node = node:child(0) end
        select_node()
      end, { desc = "Shrink treesitter selection" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").init()

      local sel = require("nvim-treesitter.textobjects.select")
      local mov = require("nvim-treesitter.textobjects.move")
      local swp = require("nvim-treesitter.textobjects.swap")

      local objects = { f = "function", c = "class", i = "conditional", l = "loop", p = "parameter" }
      for key, obj in pairs(objects) do
        local q = "@" .. obj
        local mq = key == "p" and q .. ".inner" or q .. ".outer"
        vim.keymap.set({ "x", "o" }, "a" .. key, function() sel.select_textobject(q .. ".outer", "textobjects") end)
        vim.keymap.set({ "x", "o" }, "i" .. key, function() sel.select_textobject(q .. ".inner", "textobjects") end)
        vim.keymap.set({ "n", "x", "o" }, "gn" .. key, function() mov.goto_next_start(mq, "textobjects") end)
        vim.keymap.set({ "n", "x", "o" }, "gp" .. key, function() mov.goto_previous_start(mq, "textobjects") end)
      end

      vim.keymap.set("n", "<leader>u", function() swp.swap_next("@parameter.inner") end)
      vim.keymap.set("n", "<leader>U", function() swp.swap_previous("@parameter.inner") end)
    end,
  },
}
