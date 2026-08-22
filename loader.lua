local Base="https://raw.githubusercontent.com/ntvgd/fun-scripts/main/"
local Files={
    "core.lua",
    "ui/gui_tabs.lua",
    "ui/aimbot_ui.lua",
    "features/esp_ui.lua",
    "ui/spectate_settings_ui.lua",
    "core/window_runtime.lua",
    "features/esp.lua",
    "features/aimbot_spectate_runtime.lua",
}
local Source={}
for _,File in ipairs(Files) do
    Source[#Source+1]=game:HttpGet(Base..File)
end
loadstring(table.concat(Source,"\n"))()
