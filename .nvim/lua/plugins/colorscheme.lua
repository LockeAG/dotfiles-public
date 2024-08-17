-- Helper functions
local function is_weekend()
  local day = tonumber(os.date("%w"))
  return day == 0 or day == 6
end

local function is_day_time()
  local hour = tonumber(os.date("%H"))
  return hour >= 9 and hour < 19
end

local function is_warp_terminal()
  return os.getenv("TERM_PROGRAM") == "WarpTerminal"
end

local function is_tmux()
  return os.getenv("TMUX") ~= nil
end

-- Determine if background should be transparent
local is_transparent = is_day_time() and not is_weekend()

-- Default color scheme
local default_color_scheme = "tokyonight-storm"

-- Select color scheme based on conditions
local function select_color_scheme()
  if vim.g.vscode or is_warp_terminal() or is_tmux() or vim.g.neovide or is_transparent then
    return default_color_scheme
  end
  return default_color_scheme -- Always return Tokyo Night for simplicity
end

-- Function to toggle transparency
local function toggle_transparency()
  is_transparent = not is_transparent
  vim.notify("Transparency " .. (is_transparent and "enabled" or "disabled"))
  vim.cmd.colorscheme(select_color_scheme())
end

-- Define a keymap to toggle transparency
vim.keymap.set("n", "<leader>ut", toggle_transparency, { desc = "Update transparency" })

return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = function()
      return {
        style = "storm",
        transparent = is_transparent,
        styles = {
          sidebars = is_transparent and "transparent" or "dark",
          floats = is_transparent and "transparent" or "dark",
        },
      }
    end,
  },
  -- Set LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = select_color_scheme(),
    },
  },
}
