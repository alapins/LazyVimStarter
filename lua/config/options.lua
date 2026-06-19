-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20"

local augroup = vim.api.nvim_create_augroup("CursorColor", { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  pattern = "*:i",
  callback = function() io.write("\27]12;#88aaff\7") end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  pattern = "i:*",
  callback = function() io.write("\27]12;#e4e4e4\7") end,
})
