-- Markdown linting + auto-formatting on save.
--
-- LazyVim already loads conform.nvim (format-on-save, enabled by default) and
-- nvim-lint. Here we just point them at markdown tooling and make sure the CLI
-- tools are installed via mason.
--
--   * markdownlint-cli2 -> lints on save (diagnostics) AND auto-fixes many
--     violations as a conform formatter (runs with --fix).
--   * prettier          -> final formatting pass; --prose-wrap always reflows
--     paragraphs to the print width (hard-wrapping prose on save).
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "prettier", "markdownlint-cli2" })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- markdownlint-cli2 fixes lint issues first, prettier formats/wraps last.
      opts.formatters_by_ft.markdown = { "markdownlint-cli2", "prettier" }

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        prepend_args = { "--prose-wrap", "always", "--print-width", "80" },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = { "markdownlint-cli2" }
    end,
  },
}
