local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local previewers = require("telescope.previewers")

local severity_labels = {
	[0] = "Other",
	[1] = "Error",
	[2] = "Warning",
	[3] = "Info",
	[4] = "Hint",
}

-- code from trouble.nvim
-- returns a hl or sign label for the givin severity and type
-- correctly handles new names introduced in vim.diagnostic
local function get_severity_label(severity, type)
	local label = severity
	local prefix = "LspDiagnostics" .. (type or "Default")

	if vim.diagnostic then
		prefix = type and ("Diagnostic" .. type) or "Diagnostic"
		label = ({
			Warning = "Warn",
			Information = "Info",
		})[severity] or severity
	end

	return prefix .. label
end

-- Extract information from diagnostics to display in telescope
local function preprocess_diagnostics(diagnostics)
	local items = {}
	for _, diagnostic in ipairs(diagnostics) do
		local bufnr = diagnostic.bufnr
		local filepath = vim.api.nvim_buf_get_name(bufnr)
		local display_filename = filepath:gsub(vim.loop.cwd() .. "/", "")
		local row, col = diagnostic.lnum, diagnostic.col

		local sign_label = severity_labels[diagnostic.severity]
		local sign_info = vim.fn.sign_getdefined(get_severity_label(sign_label, "Sign"))[1]
		local sign = vim.trim(sign_info.text)
		local hl_group = vim.trim(sign_info.texthl)

		local entry = {
			value = {
				bufnr = bufnr,
				lnum = row,
				col = col,
				message = vim.trim(diagnostic.message:gsub("[\n]", "")),
				path = display_filename,
				sign = sign,
				hl_group = hl_group,
				severity = diagnostic.severity, -- Add this line
			},
			ordinal = string.format("%s %d:%d | %s | %s", sign, row + 1, col + 1, diagnostic.message, display_filename),
		}

		table.insert(items, entry)
	end
	return items
end

-- Copied and modified from telescope.nvim
local function entry_maker(entry)
	local value = entry.value
	local bufnr = value.bufnr
	local row, col = value.lnum, value.col
	local display_line = string.format("%s %4d:%2d", value.sign, row + 1, col + 1)

	local display_items = {
		{ width = 10 },
		{ width = 60 },
		{ remaining = true },
	}
	local displayer = entry_display.create({
		separator = "▏",
		items = display_items,
	})

	return {
		display = function(entry)
			return displayer({
				{ display_line, value.hl_group },
				value.message,
				value.path,
			})
		end,
		ordinal = entry.ordinal,
		bufnr = bufnr,
		lnum = row + 1,
		col = col + 1,
		start = col,
		finish = col + #value.message,
		path = value.path,
	}
end

local function show_diagnostics(opts)
	opts = opts or {}

	local diagnostics = vim.diagnostic.get(nil)

	local items = preprocess_diagnostics(diagnostics)

	-- sort diagnostics by severity > current_buf > buffer > line
	table.sort(items, function(a, b)
		if a.value.severity == b.value.severity then
			local current_bufnr = vim.api.nvim_get_current_buf()
			if a.value.bufnr == current_bufnr and b.value.bufnr ~= current_bufnr then
				return true
			elseif a.value.bufnr ~= current_bufnr and b.value.bufnr == current_bufnr then
				return false
			elseif a.value.bufnr == b.value.bufnr then
				return a.value.lnum < b.value.lnum
			else
				return a.value.bufnr < b.value.bufnr
			end
		else
			return a.value.severity < b.value.severity
		end
	end)

	pickers
		.new(opts, {
			prompt_title = "Error Lens Diagnostics",
			finder = finders.new_table({
				results = items,
				entry_maker = entry_maker,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(_, map)
				map("i", "<CR>", actions.select_default)
				map("n", "<CR>", actions.select_default)
				return true
			end,
			previewer = previewers.vim_buffer_vimgrep.new(opts), -- Add this line
		})
		:find()
end

return {
	show_diagnostics = show_diagnostics,
}
