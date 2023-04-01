local config = require("error-lens.config")

local function set_highlight(buf, diagnostic, fg, bg)
	vim.api.nvim_buf_add_highlight(buf, config.namespace, fg, diagnostic.lnum, 0, -1)
	vim.api.nvim_buf_set_extmark(buf, config.namespace, diagnostic.lnum, 0, {
		hl_mode = "combine",
		hl_eol = true,
		hl_group = bg,
		virt_text = {
			{ string.rep(" ", 5) .. diagnostic.message, fg },
		},
		priority = 4 - diagnostic.severity,
	})
end

local function clear_highlights(buf)
	vim.api.nvim_buf_clear_namespace(buf, config.namespace, 0, -1)
end

local function update_highlights(buf, diagnostics)
	clear_highlights(buf)

	for _, diagnostic in ipairs(diagnostics) do
		if diagnostic.severity == vim.diagnostic.severity.ERROR then
			set_highlight(buf, diagnostic, "ErrorLensErrorText", "ErrorLensErrorBg")
		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
			set_highlight(buf, diagnostic, "ErrorLensWarnText", "ErrorLensWarnBg")
		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
			set_highlight(buf, diagnostic, "ErrorLensInfoText", "ErrorLensInfoBg")
		elseif diagnostic.severity == vim.diagnostic.severity.HINT then
			set_highlight(buf, diagnostic, "ErrorLensHintText", "ErrorLensHintBg")
		end
	end
end

return {
	update_highlights = update_highlights,
	clear_highlights = clear_highlights,
}
