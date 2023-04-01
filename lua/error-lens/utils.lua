local function hexToRGB(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

function RGBToHex(r, g, b)
	return string.format("#%02X%02X%02X", r, g, b)
end

local function color_bend(hex1, hex2, step, total)
	local r1, g1, b1 = hexToRGB(hex1)
	local r2, g2, b2 = hexToRGB(hex2)
	local t = step / total

	local r = r1 + (r2 - r1) * t
	local g = g1 + (g2 - g1) * t
	local b = b1 + (b2 - b1) * t

	return RGBToHex(math.floor(r), math.floor(g), math.floor(b))
end

local function get_default_diagnostic_colors(theme_bg, hi_group, step, total)
	local color = vim.api.nvim_get_hl_by_name(hi_group, true)
	local fg = string.format("#%06x", color.foreground)
	local bg

	if color.background ~= nil then
		bg = string.format("#%06x", color.background)
	else
		bg = color_bend(theme_bg, fg, step, total)
	end

	return fg, bg
end

local function set_virtual_text(value)
	vim.diagnostic.config({
		virtual_text = value,
	})
end

return {
	get_default_diagnostic_colors = get_default_diagnostic_colors,
	set_virtual_text = set_virtual_text,
}
