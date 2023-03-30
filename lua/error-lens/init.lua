local config = require("error-lens.config")
local highlight = require("error-lens.highlight")


local function setup(options)
    config.setup(options)
    local default_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]

    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
        default_handler(...)
        highlight.update_highlights()
    end

end



return {
    setup = setup
}
