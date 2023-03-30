## [1.0.1]

### Added
- Added a new setup function without parameters to hook into LSP clients' diagnostics.
- Implemented a custom diagnostics handler in the setup function to update highlights.
- The custom diagnostics handler is now attached to Neovim's built-in LSP framework by modifying `vim.lsp.handlers["textDocument/publishDiagnostics"]`.

### Changed
- Simplified the plugin setup process by removing the need for specifying LSP clients as parameters.
- The custom diagnostics handler now works with all active LSP clients automatically.

### Removed
- Removed the old setup function that required specifying LSP clients as parameters.
