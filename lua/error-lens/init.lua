local config = require("error-lens.config")
local utils = require("error-lens.utils")
local highlight = require("error-lens.highlight")

local function setup(options)
	vim.cmd('command! ErrorLensToggle lua require("error-lens").toggle()')
	vim.cmd("command! ErrorLensTelescope lua require('error-lens.telescope').show_diagnostics()")

	config.setup(options)

	vim.diagnostic.handlers.error_lens = {
		---@param bufnr number
		---@param diagnostics table
		show = function(_, bufnr, diagnostics, _)
			highlight.update_highlights(bufnr, diagnostics)
		end,
		---@param bufnr number
		hide = function(_, bufnr)
			highlight.clear_highlights(bufnr)
		end,
	}
end

local function toggle()
	local value = not vim.diagnostic.config().error_lens
	config.options.enabled = value

	if value then
		-- enable error lens -> disable default virtual_text
		utils.set_virtual_text(false)
	else
		-- disable_error_lens -> restore user setting virtual_text
		utils.set_virtual_text(config.user_virtual_text)
	end

	vim.diagnostic.config({ error_lens = value })

	print("ErrorLens is now", config.options.enabled and "enabled" or "disabled")
end

return {
	setup = setup,
	toggle = toggle,
}
