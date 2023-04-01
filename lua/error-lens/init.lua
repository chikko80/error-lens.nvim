local config = require("error-lens.config")
local utils = require("error-lens.utils")
local highlight = require("error-lens.highlight")

local function setup(options)
	vim.cmd('command! ErrorLensToggle lua require("error-lens").toggle()')
	config.setup(options)

	-- TODO:  changes this handler to diagnostic.handler
	local default_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
	vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
		default_handler(...)

		local buf = vim.api.nvim_get_current_buf()
		local diagnostics = vim.diagnostic.get(buf)
		highlight.update_highlights(buf, diagnostics)
	end
end

local function toggle()
	config.options.enabled = not config.options.enabled
	if config.options.enabled then
		utils.set_virtual_text(false)
		-- TODO:  call handler updat
		local buf = vim.api.nvim_get_current_buf()
		local diagnostics = vim.diagnostic.get(buf)
		highlight.update_highlights(buf, diagnostics)
	else
		-- restore user setting
		utils.set_virtual_text(config.user_virtual_text)
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			highlight.clear_red_highlights(buf)
		end
	end
	print("ErrorLens is now", config.options.enabled and "enabled" or "disabled")
end

return {
	setup = setup,
	toggle = toggle,
}
