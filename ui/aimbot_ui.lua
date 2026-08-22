--==================================================

local AimbotPage = Instance.new("ScrollingFrame")
AimbotPage.Size = UDim2.new(1, -20, 1, -20)
AimbotPage.Position = UDim2.new(0, 10, 0, 10)
AimbotPage.BackgroundTransparency = 1
AimbotPage.BorderSizePixel = 0
AimbotPage.ScrollBarThickness = 6
AimbotPage.ScrollBarImageTransparency = 0.15
AimbotPage.ScrollingDirection = Enum.ScrollingDirection.Y
AimbotPage.CanvasSize = UDim2.new(0, 0, 0, 500)
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

--==================================================
-- AIMBOT RADIUS
--==================================================

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

--==================================================
-- AIMBOT TARGET MODE
--==================================================

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

--==================================================
-- AIMBOT FOV TOGGLE
--==================================================

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

--==================================================
-- AIMBOT AIM KEY INFO
--==================================================

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

--==================================================
-- AIMBOT VISIBILITY TOGGLE
--==================================================

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

--==================================================
-- AIMBOT FOV OPACITY
--==================================================

local FOVOpacityLabel = Instance.new("TextLabel")
FOVOpacityLabel.Size = UDim2.new(1, -10, 0, 20)
FOVOpacityLabel.Position = UDim2.new(0, 0, 0, 345)
FOVOpacityLabel.BackgroundTransparency = 1
FOVOpacityLabel.Text = "FOV OPACITY"
FOVOpacityLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
FOVOpacityLabel.TextSize = 11
FOVOpacityLabel.Font = Enum.Font.GothamBold
FOVOpacityLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVOpacityLabel.Parent = AimbotPage

local FOVOpacityValue = Instance.new("TextBox")
FOVOpacityValue.Size = UDim2.new(0, 110, 0, 38)
FOVOpacityValue.Position = UDim2.new(0, 0, 0, 370)
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
FOVOpacityMinus.Position = UDim2.new(0, 118, 0, 370)
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
FOVOpacityPlus.Position = UDim2.new(0, 162, 0, 370)
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

--==================================================
-- AIMBOT FOV COLOR
--==================================================

local FOVColorLabel = Instance.new("TextLabel")
FOVColorLabel.Size = UDim2.new(1, -10, 0, 20)
FOVColorLabel.Position = UDim2.new(0, 0, 0, 420)
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
FOVColorContainer.Position = UDim2.new(0, 0, 0, 440)
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

