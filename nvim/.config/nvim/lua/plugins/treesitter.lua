return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  
        sync_install = false,
  
        auto_install = true,
  
        indent = { enable = true },
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = ",i",
            node_incremental = "+",
            scope_incremental = "grc",
            node_decremental = "_",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = { query = "@function.outer", desc = "Around a function" },
              ["if"] = { query = "@function.inner", desc = "Inner part of a function" },
              ["ac"] = { query = "@class.outer", desc = "Around a class" },
              ["ic"] = { query = "@class.inner", desc = "Inner part of a class" },
              ["ai"] = { query = "@conditional.outer", desc = "Around an if statement" },
              ["ii"] = { query = "@conditional.inner", desc = "Inner part of an if statement" },
              ["al"] = { query = "@loop.outer", desc = "Around a loop" },
              ["il"] = { query = "@loop.inner", desc = "Inner part of a loop" },
              ["ap"] = { query = "@parameter.outer", desc = "Around parameter" },
              ["ip"] = { query = "@parameter.inner", desc = "Inside a parameter" },
            },
            selection_modes = {
              ['@parameter.outer'] = 'v',
              ['@parameter.inner'] = 'v',
              ["@function.outer"] = "V",
              ["@conditional.outer"] = "V",
              ["@loop.outer"] = "V",
              ['@class.outer'] = '<c-v>',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_previous_start = {
              ["gpf"] = { query = "@function.outer", desc = "Previous function" },
              ["gpl"] = { query = "@loop.outer", desc = "Previous loop" },
              ["gpi"] = { query = "@conditional.outer", desc = "Previous if statement" },
              ["gpc"] = { query = "@class.outer", desc = "Previous class" },
              ["gpp"] = { query = "@parameter.inner", desc = "Previous parameter" },
            },
            goto_next_start = {
              ["gnf"] = { query = "@function.outer", desc = "Next function" },
              ["gnl"] = { query = "@loop.outer", desc = "Next loop" },
              ["gni"] = { query = "@conditional.outer", desc = "Next if statement" },
              ["gnc"] = { query = "@class.outer", desc = "Next class" },
              ["gnp"] = { query = "@parameter.inner", desc = "Next parameter" },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>u"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>U"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
}