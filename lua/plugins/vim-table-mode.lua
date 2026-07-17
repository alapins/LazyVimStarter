return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown" },
  cmd = { "TableModeToggle", "TableModeEnable", "Tableize" },
  init = function()
    -- Use GitHub-flavored markdown table syntax (| corners, |---| separators)
    vim.g.table_mode_corner = "|"
  end,
}
