-- Markdown-local editing options.
-- Soft-wrap long lines at word boundaries, and keep wrapped lines aligned
-- under the text of the line they belong to (hanging indent for lists).

vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- break at word boundaries, not mid-word
vim.opt_local.breakindent = true -- wrapped lines keep the line's indent
-- list:-1 aligns a wrapped line to the start of the item's text (after the
-- bullet/number marker matched by 'formatlistpat').
vim.opt_local.breakindentopt = "list:-1"

-- Recognize markdown bullets (-, *, +) and numbered lists so list:-1 can find
-- where the text starts on each item.
vim.opt_local.formatlistpat = [[^\s*\d\+[.)]\s\+\|^\s*[-*+]\s\+]]
