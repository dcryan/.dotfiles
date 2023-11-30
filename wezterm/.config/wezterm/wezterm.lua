local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "GJM (terminal.sexy)"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.font = wezterm.font_with_fallback({
	"Monaspace Neon",
	"JetBrains Mono",
	"Symbols Nerd Font",
})
config.font_size = 19.0
config.window_decorations = "RESIZE"

return config
