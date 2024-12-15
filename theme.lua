local M = {}

-- Toggle for transparency.
local transparent = false

-- Helper to determine background color.
local function get_bg(color)
    return transparent and "NONE" or color
end

-- Color palette.
M.palette = {
    red = "#f08080",
    green = "#b3f6c0",
    yellow = "#fce094",
    magenta = "#ffcaff",
    orange = "#ffa07a",
    blue = "#87cefa",
    cyan = "#8cf8f7",
    black = "#07080d",
    gray0 = "#14161b",
    gray1 = "#2c2e33",
    gray2 = "#4f5258",
    white0 = "#eef1f8",
    white1 = "#e0e2ea",
    white2 = "#c4c6cd",
    white3 = "#9b9ea4",
    fg = "#eef1f8",
    bg = "#14161b",
    bg_dark = "#07080d",
}

-- Set a highlight group.
local function set_highlight(group, config)
    vim.api.nvim_set_hl(0, group, config)
end

-- Set multiple highlights from a table.
local function set_highlights_table(highlights)
    for group, config in pairs(highlights) do
        set_highlight(group, config)
    end
end

-- Initialization function for setting highlights.
function M.init()
    set_highlights_table({
        -- General UI Highlights.
        Normal = { bg = get_bg(M.palette.bg) },
        Visual = { bg = M.palette.gray1 },
        WinBar = { fg = M.palette.white2, bg = get_bg(M.palette.bg) },
        LineNR = { fg = M.palette.gray2, bg = get_bg(M.palette.bg) },
        CursorLineNR = { fg = M.palette.white0, bg = get_bg(M.palette.bg), bold = true },

        -- Git Signs.
        Added = { fg = M.palette.green },
        Removed = { fg = M.palette.red },
        Changed = { fg = M.palette.blue },

        -- Syntax.
        Comment = { fg = M.palette.gray2, bold = false },
        Title = { fg = M.palette.yellow, bold = true },
        Statement = { fg = M.palette.orange },
        Number = { fg = M.palette.magenta },
        Boolean = { fg = M.palette.magenta },

        -- Diagnostics.
        DiagnosticError = { fg = M.palette.red },
        DiagnosticWarn = { fg = M.palette.yellow },
        DiagnosticHint = { fg = M.palette.green },
        DiagnosticInfo = { fg = M.palette.blue },

        -- Plugin Highlights.
        IndentBlanklineChar = { fg = M.palette.gray1 },
        WhichKeyNormal = { bg = M.palette.bg_dark },
        DashboardHeader = { fg = M.palette.yellow },
        TelescopePromptPrefix = { fg = M.palette.yellow, bg = get_bg(M.palette.bg) },
        NotifyINFOBorder = { fg = M.palette.green },

        -- Link examples to avoid redundancy.
        DiagnosticUnderlineError = { sp = M.palette.red, underline = true },
        DiagnosticUnderlineWarn = { sp = M.palette.yellow, underline = true },
        DiagnosticUnderlineHint = { sp = M.palette.green, underline = true },
    })
end

-- Function to configure lualine with the custom theme.
function M.setup_lualine()
    local default_section = { fg = M.palette.gray2, bg = M.palette.bg_dark }
    local theme = {
        normal = {
            a = { fg = M.palette.bg_dark, bg = M.palette.blue, gui = "bold" },
            b = default_section,
            c = default_section,
        },
        visual = {
            a = { fg = M.palette.bg_dark, bg = M.palette.red, gui = "bold" },
            b = default_section,
            c = default_section,
        },
        replace = {
            a = { fg = M.palette.bg_dark, bg = M.palette.red, gui = "bold" },
            b = default_section,
            c = default_section,
        },
        command = {
            a = { fg = M.palette.bg_dark, bg = M.palette.orange, gui = "bold" },
            b = default_section,
            c = default_section,
        },
        insert = {
            a = { fg = M.palette.bg_dark, bg = M.palette.green, gui = "bold" },
            b = default_section,
            c = default_section,
        },
        inactive = {
            a = { fg = M.palette.bg_dark, bg = M.palette.gray0, gui = "bold" },
            b = default_section,
            c = default_section,
        },
    }
    require("lualine").setup({ options = { theme = theme } })
end

-- Initialize highlights on load.
M.init()

return M
