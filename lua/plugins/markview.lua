return {
  "OXY2DEV/markview.nvim",
  -- The author advises against lazy-loading: the plugin is already
  -- internally lazy-loaded, and deferring it slows down preview rendering.
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
}
