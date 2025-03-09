local wezterm = require('wezterm')
local ssh_domains = require('extra.ssh') 
local mux = wezterm.mux
local act = wezterm.action

local config = {}
-- TODO: 
-- 1. Add nvim like keybindings for navigating windows and tabs (h,j,k,l)
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

return {
	-- color scheme
	color_scheme = "Banana Blueberry",
	--window opacity reduced
	-- make sure you use a font you have installed
	font = wezterm.font("MesloLGS NF"),
	font_size = 10.5,
	-- scroll bar
	enable_scroll_bar = true,
	-- Custom Key Bindings
	-- disable_default_key_bindings = true,
	ssh_domains = ssh_domains,
}
