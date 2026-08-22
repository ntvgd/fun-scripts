local Base = "https://raw.githubusercontent.com/ntvgd/fun-scripts/main/"

local Files = {
	"core.lua",
	"gui_tabs.lua",
	"aimbot_ui.lua",
	"esp_ui.lua",
	"spectate_settings_ui.lua",
	"window_runtime.lua",
	"esp.lua",
	"aimbot_spectate_runtime.lua"
}

local Source = {}

for _, File in ipairs(Files) do
	Source[#Source + 1] = game:HttpGet(Base .. File)
end

loadstring(table.concat(Source, "\n"))()
