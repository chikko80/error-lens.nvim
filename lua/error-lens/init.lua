local config = require("error-lens.config")
local highlight = require("error-lens.highlight")

local function setup(options)
	config.setup(options)

	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		callback = function(args)
			highlight.update_highlights(args.buf, args.data.diagnostics)
		end,
	})
end

return {
	setup = setup,
}
