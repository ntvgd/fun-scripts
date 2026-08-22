local Base="https://raw.githubusercontent.com/ntvgd/fun-scripts/main/"
local Files={"my_fun_scripts_v2_gui_1.lua","my_fun_scripts_v2_gui_2.lua"}
local Source={}
for _,File in ipairs(Files) do Source[#Source+1]=game:HttpGet(Base..File) end
loadstring(table.concat(Source,"\n"))()
