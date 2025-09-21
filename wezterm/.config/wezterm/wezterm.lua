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
	{
		family = "Monaspace Neon",
		harfbuzz_features = {
			"calt=1",
			"ss01=1",
			"ss02=1",
			"ss03=1",
			"ss04=1",
			"ss05=1",
			"ss06=1",
			"ss07=1",
			"ss08=1",
			"ss09=1",
			"liga=1",
		},
	},
	-- "JetBrains Mono",
	"Symbols Nerd Font",
})
config.font_size = 19.0
config.window_decorations = "RESIZE"

return config
