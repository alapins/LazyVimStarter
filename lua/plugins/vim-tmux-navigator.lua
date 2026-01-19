return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { mode = "n", "<M-h>", "<cmd>TmuxNavigateLeft<cr>" },
    { mode = "n", "<M-j>", "<cmd>TmuxNavigateDown<cr>" },
    { mode = "n", "<M-k>", "<cmd>TmuxNavigateUp<cr>" },
    { mode = "n", "<M-l>", "<cmd>TmuxNavigateRight<cr>" },
    { mode = "n", "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    { mode = "t", "<M-h>", "<C-w><cmd>TmuxNavigateLeft<cr>" },
    { mode = "t", "<M-j>", "<C-w><cmd>TmuxNavigateDown<cr>" },
    { mode = "t", "<M-k>", "<C-w><cmd>TmuxNavigateUp<cr>" },
    { mode = "t", "<M-l>", "<C-w><cmd>TmuxNavigateRight<cr>" },
    { mode = "t", "<M-\\>", "<C-w><cmd>TmuxNavigatePrevious<cr>" },
  },
  init = function()
    -- Disable default mappings to make it work in terminal mode
    vim.g.tmux_navigator_no_mappings = 1
  end,
}
