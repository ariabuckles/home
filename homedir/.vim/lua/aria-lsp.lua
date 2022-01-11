if vim.lsp then
  -- Include lspconfig plugin:
  vim.api.nvim_command('packadd nvim-lspconfig')

  -- General LSP Config:
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = false,
      virtual_text = {
        prefix = '❭'
      }
    }
  )

  -- Enabled language servers:
  require('lspconfig').tsserver.setup({})
end
