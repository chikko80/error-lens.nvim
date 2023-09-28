local config = require("error-lens.config")

local function set_highlight(buf, diagnostic, fg, bg, first)
    vim.api.nvim_buf_add_highlight(buf, config.namespace, fg, diagnostic.lnum, 0, -1)
    vim.api.nvim_buf_set_extmark(buf, config.namespace, diagnostic.lnum, 0, {
        hl_mode = "combine",
        hl_eol = true,
        hl_group = bg,
        virt_text = {
            { (first and string.rep(" ", 3) or "") }, -- more spacing first time
            { string.rep(" ", 2) .. diagnostic.message .. string.rep(" ", 2), bg },
        },
        priority = 4 - diagnostic.severity,
    })
end

local function clear_highlights(buf)
    vim.api.nvim_buf_clear_namespace(buf, config.namespace, 0, -1)
end

local function update_highlights(buf, diagnostics)
    clear_highlights(buf)
    local first = true
    local old_lnum=-1
    for _, diagnostic in ipairs(diagnostics) do
        if old_lnum ~= diagnostic.lnum then
            first = true
            old_lnum = diagnostic.lnum
        end
        if diagnostic.severity == vim.diagnostic.severity.ERROR then
            set_highlight(buf, diagnostic, "ErrorLensErrorText", "ErrorLensErrorBg", first)
        elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            set_highlight(buf, diagnostic, "ErrorLensWarnText", "ErrorLensWarnBg", first)
        elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            set_highlight(buf, diagnostic, "ErrorLensInfoText", "ErrorLensInfoBg", first)
        elseif diagnostic.severity == vim.diagnostic.severity.HINT then
            set_highlight(buf, diagnostic, "ErrorLensHintText", "ErrorLensHintBg", first)
        end
        first = false
    end
end

return {
    update_highlights = update_highlights,
    clear_highlights = clear_highlights,
}
