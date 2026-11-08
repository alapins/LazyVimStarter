-- Same keys as tmux (see ~/.config/tmux/tmux.conf): tmux passes them through when a
-- pane runs nvim, so the same chord acts on nvim windows/tabs there.
local function ss(fn)
  return function() require("smart-splits")[fn]() end
end

-- Move the current window one step in a direction. Like focus, it carries on into
-- tmux when nvim has no window that way: the whole nvim pane swaps with its neighbour.
local function move_window(dir)
  local win = require("smart-splits.win")
  local at_edge = ({
    left = win.at_left_edge, right = win.at_right_edge,
    up = win.at_top_edge, down = win.at_bottom_edge,
  })[dir]()
  if not at_edge then
    return require("smart-splits")["swap_buf_" .. dir]()
  end
  if vim.env.TMUX then
    vim.system({ "tmux", "swap-pane", "-t", vim.env.TMUX_PANE, "-s", "{" .. dir .. "-of}" })
  end
end

-- Move the current window into the previous/next tab (wraps, like tmux next-window)
local function move_to_tab(delta)
  local tabs = vim.api.nvim_list_tabpages()
  local cur = vim.api.nvim_get_current_tabpage()
  local idx
  for i, t in ipairs(tabs) do
    if t == cur then idx = i end
  end
  local target = tabs[(idx - 1 + delta) % #tabs + 1]
  if target == cur then return end
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  vim.api.nvim_set_current_tabpage(target)
  vim.cmd("belowright vsplit") -- beside the target, like tmux join-pane -h
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_close(win, false)
end

local maps = {
  -- focus
  { "<M-h>", ss("move_cursor_left") },
  { "<M-j>", ss("move_cursor_down") },
  { "<M-k>", ss("move_cursor_up") },
  { "<M-l>", ss("move_cursor_right") },
  -- resize
  { "<M-C-h>", ss("resize_left") },
  { "<M-C-j>", ss("resize_down") },
  { "<M-C-k>", ss("resize_up") },
  { "<M-C-l>", ss("resize_right") },
  -- move window
  { "<M-H>", function() move_window("left") end },
  { "<M-J>", function() move_window("down") end },
  { "<M-K>", function() move_window("up") end },
  { "<M-L>", function() move_window("right") end },
  -- tabs
  { "<M-s>", "<cmd>tabprevious<cr>" },
  { "<M-g>", "<cmd>tabnext<cr>" },
  { "<M-b>", "<cmd>tabnew<cr>" }, -- opens after the current tab, like tmux new-window -a
  { "<M-S>", function() move_to_tab(-1) end },
  { "<M-G>", function() move_to_tab(1) end },
}

local keys = {}
for _, m in ipairs(maps) do
  keys[#keys + 1] = { m[1], m[2], mode = "n" }
  -- terminal mode: leave to the window-command prefix first (as the old navigator maps did)
  keys[#keys + 1] = { m[1], type(m[2]) == "string" and ("<C-w>" .. m[2]) or function()
    vim.cmd("stopinsert")
    m[2]()
  end, mode = "t" }
end

return {
  "smart-splits-nvim/smart-splits.nvim",
  version = "^3.0.0",
  -- tmux only learns a pane runs nvim once this loads, so it must not lazy-load
  lazy = false,
  dependencies = {
    { "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux" },
  },
  opts = {
    mux = { backend = "smart-splits-backend-tmux" },
    -- keep in step with the tmux side (@smart-splits_* in tmux.conf)
    move = { at_edge = "wrap" },
    resize = { amount = 3 },
    swap = { move_cursor = true }, -- focus follows the moved window, as tmux swap-pane does
  },
  keys = keys,
  init = function()
    -- tmux's Alt+Escape hands the tab keys to tmux via a pane flag; start and end nvim without it
    if not vim.env.TMUX then return end
    local function clear_flag()
      vim.system({ "tmux", "set", "-p", "-u", "-t", vim.env.TMUX_PANE, "@tmux-owns-tabs" }):wait()
    end
    vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, { callback = clear_flag })
  end,
}
