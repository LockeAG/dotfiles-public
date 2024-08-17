--[[
 ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
 ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
 ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
 ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
 ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
  GPU-accelerated cross-platform terminal emulator and multiplexer
  https://github.com/wez/wezterm
]]
--

local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Appearance
config.color_scheme = "Tokyo Night Storm"
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font", weight = "Regular" },
	{ family = "Monaspace Nerd Font", weight = "Regular" },
	{ family = "Noto Sans Symbols 2" },
	{ family = "FiraCode Nerd Font Mono", weight = "Regular" },
	{ family = "Symbols Nerd Font Mono", scale = 0.75 },
	{ family = "Noto Color Emoji" },
	{ family = "JetBrainsMono Nerd Font", weight = "Regular" },
	{ family = "Hack Nerd Font", weight = "Regular" },
	{ family = "DejaVu Sans Mono" },
})
config.font_size = 22.0
config.window_background_opacity = 0.95
config.text_background_opacity = 1.0
config.window_decorations = "RESIZE" -- Similar to Kitty's "Buttonless"
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"

-- Window
config.initial_cols = 121
config.initial_rows = 30
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 750
config.force_reverse_video_cursor = true
config.cursor_thickness = 1.15

-- Scrollback
config.scrollback_lines = 10000

-- Shell
config.default_prog = { "/bin/zsh", "-l" }

-- Font rendering (may help with appearance on macOS)
config.front_end = "WebGpu" -- or "OpenGL" if WebGpu doesn't work well
config.webgpu_power_preference = "HighPerformance"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

-- Allow slightly wider glyphs
config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

-- Key bindings (preserving your tmux bindings)
local act = wezterm.action
local function tmux_cmd(keys)
	return act.SendString("\x01" .. keys)
end

-- WezTerm-specific bindings-- Disable default key bindings to start fresh
config.disable_default_key_bindings = true

config.keys = {
	-- tmux bindings
	{ key = "d", mods = "CMD", action = tmux_cmd("|") },
	{ key = "d", mods = "CMD|SHIFT", action = tmux_cmd("_") },
	{ key = "w", mods = "CMD", action = tmux_cmd("x") },
	{ key = "t", mods = "CMD", action = tmux_cmd("c") },
	{ key = "s", mods = "CMD", action = tmux_cmd("s") },
	{ key = "LeftArrow", mods = "CMD", action = tmux_cmd("\x1b[D") },
	{ key = "RightArrow", mods = "CMD", action = tmux_cmd("\x1b[C") },
	{ key = "UpArrow", mods = "CMD", action = tmux_cmd("\x1b[A") },
	{ key = "DownArrow", mods = "CMD", action = tmux_cmd("\x1b[B") },
	{ key = "z", mods = "CMD", action = tmux_cmd("z") },

	-- Custom bindings
	{ key = "/", mods = "CTRL", action = act.SendKey({ key = "/", mods = "CTRL" }) },
	{ key = "_", mods = "CTRL", action = act.SendKey({ key = "_", mods = "CTRL" }) },

	-- System-level key bindings
	{ key = "r", mods = "CMD", action = act.ReloadConfiguration },
	{ key = "q", mods = "CMD", action = act.QuitApplication },
	{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "n", mods = "CMD", action = act.SpawnWindow },

	-- Essential copy/paste bindings
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
}

-- MacOS specific settings
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- Additional settings to align with Kitty/Alacritty
config.adjust_window_size_when_changing_font_size = false
config.selection_word_boundary = " \t\n{}[]()\"'`,;:"
config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 14.0,
}
config.use_fancy_tab_bar = false
config.native_macos_fullscreen_mode = true
config.hide_mouse_cursor_when_typing = true

-- Enable OSC 52 for clipboard integration
config.enable_kitty_keyboard = true

-- Rounded corners (if supported by your OS/WezTerm version)
-- config.window_corner_radius = 10

return config
