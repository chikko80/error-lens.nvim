local config = require("error-lens.config")
local highlight = require("error-lens.highlight")


local function setup(client, options)
    config.setup(options)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
    client.handlers = client.handlers or {}
    local default_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
    client.handlers["textDocument/publishDiagnostics"] = function(...)
        default_handler(...)
        highlight.update_highlights()
    end
end



return {
    setup = setup
}
