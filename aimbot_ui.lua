local AimbotPage = Instance.new("ScrollingFrame")
AimbotPage.Size = UDim2.new(1, -20, 1, -20)
AimbotPage.Position = UDim2.new(0, 10, 0, 10)
AimbotPage.BackgroundTransparency = 1
AimbotPage.BorderSizePixel = 0
AimbotPage.ScrollBarThickness = 6
AimbotPage.ScrollBarImageTransparency = 0.15
AimbotPage.ScrollingDirection = Enum.ScrollingDirection.Y
AimbotPage.CanvasSize = UDim2.new(0, 0, 0, 760)
AimbotPage.ClipsDescendants = true
AimbotPage.Visible = true
AimbotPage.Parent = ContentArea
local AimbotHeader = Instance.new("TextLabel")
AimbotHeader.Size = UDim2.new(1, -10, 0, 30)
AimbotHeader.BackgroundTransparency = 1
AimbotHeader.Text = "AIMBOT"
AimbotHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotHeader.TextSize = 18
AimbotHeader.Font = Enum.Font.GothamBold
AimbotHeader.TextXAlignment = Enum.TextXAlignment.Left
AimbotHeader.Parent = AimbotPage
local AimbotSubheader = Instance.new("TextLabel")
AimbotSubheader.Size = UDim2.new(1, -10, 0, 20)
AimbotSubheader.Position = UDim2.new(0, 0, 0, 28)
AimbotSubheader.BackgroundTransparency = 1
AimbotSubheader.Text = "Configure camera targeting behavior"
AimbotSubheader.TextColor3 = Color3.fromRGB(130, 130, 130)
AimbotSubheader.TextSize = 11
AimbotSubheader.Font = Enum.Font.Gotham
AimbotSubheader.TextXAlignment = Enum.TextXAlignment.Left
AimbotSubheader.Parent = AimbotPage
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(1, -10, 0, 20)
RadiusLabel.Position = UDim2.new(0, 0, 0, 65)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "FOV / RADIUS"
RadiusLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
RadiusLabel.TextSize = 11
RadiusLabel.Font = Enum.Font.GothamBold
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.Parent = AimbotPage
local RadiusValue = Instance.new("TextBox")
RadiusValue.Size = UDim2.new(0, 110, 0, 38)
RadiusValue.Position = UDim2.new(0, 0, 0, 90)
RadiusValue.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
RadiusValue.BorderSizePixel = 0
RadiusValue.Text = tostring(AimbotSettings.Radius)
RadiusValue.TextColor3 = Color3.fromRGB(100, 255, 100)
RadiusValue.TextSize = 13
RadiusValue.Font = Enum.Font.Gotham
RadiusValue.ClearTextOnFocus = false
RadiusValue.Parent = AimbotPage
local RadiusCorner = Instance.new("UICorner")
RadiusCorner.CornerRadius = UDim.new(0, 6)
RadiusCorner.Parent = RadiusValue
local RadiusMinus = Instance.new("TextButton")
RadiusMinus.Size = UDim2.new(0, 38, 0, 38)
RadiusMinus.Position = UDim2.new(0, 118, 0, 90)
RadiusMinus.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RadiusMinus.BorderSizePixel = 0
RadiusMinus.Text = "-"
RadiusMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusMinus.TextSize = 18
RadiusMinus.Font = Enum.Font.GothamBold
RadiusMinus.Parent = AimbotPage
local RadiusMinusCorner = Instance.new("UICorner")
RadiusMinusCorner.CornerRadius = UDim.new(0, 6)
RadiusMinusCorner.Parent = RadiusMinus
local RadiusPlus = Instance.new("TextButton")
RadiusPlus.Size = UDim2.new(0, 38, 0, 38)
RadiusPlus.Position = UDim2.new(0, 162, 0, 90)
RadiusPlus.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RadiusPlus.BorderSizePixel = 0
RadiusPlus.Text = "+"
RadiusPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusPlus.TextSize = 18
RadiusPlus.Font = Enum.Font.GothamBold
RadiusPlus.Parent = AimbotPage
local RadiusPlusCorner = Instance.new("UICorner")
RadiusPlusCorner.CornerRadius = UDim.new(0, 6)
RadiusPlusCorner.Parent = RadiusPlus
local function SetAimbotRadius(Value)
	Value = tonumber(Value)
	if not Value then
		Value = AimbotSettings.Radius
	end
	Value = math.clamp(
		math.floor(Value),
		25,
		1000
	)
	AimbotSettings.Radius = Value
	RadiusValue.Text = tostring(Value)
end
RadiusValue.FocusLost:Connect(
	function()
		SetAimbotRadius(
			RadiusValue.Text
		)
	end
)
RadiusMinus.MouseButton1Click:Connect(
	function()
		SetAimbotRadius(
			AimbotSettings.Radius - 25
		)
	end
)
RadiusPlus.MouseButton1Click:Connect(
	function()
		SetAimbotRadius(
			AimbotSettings.Radius + 25
		)
	end
)
local TargetModeButton = Instance.new("TextButton")
TargetModeButton.Size = UDim2.new(1, -10, 0, 42)
TargetModeButton.Position = UDim2.new(0, 0, 0, 145)
TargetModeButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
TargetModeButton.BorderSizePixel = 0
TargetModeButton.Text = "   Target: HEAD"
TargetModeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
TargetModeButton.TextSize = 13
TargetModeButton.Font = Enum.Font.Gotham
TargetModeButton.TextXAlignment = Enum.TextXAlignment.Left
TargetModeButton.Parent = AimbotPage
local TargetModeCorner = Instance.new("UICorner")
TargetModeCorner.CornerRadius = UDim.new(0, 6)
TargetModeCorner.Parent = TargetModeButton
local TargetModes = {
	"Head",
	"Torso",
	"Alternate"
}
local TargetModeIndex = 1
local function UpdateTargetModeButton()
	TargetModeButton.Text =
		"   Target: "
		.. string.upper(
			AimbotSettings.TargetMode
		)
end
TargetModeButton.MouseButton1Click:Connect(
	function()
		TargetModeIndex =
			TargetModeIndex + 1
		if TargetModeIndex >
			#TargetModes then
			TargetModeIndex = 1
		end
		AimbotSettings.TargetMode =
			TargetModes[TargetModeIndex]
		UpdateTargetModeButton()
	end
)
UpdateTargetModeButton()
local FOVButton = Instance.new("TextButton")
FOVButton.Size = UDim2.new(1, -10, 0, 42)
FOVButton.Position = UDim2.new(0, 0, 0, 195)
FOVButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
FOVButton.BorderSizePixel = 0
FOVButton.TextColor3 = Color3.fromRGB(220, 220, 220)
FOVButton.TextSize = 13
FOVButton.Font = Enum.Font.Gotham
FOVButton.TextXAlignment = Enum.TextXAlignment.Left
FOVButton.Parent = AimbotPage
local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(0, 6)
FOVCorner.Parent = FOVButton
local function UpdateFOVButton()
	FOVButton.Text =
		"   FOV Circle: "
		.. (
			AimbotSettings.ShowFOV
			and "ON"
			or "OFF"
		)
	FOVButton.TextColor3 =
		AimbotSettings.ShowFOV
		and Color3.fromRGB(
			100,
			255,
			100
		)
		or Color3.fromRGB(
			255,
			100,
			100
		)
end
FOVButton.MouseButton1Click:Connect(
	function()
		AimbotSettings.ShowFOV =
			not AimbotSettings.ShowFOV
		UpdateFOVButton()
	end
)
UpdateFOVButton()
local AimKeyButton = Instance.new("TextButton")
AimKeyButton.Size = UDim2.new(1, -10, 0, 42)
AimKeyButton.Position = UDim2.new(0, 0, 0, 245)
AimKeyButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
AimKeyButton.BorderSizePixel = 0
AimKeyButton.Text = "   Aim Key: RIGHT MOUSE"
AimKeyButton.TextColor3 = Color3.fromRGB(220, 220, 220)
AimKeyButton.TextSize = 13
AimKeyButton.Font = Enum.Font.Gotham
AimKeyButton.TextXAlignment = Enum.TextXAlignment.Left
AimKeyButton.AutoButtonColor = false
AimKeyButton.Parent = AimbotPage
local AimKeyCorner = Instance.new("UICorner")
AimKeyCorner.CornerRadius = UDim.new(0, 6)
AimKeyCorner.Parent = AimKeyButton
local VisibilityButton = Instance.new("TextButton")
VisibilityButton.Size = UDim2.new(1, -10, 0, 42)
VisibilityButton.Position = UDim2.new(0, 0, 0, 295)
VisibilityButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
VisibilityButton.BorderSizePixel = 0
VisibilityButton.TextColor3 = Color3.fromRGB(100, 255, 100)
VisibilityButton.TextSize = 13
VisibilityButton.Font = Enum.Font.Gotham
VisibilityButton.TextXAlignment = Enum.TextXAlignment.Left
VisibilityButton.AutoButtonColor = false
VisibilityButton.Parent = AimbotPage
local VisibilityCorner = Instance.new("UICorner")
VisibilityCorner.CornerRadius = UDim.new(0, 6)
VisibilityCorner.Parent = VisibilityButton
local function UpdateVisibilityButton()
	VisibilityButton.Text =
		"   Line of Sight: "
		.. (
			AimbotSettings.LineOfSight
			and "ON"
			or "OFF"
		)
	VisibilityButton.TextColor3 =
		AimbotSettings.LineOfSight
		and Color3.fromRGB(
			100,
			255,
			100
		)
		or Color3.fromRGB(
			255,
			100,
			100
		)
end
VisibilityButton.MouseButton1Click:Connect(
	function()
		AimbotSettings.LineOfSight =
			not AimbotSettings.LineOfSight
		AimbotTarget = nil
		UpdateVisibilityButton()
	end
)
UpdateVisibilityButton()
local AimbotTeamHeader = Instance.new("TextLabel")
AimbotTeamHeader.Size = UDim2.new(1, -10, 0, 20)
AimbotTeamHeader.Position = UDim2.new(0, 0, 0, 575)
AimbotTeamHeader.BackgroundTransparency = 1
AimbotTeamHeader.Text = "LOCK-ON TEAMS"
AimbotTeamHeader.TextColor3 = Color3.fromRGB(210, 210, 210)
AimbotTeamHeader.TextSize = 11
AimbotTeamHeader.Font = Enum.Font.GothamBold
AimbotTeamHeader.TextXAlignment = Enum.TextXAlignment.Left
AimbotTeamHeader.Parent = AimbotPage
local AimbotTeamDropdown = Instance.new("TextButton")
AimbotTeamDropdown.Size = UDim2.new(1, -10, 0, 38)
AimbotTeamDropdown.Position = UDim2.new(0, 0, 0, 600)
AimbotTeamDropdown.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
AimbotTeamDropdown.BorderSizePixel = 0
AimbotTeamDropdown.Text = "   SELECT TEAMS ▼"
AimbotTeamDropdown.TextColor3 = Color3.fromRGB(220, 220, 220)
AimbotTeamDropdown.TextSize = 12
AimbotTeamDropdown.Font = Enum.Font.Gotham
AimbotTeamDropdown.TextXAlignment = Enum.TextXAlignment.Left
AimbotTeamDropdown.Parent = AimbotPage
local AimbotTeamDropdownCorner = Instance.new("UICorner")
AimbotTeamDropdownCorner.CornerRadius = UDim.new(0, 6)
AimbotTeamDropdownCorner.Parent = AimbotTeamDropdown
local AimbotTeamList = Instance.new("ScrollingFrame")
AimbotTeamList.Size = UDim2.new(1, -10, 0, 150)
AimbotTeamList.Position = UDim2.new(0, 0, 0, 414)
AimbotTeamList.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
AimbotTeamList.BorderSizePixel = 0
AimbotTeamList.ScrollBarThickness = 5
AimbotTeamList.Visible = false
AimbotTeamList.AutomaticCanvasSize = Enum.AutomaticSize.Y
AimbotTeamList.CanvasSize = UDim2.new(0, 0, 0, 0)
AimbotTeamList.Parent = AimbotPage
local AimbotTeamListCorner = Instance.new("UICorner")
AimbotTeamListCorner.CornerRadius = UDim.new(0, 6)
AimbotTeamListCorner.Parent = AimbotTeamList
local AimbotTeamLayout = Instance.new("UIListLayout")
AimbotTeamLayout.Padding = UDim.new(0, 4)
AimbotTeamLayout.SortOrder = Enum.SortOrder.LayoutOrder
AimbotTeamLayout.Parent = AimbotTeamList
local AimbotTeamPadding = Instance.new("UIPadding")
AimbotTeamPadding.PaddingTop = UDim.new(0, 5)
AimbotTeamPadding.PaddingBottom = UDim.new(0, 5)
AimbotTeamPadding.PaddingLeft = UDim.new(0, 5)
AimbotTeamPadding.PaddingRight = UDim.new(0, 5)
AimbotTeamPadding.Parent = AimbotTeamList
local AimbotTeamButtons = {}
local function UpdateAimbotTeamButton(TeamKey)
	local Data = AimbotTeamButtons[TeamKey]
	if not Data then
		return
	end
	local Selected = AimbotTeamSettings[TeamKey] ~= false
	if Selected then
		Data.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Data.Label.TextColor3 = Color3.fromRGB(20, 20, 20)
	else
		Data.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		Data.Label.TextColor3 = Color3.fromRGB(120, 120, 120)
	end
end
local function CreateAimbotTeamButton(TeamKey, TeamName, TeamColor, Order)
	if AimbotTeamButtons[TeamKey] then
		AimbotTeamButtons[TeamKey].Button.LayoutOrder = Order
		UpdateAimbotTeamButton(TeamKey)
		return
	end
	if AimbotTeamSettings[TeamKey] == nil then
		AimbotTeamSettings[TeamKey] = TeamKey ~= LocalPlayer.Team
	end
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -10, 0, 32)
	Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.LayoutOrder = Order
	Button.Parent = AimbotTeamList
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 5)
	Corner.Parent = Button
	local Indicator = Instance.new("Frame")
	Indicator.Size = UDim2.fromOffset(12, 12)
	Indicator.Position = UDim2.new(0, 10, 0.5, -6)
	Indicator.BackgroundColor3 = TeamColor
	Indicator.BorderSizePixel = 0
	Indicator.Parent = Button
	local IndicatorCorner = Instance.new("UICorner")
	IndicatorCorner.CornerRadius = UDim.new(1, 0)
	IndicatorCorner.Parent = Indicator
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -35, 1, 0)
	Label.Position = UDim2.fromOffset(30, 0)
	Label.BackgroundTransparency = 1
	Label.Text = TeamName
	Label.TextSize = 12
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Button
	Button.MouseButton1Click:Connect(function()
		AimbotTeamSettings[TeamKey] = not (AimbotTeamSettings[TeamKey] ~= false)
		AimbotTarget = nil
		UpdateAimbotTeamButton(TeamKey)
	end)
	AimbotTeamButtons[TeamKey] = {
		Button = Button,
		Label = Label
	}
	UpdateAimbotTeamButton(TeamKey)
end
local function RebuildAimbotTeamList()
	local Existing = {}
	Existing["NO_TEAM"] = true
	CreateAimbotTeamButton(
		"NO_TEAM",
		"No Team",
		Color3.fromRGB(180, 180, 180),
		1
	)
	local TeamList = Teams:GetTeams()
	table.sort(TeamList, function(A, B)
		return A.Name:lower() < B.Name:lower()
	end)
	for Index, Team in ipairs(TeamList) do
		Existing[Team] = true
		CreateAimbotTeamButton(
			Team,
			Team.Name,
			Team.TeamColor.Color,
			Index + 1
		)
	end
	for TeamKey, Data in pairs(AimbotTeamButtons) do
		if not Existing[TeamKey] then
			if Data.Button then
				Data.Button:Destroy()
			end
			AimbotTeamButtons[TeamKey] = nil
			AimbotTeamSettings[TeamKey] = nil
		end
	end
end
RebuildAimbotTeamList()
AimbotTeamDropdown.MouseButton1Click:Connect(function()
	AimbotTeamList.Visible = not AimbotTeamList.Visible
	AimbotTeamDropdown.Text = AimbotTeamList.Visible
		and "   SELECT TEAMS ▲"
		or "   SELECT TEAMS ▼"
end)
Teams.ChildAdded:Connect(function(Child)
	if Child:IsA("Team") then
		RebuildAimbotTeamList()
	end
end)
Teams.ChildRemoved:Connect(function(Child)
	if Child:IsA("Team") then
		RebuildAimbotTeamList()
	end
end)
local FOVOpacityLabel = Instance.new("TextLabel")
FOVOpacityLabel.Size = UDim2.new(1, -10, 0, 20)
FOVOpacityLabel.Position = UDim2.new(0, 0, 0, 575)
FOVOpacityLabel.BackgroundTransparency = 1
FOVOpacityLabel.Text = "FOV OPACITY"
FOVOpacityLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
FOVOpacityLabel.TextSize = 11
FOVOpacityLabel.Font = Enum.Font.GothamBold
FOVOpacityLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVOpacityLabel.Parent = AimbotPage
local FOVOpacityValue = Instance.new("TextBox")
FOVOpacityValue.Size = UDim2.new(0, 110, 0, 38)
FOVOpacityValue.Position = UDim2.new(0, 0, 0, 600)
FOVOpacityValue.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
FOVOpacityValue.BorderSizePixel = 0
FOVOpacityValue.Text =
	tostring(
		math.floor(
			AimbotSettings.FOVOpacity * 100
		)
	)
FOVOpacityValue.TextColor3 = Color3.fromRGB(100, 255, 100)
FOVOpacityValue.TextSize = 13
FOVOpacityValue.Font = Enum.Font.Gotham
FOVOpacityValue.ClearTextOnFocus = false
FOVOpacityValue.Parent = AimbotPage
local FOVOpacityCorner = Instance.new("UICorner")
FOVOpacityCorner.CornerRadius = UDim.new(0, 6)
FOVOpacityCorner.Parent = FOVOpacityValue
local FOVOpacityMinus = Instance.new("TextButton")
FOVOpacityMinus.Size = UDim2.new(0, 38, 0, 38)
FOVOpacityMinus.Position = UDim2.new(0, 118, 0, 600)
FOVOpacityMinus.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FOVOpacityMinus.BorderSizePixel = 0
FOVOpacityMinus.Text = "-"
FOVOpacityMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVOpacityMinus.TextSize = 18
FOVOpacityMinus.Font = Enum.Font.GothamBold
FOVOpacityMinus.Parent = AimbotPage
local FOVOpacityMinusCorner = Instance.new("UICorner")
FOVOpacityMinusCorner.CornerRadius = UDim.new(0, 6)
FOVOpacityMinusCorner.Parent = FOVOpacityMinus
local FOVOpacityPlus = Instance.new("TextButton")
FOVOpacityPlus.Size = UDim2.new(0, 38, 0, 38)
FOVOpacityPlus.Position = UDim2.new(0, 162, 0, 600)
FOVOpacityPlus.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FOVOpacityPlus.BorderSizePixel = 0
FOVOpacityPlus.Text = "+"
FOVOpacityPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVOpacityPlus.TextSize = 18
FOVOpacityPlus.Font = Enum.Font.GothamBold
FOVOpacityPlus.Parent = AimbotPage
local FOVOpacityPlusCorner = Instance.new("UICorner")
FOVOpacityPlusCorner.CornerRadius = UDim.new(0, 6)
FOVOpacityPlusCorner.Parent = FOVOpacityPlus
local function SetFOVOpacity(Value)
	Value = tonumber(Value)
	if not Value then
		Value =
			AimbotSettings.FOVOpacity * 100
	end
	Value = math.clamp(
		math.floor(Value),
		10,
		100
	)
	AimbotSettings.FOVOpacity =
		Value / 100
	FOVOpacityValue.Text =
		tostring(Value)
	AimbotCircleStroke.Transparency =
		1 - AimbotSettings.FOVOpacity
end
FOVOpacityValue.FocusLost:Connect(
	function()
		SetFOVOpacity(
			FOVOpacityValue.Text
		)
	end
)
FOVOpacityMinus.MouseButton1Click:Connect(
	function()
		SetFOVOpacity(
			AimbotSettings.FOVOpacity * 100 - 10
		)
	end
)
FOVOpacityPlus.MouseButton1Click:Connect(
	function()
		SetFOVOpacity(
			AimbotSettings.FOVOpacity * 100 + 10
		)
	end
)
local FOVColorLabel = Instance.new("TextLabel")
FOVColorLabel.Size = UDim2.new(1, -10, 0, 20)
FOVColorLabel.Position = UDim2.new(0, 0, 0, 650)
FOVColorLabel.BackgroundTransparency = 1
FOVColorLabel.Text = "FOV COLOR"
FOVColorLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
FOVColorLabel.TextSize = 11
FOVColorLabel.Font = Enum.Font.GothamBold
FOVColorLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVColorLabel.Parent = AimbotPage
local FOVColors = {
	{
		Name = "White",
		Color = Color3.fromRGB(
			255,
			255,
			255
		)
	},
	{
		Name = "Red",
		Color = Color3.fromRGB(
			255,
			70,
			70
		)
	},
	{
		Name = "Green",
		Color = Color3.fromRGB(
			70,
			255,
			90
		)
	},
	{
		Name = "Blue",
		Color = Color3.fromRGB(
			70,
			150,
			255
		)
	},
	{
		Name = "Yellow",
		Color = Color3.fromRGB(
			255,
			220,
			60
		)
	},
	{
		Name = "Purple",
		Color = Color3.fromRGB(
			190,
			80,
			255
		)
	},
	{
		Name = "Cyan",
		Color = Color3.fromRGB(
			60,
			240,
			255
		)
	},
	{
		Name = "Orange",
		Color = Color3.fromRGB(
			255,
			140,
			50
		)
	}
}
local FOVColorContainer = Instance.new("Frame")
FOVColorContainer.Size = UDim2.new(1, -10, 0, 35)
FOVColorContainer.Position = UDim2.new(0, 0, 0, 670)
FOVColorContainer.BackgroundTransparency = 1
FOVColorContainer.Parent = AimbotPage
local FOVColorLayout = Instance.new("UIListLayout")
FOVColorLayout.FillDirection = Enum.FillDirection.Horizontal
FOVColorLayout.Padding = UDim.new(0, 6)
FOVColorLayout.Parent = FOVColorContainer
for _, ColorData in ipairs(FOVColors) do
	local Button = Instance.new("TextButton")
	Button.Size =
		UDim2.new(
			0,
			36,
			0,
			28
		)
	Button.BackgroundColor3 =
		ColorData.Color
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.Parent = FOVColorContainer
	local Corner =
		Instance.new("UICorner")
	Corner.CornerRadius =
		UDim.new(
			0,
			6
		)
	Corner.Parent = Button
	Button.MouseButton1Click:Connect(
		function()
			AimbotSettings.FOVColor =
				ColorData.Color
			AimbotCircleStroke.Color =
				ColorData.Color
		end
	)
end
