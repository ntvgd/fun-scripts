local Base="https://raw.githubusercontent.com/ntvgd/fun-scripts/main/"
local Files={
    "my_fun_scripts_v2_gui_1.lua",
    "my_fun_scripts_v2_gui_2.lua",
}
local Source={}
for _,File in ipairs(Files) do
    local Ok,Data=pcall(game.HttpGet,game,Base..File)
    if not Ok then
        error("Failed to download "..File..": "..tostring(Data))
    end
    Source[#Source+1]=Data
end
loadstring(table.concat(Source,"\n"))()
