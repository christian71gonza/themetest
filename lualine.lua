-- lualine.lua

-- Helper function to determine the current working directory (shortened).
local function get_short_cwd()
    local cwd = vim.fn.getcwd()
    return vim.fn.fnamemodify(cwd, ":~")
end

-- Custom mode names.
local function fmt_mode(s)
    local mode_map = {
        ["COMMAND"] = "COMMND",
        ["V-BLOCK"] = "V-BLCK",
        ["TERMINAL"] = "TERMNL",
        ["V-REPLACE"] = "V-RPLC",
        ["O-PENDING"] = "0PNDNG",
    }
    return mode_map[s] or s
end

-- Load theme-dependent colors.
local theme = require("core.theme")

-- Theme dependant custom colors.
local text_hl
local icon_hl
local green
local red
if theme.is_default() then
    local C = theme.palette
    red = C.red
    green = C.green
    icon_hl = { fg = C.gray2 }
    text_hl = { fg = C.gray2 }
end

-- Recording state (stub logic for demonstration).
local function is_recording()
    -- Replace with actual logic to detect recording state.
    return false
end

local function get_recording_color()
    if is_recording() then
        return { fg = red }
    else
        return text_hl
    end
end

-- Git diff source (stub logic).
local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

-- Diagnostic signs (manually defined).
local diagnostic_signs = {
    error = "",
    warn = "",
    info = "",
    hint = "",
    other = "",
}

local default_z = {
    {
        "location",
        icon = { "", align = "left" },
        fmt = function(str)
            local fixed_width = 7
            return string.format("%" .. fixed_width .. "s", str)
        end,
    },
    {
        "progress",
        icon = { "", align = "left" },
        separator = { right = "", left = "" },
    },
}

local tree = {
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = fmt_mode,
                icon = { "" },
                separator = { right = " ", left = "" },
            },
        },
        lualine_c = {
            {
                get_short_cwd,
                padding = 0,
                icon = { "   ", color = icon_hl },
                color = text_hl,
            },
        },
        lualine_z = default_z,
    },
    filetypes = { "NvimTree" },
}

local telescope = {
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = fmt_mode,
                icon = { "" },
                separator = { right = " ", left = "" },
            },
        },
        lualine_c = {
            {
                function() return "Telescope" end,
                color = text_hl,
                icon = { "  ", color = icon_hl },
            },
        },
        lualine_z = default_z,
    },
    filetypes = { "TelescopePrompt" },
}

require("lualine").setup({
    sections = {
        lualine_a = {
            {
                "mode",
                fmt = fmt_mode,
                icon = { "" },
                separator = { right = " ", left = "" },
            },
        },
        lualine_c = {
            {
                function() return is_recording() and "●" or "" end,
                color = get_recording_color,
                padding = 0,
                separator = "",
            },
            {
                "branch",
                color = text_hl,
                icon = { " ", color = icon_hl },
                separator = "",
                padding = 0,
            },
            {
                "diff",
                color = text_hl,
                icon = { "  ", color = text_hl },
                source = diff_source,
                symbols = {
                    added = " ",
                    modified = " ",
                    removed = " ",
                },
                diff_color = {
                    added = icon_hl,
                    modified = icon_hl,
                    removed = icon_hl,
                },
                padding = 0,
            },
        },
        lualine_x = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = diagnostic_signs,
                colored = true,
                padding = 2,
            },
        },
        lualine_z = default_z,
    },
    options = {
        disabled_filetypes = { "dashboard" },
        globalstatus = true,
        section_separators = { left = " ", right = " " },
        component_separators = { left = "", right = "" },
    },
    extensions = {
        telescope,
        ["nvim-tree"] = tree,
    },
})

-- Ensure correct background for lualine.
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    callback = function(_) require("lualine").setup({}) end,
    pattern = { "*.*" },
    once = true,
})
vim.defer_fn(function() require("lualine").setup({}) end, 1)

-- Load default theme configuration if applicable.
if theme.is_default() then theme.setup_lualine() end
