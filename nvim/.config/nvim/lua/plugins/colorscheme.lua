return {
  "folke/tokyonight.nvim",
  priority = 100,
  config = function()
    require("tokyonight").setup({
      style = "night",
      transparent = true,
    })
    vim.cmd("colorscheme tokyonight")
  end,
}
