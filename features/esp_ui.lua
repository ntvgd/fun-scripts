--==================================================
-- ESP PAGE
--==================================================

local ESPPage = Instance.new("ScrollingFrame")
ESPPage.Size = UDim2.new(1, -20, 1, -20)
ESPPage.Position = UDim2.new(0, 10, 0, 10)
ESPPage.BackgroundTransparency = 1
ESPPage.BorderSizePixel = 0
ESPPage.ScrollBarThickness = 6
ESPPage.ScrollBarImageTransparency = 0.15
ESPPage.ScrollingDirection = Enum.ScrollingDirection.Y
ESPPage.CanvasSize = UDim2.new(0, 0, 0, 490)
ESPPage.ClipsDescendants = true
ESPPage.Parent = ContentArea

local ESPHeader = Instance.new("TextLabel")
ESPHeader.Size = UDim2.new(1, -10, 0, 30)
ESPHeader.BackgroundTransparency = 1
ESPHeader.Text = "PLAYER ESP"
ESPHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPHeader.TextSize = 18
ESPHeader.Font = Enum.Font.GothamBold
ESPHeader.TextXAlignment = Enum.TextXAlignment.Left
ESPHeader.Parent = ESPPage

local ESPSubheader = Instance.new("TextLabel")
ESPSubheader.Size = UDim2.new(1, -10, 0, 20)
ESPSubheader.Position = UDim2.new(0, 0, 0, 28)
ESPSubheader.BackgroundTransparency = 1
ESPSubheader.Text = "Customize what is shown above players"
ESPSubheader.TextColor3 = Color3.fromRGB(130, 130, 130)
ESPSubheader.TextSize = 11
ESPSubheader.Font = Enum.Font.Gotham
ESPSubheader.TextXAlignment = Enum.TextXAlignment.Left
ESPSubheader.Parent = ESPPage

--==================================================
-- ESP TOGGLES
--==================================================

local function CreateESPToggle(
	Name,
	SettingName,
	Y
)

	local Button = Instance.new("TextButton")

	Button.Size =
		UDim2.new(
			1,
			-10,
			0,
			40
		)

	Button.Position =
		UDim2.new(
			0,
			0,
			0,
			Y
		)

	Button.BackgroundColor3 =
		Color3.fromRGB(
			32,
			32,
			32
		)

	Button.BorderSizePixel = 0
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 14
	Button.TextXAlignment =
		Enum.TextXAlignment.Left

	Button.Parent =
		ESPPage

	local Corner =
		Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(
			0,
			6
		)

	Corner.Parent =
		Button

	local function Update()

		local Enabled =
			ESPSettings[SettingName]

		Button.Text =
			"   "
			.. Name
			.. ": "
			.. (
				Enabled
				and "ON"
				or "OFF"
			)

		Button.TextColor3 =
			Enabled
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

	Button.MouseButton1Click:Connect(
		function()

			ESPSettings[SettingName] =
				not ESPSettings[SettingName]

			Update()

			if SettingName ==
				"Enabled" then

				UpdateESPTabToggle()
			end
		end
	)

	Update()
end

CreateESPToggle("ESP", "Enabled", 60)
CreateESPToggle("Names", "Names", 108)
CreateESPToggle("Distance", "Distance", 156)
CreateESPToggle("Health", "Health", 204)
CreateESPToggle("Lines", "Lines", 252)

ESPToggle.MouseButton1Click:Connect(
	function()

		ESPSettings.Enabled =
			not ESPSettings.Enabled

		UpdateESPTabToggle()
	end
)

UpdateESPTabToggle()

--==================================================
-- HEALTH STYLE
--==================================================

local HealthStyleButton =
	Instance.new("TextButton")

HealthStyleButton.Size =
	UDim2.new(
		1,
		-10,
		0,
		36
	)

HealthStyleButton.Position =
	UDim2.new(
		0,
		0,
		0,
		300
	)

HealthStyleButton.BackgroundColor3 =
	Color3.fromRGB(
		32,
		32,
		32
	)

HealthStyleButton.BorderSizePixel = 0

HealthStyleButton.Text =
	"   Health Style: BAR"

HealthStyleButton.TextColor3 =
	Color3.fromRGB(
		220,
		220,
		220
	)

HealthStyleButton.TextSize = 12
HealthStyleButton.Font = Enum.Font.Gotham
HealthStyleButton.TextXAlignment =
	Enum.TextXAlignment.Left

HealthStyleButton.Parent =
	ESPPage

local HealthStyleCorner =
	Instance.new("UICorner")

HealthStyleCorner.CornerRadius =
	UDim.new(
		0,
		6
	)

HealthStyleCorner.Parent =
	HealthStyleButton

--==================================================
-- HEALTH DISPLAY REFRESH
--==================================================

local function RefreshHealthDisplay()

	for Player, Data in pairs(
		ESPObjects
	) do

		local Character =
			Data.Character

		if not Character
			or not Character.Parent then

			if Data.HealthText then
				Data.HealthText.Visible = false
			end

			if Data.HealthBarBackground then
				Data.HealthBarBackground.Visible = false
			end

			continue
		end

		local Humanoid =
			Character:FindFirstChildOfClass(
				"Humanoid"
			)

		if not Humanoid then

			Data.HealthText.Visible = false
			Data.HealthBarBackground.Visible = false

			continue
		end

		if not ESPSettings.Enabled
			or not ESPSettings.Health then

			Data.HealthText.Visible = false
			Data.HealthBarBackground.Visible = false

			continue
		end

		if HealthStyle == "Text" then

			local Health =
				math.max(
					0,
					math.floor(
						Humanoid.Health
					)
				)

			local MaxHealth =
				math.max(
					1,
					math.floor(
						Humanoid.MaxHealth
					)
				)

			Data.HealthText.Text =
				string.format(
					"HP: %d / %d",
					Health,
					MaxHealth
				)

			Data.HealthText.TextColor3 =
				ESPSettings.TextColor

			Data.HealthText.Visible = true
			Data.HealthBarBackground.Visible = false

		else

			local HealthRatio =
				math.clamp(
					Humanoid.Health /
						math.max(
							1,
							Humanoid.MaxHealth
						),
					0,
					1
				)

			Data.HealthBarFill.Size =
				UDim2.new(
					HealthRatio,
					0,
					1,
					0
				)

			Data.HealthText.Visible = false
			Data.HealthBarBackground.Visible = true
		end
	end
end

HealthStyleButton.MouseButton1Click:Connect(
	function()

		if HealthStyle == "Text" then

			HealthStyle =
				"Bar"

			HealthStyleButton.Text =
				"   Health Style: BAR"

		else

			HealthStyle =
				"Text"

			HealthStyleButton.Text =
				"   Health Style: TEXT"
		end

		RefreshHealthDisplay()
	end
)

--==================================================
-- HIGHLIGHT COLORS
--==================================================

local ColorLabel =
	Instance.new("TextLabel")

ColorLabel.Size =
	UDim2.new(
		1,
		-10,
		0,
		20
	)

ColorLabel.Position =
	UDim2.new(
		0,
		0,
		0,
		345
	)

ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "Highlight Color"

ColorLabel.TextColor3 =
	Color3.fromRGB(
		210,
		210,
		210
	)

ColorLabel.TextSize = 11
ColorLabel.Font = Enum.Font.GothamBold
ColorLabel.TextXAlignment =
	Enum.TextXAlignment.Left

ColorLabel.Parent =
	ESPPage

local Colors = {

	{
		Name = "Red",
		Color = Color3.fromRGB(
			255,
			48,
			51
		)
	},

	{
		Name = "Green",
		Color = Color3.fromRGB(
			50,
			255,
			80
		)
	},

	{
		Name = "Blue",
		Color = Color3.fromRGB(
			50,
			150,
			255
		)
	},

	{
		Name = "Yellow",
		Color = Color3.fromRGB(
			255,
			220,
			50
		)
	},

	{
		Name = "Purple",
		Color = Color3.fromRGB(
			180,
			70,
			255
		)
	},

	{
		Name = "White",
		Color = Color3.fromRGB(
			255,
			255,
			255
		)
	}
}

local ColorContainer =
	Instance.new("Frame")

ColorContainer.Size =
	UDim2.new(
		1,
		-10,
		0,
		35
	)

ColorContainer.Position =
	UDim2.new(
		0,
		0,
		0,
		365
	)

ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent =
	ESPPage

local ColorLayout =
	Instance.new("UIListLayout")

ColorLayout.FillDirection =
	Enum.FillDirection.Horizontal

ColorLayout.Padding =
	UDim.new(
		0,
		6
	)

ColorLayout.Parent =
	ColorContainer

for _, ColorData in ipairs(
	Colors
) do

	local Button =
		Instance.new("TextButton")

	Button.Size =
		UDim2.new(
			0,
			42,
			0,
			30
		)

	Button.BackgroundColor3 =
		ColorData.Color

	Button.BorderSizePixel = 0
	Button.Text = ""

	Button.Parent =
		ColorContainer

	local Corner =
		Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(
			0,
			6
		)

	Corner.Parent =
		Button

	Button.MouseButton1Click:Connect(
		function()

			ESPSettings.Color =
				ColorData.Color
		end
	)
end

--==================================================
-- TEXT COLORS
--==================================================

local TextColorLabel =
	Instance.new("TextLabel")

TextColorLabel.Size =
	UDim2.new(
		1,
		-10,
		0,
		20
	)

TextColorLabel.Position =
	UDim2.new(
		0,
		0,
		0,
		405
	)

TextColorLabel.BackgroundTransparency = 1
TextColorLabel.Text = "Text Color"

TextColorLabel.TextColor3 =
	Color3.fromRGB(
		210,
		210,
		210
	)

TextColorLabel.TextSize = 11
TextColorLabel.Font = Enum.Font.GothamBold
TextColorLabel.TextXAlignment =
	Enum.TextXAlignment.Left

TextColorLabel.Parent =
	ESPPage

local TextColors = {

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
			80,
			80
		)
	},

	{
		Name = "Green",
		Color = Color3.fromRGB(
			80,
			255,
			100
		)
	},

	{
		Name = "Blue",
		Color = Color3.fromRGB(
			90,
			170,
			255
		)
	},

	{
		Name = "Yellow",
		Color = Color3.fromRGB(
			255,
			230,
			80
		)
	},

	{
		Name = "Purple",
		Color = Color3.fromRGB(
			200,
			100,
			255
		)
	},

	{
		Name = "Orange",
		Color = Color3.fromRGB(
			255,
			150,
			70
		)
	}
}

local TextColorContainer =
	Instance.new("Frame")

TextColorContainer.Size =
	UDim2.new(
		1,
		-10,
		0,
		35
	)

TextColorContainer.Position =
	UDim2.new(
		0,
		0,
		0,
		425
	)

TextColorContainer.BackgroundTransparency = 1
TextColorContainer.Parent =
	ESPPage

local TextColorLayout =
	Instance.new("UIListLayout")

TextColorLayout.FillDirection =
	Enum.FillDirection.Horizontal

TextColorLayout.Padding =
	UDim.new(
		0,
		6
	)

TextColorLayout.Parent =
	TextColorContainer

for _, ColorData in ipairs(
	TextColors
) do

	local Button =
		Instance.new("TextButton")

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

	Button.Parent =
		TextColorContainer

	local Corner =
		Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(
			0,
			6
		)

	Corner.Parent =
		Button

	Button.MouseButton1Click:Connect(
		function()

			ESPSettings.TextColor =
				ColorData.Color
		end
	)
end

--==================================================
