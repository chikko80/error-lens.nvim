## [1.0.2]

### Added
- Telescope Extension - Sort diagnostics by severity

## [1.0.1]

### Added
- Toggle with :ErrorLensToggle

### Changed
- Highlighting function to highlight the full line (Simplified version)

### Removed
- disable_vt - we disable virtual_text by default an restore the old setting on toggle


## [1.0.0]

### Added
- Added a new setup function without parameters to hook into LSP clients' diagnostics.
- Implemented a custom diagnostics handler in the setup function to update highlights.
- The custom diagnostics handler is now attached to Neovim's built-in LSP framework by modifying `vim.lsp.handlers["textDocument/publishDiagnostics"]`.

### Changed
- Simplified the plugin setup process by removing the need for specifying LSP clients as parameters.
- The custom diagnostics handler now works with all active LSP clients automatically.

### Removed
- Removed the old setup function that required specifying LSP clients as parameters.
