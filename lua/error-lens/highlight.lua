
local api = vim.api

local config = require("error-lens.config")

local function set_highlight(line_nr, message, fg, bg)
    local buf = api.nvim_get_current_buf()
    api.nvim_buf_add_highlight(buf, config.namespace, fg, line_nr, 0, -1)

    -- Calculate the remaining length of the line after the message
    local remaining_length = api.nvim_win_get_width(0) - message:len() - 1 -- Subtract 1 for the space before the message

    -- Call api.nvim_buf_set_extmark to display the message parameter and fill the rest of the line with spaces
    api.nvim_buf_set_extmark(buf, config.namespace, line_nr, 0, {
        hl_mode = 'combine',
        virt_text = {
            { string.rep(' ', config.options.prefix) .. message, bg },
            { string.rep(' ', remaining_length),  bg }
        },
    })
end


local function clear_red_highlights()
    local buf = api.nvim_get_current_buf()
    api.nvim_buf_clear_namespace(buf, config.namespace, 0, -1)
end


local function update_highlights()
    print("update_highlights")
    clear_red_highlights()

    local buf = api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(buf)

    for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
            set_highlight(diagnostic.lnum, diagnostic.message, "ErrorLensErrorText", "ErrorLensErrorBg")
        elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Warn then
            set_highlight(diagnostic.lnum, diagnostic.message, "ErrorLensWarnText", "ErrorLensWarnBg")
        elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Info then
            set_highlight(diagnostic.lnum, diagnostic.message, "ErrorLensInfoText", "ErrorLensInfoBg")
        elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Hint then
            set_highlight(diagnostic.lnum, diagnostic.message, "ErrorLensHintText", "ErrorLensHintBg")
        end
    end
end


return {
    update_highlights = update_highlights
}
