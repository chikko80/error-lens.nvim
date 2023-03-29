local utils = require("error-lens.utils")


local M = {}

M.namespace = vim.api.nvim_create_namespace("error_lens_highlights")

local vim_error = "DiagnosticError"
local vim_warn = "DiagnosticWarn"
local vim_info = "DiagnosticInfo"
local vim_hint = "DiagnosticHint"


local default_options = {
    auto_adjust = {
        enable = false,
        theme_bg = nil,
        step = 5,
        total = 30
    },
    disable_vt = true,
    prefix = 5,
    colors = {
        error_fg = "#FF6363",
        error_bg = "#4B252C",
        warn_fg = "#FA973A",
        warn_bg = "#403733",
        info_fg = "#387EFF",
        info_bg = "#20355A",
        hint_fg = "#16C53B",
        hint_bg = "#254435",
    }
}

function M.setup(options)
    -- Merge user options with default options
    M.options = vim.tbl_deep_extend("force", {}, default_options, options or {})

    -- If auto_adjust is enabled
    if M.options.auto_adjust.enable then
        if M.options.auto_adjust.theme_bg == nil then
            error("Error: 'theme_bg' is mandatory when 'auto_adjust' is enabled.")
        else
            local step = M.options.auto_adjust.step
            local total = M.options.auto_adjust.total

            -- Get adjusted colors based on the theme_bg color
            M.options.colors.error_fg, M.options.colors.error_bg = utils.get_default_diagnostic_colors(
                M.options.auto_adjust.theme_bg, vim_error, step, total)
            M.options.colors.warn_fg, M.options.colors.warn_bg = utils.get_default_diagnostic_colors(
                M.options.auto_adjust.theme_bg, vim_warn, step, total)
            M.options.colors.info_fg, M.options.colors.info_bg = utils.get_default_diagnostic_colors(
                M.options.auto_adjust.theme_bg, vim_info, step, total)
            M.options.colors.hint_fg, M.options.colors.hint_bg = utils.get_default_diagnostic_colors(
                M.options.auto_adjust.theme_bg, vim_hint, step, total)
        end
    end

    -- Set highlights using the M.options.colors values
    vim.api.nvim_set_hl(M.namespace, 'ErrorLensErrorText', { fg = nil, bg = M.options.colors.error_bg })
    vim.api.nvim_set_hl(M.namespace, 'ErrorLensErrorBg', { fg = M.options.colors.error_fg, bg = M.options.colors.error_bg })

    vim.api.nvim_set_hl(M.namespace, 'ErrorLensWarnText', { fg = nil, bg = M.options.colors.warn_bg })
    vim.api.nvim_set_hl(M.namespace, 'ErrorLensWarnBg', { fg = M.options.colors.warn_fg, bg = M.options.colors.warn_bg })

    vim.api.nvim_set_hl(M.namespace, 'ErrorLensInfoText', { fg = nil, bg = M.options.colors.info_bg })
    vim.api.nvim_set_hl(M.namespace, 'ErrorLensInfoBg', { fg = M.options.colors.info_fg, bg = M.options.colors.info_bg })

    vim.api.nvim_set_hl(M.namespace, 'ErrorLensHintText', { fg = nil, bg = M.options.colors.hint_bg })
    vim.api.nvim_set_hl(M.namespace, 'ErrorLensHintBg', { fg = M.options.colors.hint_fg, bg = M.options.colors.hint_bg })

    vim.api.nvim_set_hl_ns(M.namespace)

    vim.diagnostic.config({
        virtual_text = not M.options.disable_vt
    })
end

return M
