local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local web_devicons = require("nvim-web-devicons")

local severity = {
  [0] = "Other",
  [1] = "Error",
  [2] = "Warning",
  [3] = "Information",
  [4] = "Hint",
}


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


local function get_signs()
	local signs = {}
	for _, v in pairs(severity) do
		if v ~= "Other" then
			local status, sign = pcall(function()
				return vim.trim(vim.fn.sign_getdefined(get_severity_label(v, "Sign"))[1].text)
			end)
			if not status then
				sign = v:sub(1, 1)
			end
			signs[string.lower(v)] = sign
		end
	end
	return signs
end


local function diagnostics_to_items(diagnostics)
	local items = {}
	for _, diagnostic in ipairs(diagnostics) do
		local bufnr = diagnostic.bufnr
		local filepath = vim.api.nvim_buf_get_name(bufnr)
		local display_filename = filepath:gsub(vim.loop.cwd() .. "/", "")
		local row, col = diagnostic.lnum, diagnostic.col

		local icon, _ = web_devicons.get_icon(filepath, vim.fn.fnamemodify(filepath, ":e"), { default = true })

		local text = string.format(
			"%s %d:%d | %s [%s] | %s",
			icon,
			row + 1,
			col + 1,
			diagnostic.message,
			diagnostic.severity_label,
			display_filename
		)

		table.insert(items, {
			display = text,
			value = diagnostic,
			ordinal = text,
		})
	end
	return items
end



local function entry_maker(entry)
	local value = entry.value
	local bufnr = value.bufnr
	local row, col = value.lnum, value.col

	return {
		display = entry.display,
		ordinal = entry.ordinal,
		bufnr = bufnr,
		lnum = row + 1,
		col = col + 1,
		start = col,
		finish = col + #value.source,
	}
end


local function show_diagnostics(opts)
	opts = opts or {}

    local diagnostics = vim.diagnostic.get(nil)

	local items = diagnostics_to_items(diagnostics)

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
			previewer = false,
		})
		:find()
end

return {
	show_diagnostics = show_diagnostics,
}
