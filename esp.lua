--==================================================
-- ESP HELPERS
--==================================================

local function CreateESPLabel(
	Name,
	Size,
	TextSize
)

	local Label =
		Instance.new("TextLabel")

	Label.Name =
		Name

	Label.Size =
		UDim2.fromOffset(
			Size.X,
			Size.Y
		)

	Label.BackgroundTransparency = 1
	Label.Text = ""

	Label.TextSize =
		TextSize

	Label.Font =
		Enum.Font.Gotham

	Label.TextColor3 =
		ESPSettings.TextColor

	Label.TextStrokeTransparency =
		0.3

	Label.TextXAlignment =
		Enum.TextXAlignment.Center

	Label.TextYAlignment =
		Enum.TextYAlignment.Center

	Label.ZIndex = 10

	return Label
end

local function CreateHealthBar()

	local Background =
		Instance.new("Frame")

	Background.Name =
		"HealthBarBackground"

	Background.Size =
		UDim2.fromOffset(
			120,
			7
		)

	Background.BackgroundColor3 =
		Color3.fromRGB(
			45,
			45,
			45
		)

	Background.BorderSizePixel = 0
	Background.ZIndex = 10

	local Corner =
		Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(
			1,
			0
		)

	Corner.Parent =
		Background

	local Fill =
		Instance.new("Frame")

	Fill.Name =
		"HealthBarFill"

	Fill.Size =
		UDim2.fromScale(
			1,
			1
		)

	Fill.BackgroundColor3 =
		Color3.fromRGB(
			70,
			220,
			90
		)

	Fill.BorderSizePixel = 0
	Fill.ZIndex = 11
	Fill.Parent =
		Background

	local FillCorner =
		Instance.new("UICorner")

	FillCorner.CornerRadius =
		UDim.new(
			1,
			0
		)

	FillCorner.Parent =
		Fill

	return Background, Fill
end

local function RemovePlayerESP(Player)

	local Data =
		ESPObjects[Player]

	if not Data then
		return
	end

	if Data.Highlight then
		Data.Highlight:Destroy()
	end

	if Data.NameLabel then
		Data.NameLabel:Destroy()
	end

	if Data.DistanceLabel then
		Data.DistanceLabel:Destroy()
	end

	if Data.HealthText then
		Data.HealthText:Destroy()
	end

	if Data.HealthBarBackground then
		Data.HealthBarBackground:Destroy()
	end

	if Data.Line then
		Data.Line:Destroy()
	end

	ESPObjects[Player] = nil
end

local function CreatePlayerESP(
	Player,
	Character
)

	if Player == LocalPlayer then
		return
	end

	if not Character
		or not Character.Parent then
		return
	end

	RemovePlayerESP(
		Player
	)

	local Highlight =
		Instance.new("Highlight")

	Highlight.Adornee =
		Character

	Highlight.FillColor =
		ESPSettings.Color

	Highlight.OutlineColor =
		ESPSettings.Color

	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0

	Highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop

	Highlight.Parent =
		Character

	local NameLabel =
		CreateESPLabel(
			"Name",
			Vector2.new(
				180,
				22
			),
			11
		)

	NameLabel.Font =
		Enum.Font.GothamBold

	NameLabel.Parent =
		ESPGui

	local DistanceLabel =
		CreateESPLabel(
			"Distance",
			Vector2.new(
				180,
				18
			),
			10
		)

	DistanceLabel.Text =
		"0 studs"

	DistanceLabel.Parent =
		ESPGui

	local HealthText =
		CreateESPLabel(
			"HealthText",
			Vector2.new(
				180,
				18
			),
			10
		)

	HealthText.Visible = false
	HealthText.Parent =
		ESPGui

	local HealthBarBackground,
		HealthBarFill =
		CreateHealthBar()

	HealthBarBackground.Visible = true
	HealthBarBackground.Parent =
		ESPGui

	local Line =
		Instance.new("Frame")

	Line.Name =
		"ESPLine"

	Line.AnchorPoint =
		Vector2.new(
			0.5,
			0.5
		)

	Line.BackgroundColor3 =
		ESPSettings.Color

	Line.BorderSizePixel = 0

	Line.Size =
		UDim2.fromOffset(
			2,
			100
		)

	Line.Visible = false
	Line.ZIndex = 1
	Line.Parent =
		ESPGui

	ESPObjects[Player] = {

		Character =
			Character,

		Highlight =
			Highlight,

		NameLabel =
			NameLabel,

		DistanceLabel =
			DistanceLabel,

		HealthText =
			HealthText,

		HealthBarBackground =
			HealthBarBackground,

		HealthBarFill =
			HealthBarFill,

		Line =
			Line
	}
end

local function SetupESPPlayer(
	Player
)

	if Player == LocalPlayer then
		return
	end

	if Player.Character then

		CreatePlayerESP(
			Player,
			Player.Character
		)
	end

	Player.CharacterAdded:Connect(
		function(Character)

			task.wait()

			CreatePlayerESP(
				Player,
				Character
			)
		end
	)
end

--==================================================
-- ESP SCREEN POSITION UPDATE
--==================================================

local function UpdateESPOnScreen(
	Player,
	Data,
	LocalRoot
)

	local Character =
		Data.Character

	if not Character
		or not Character.Parent then

		Data.NameLabel.Visible = false
		Data.DistanceLabel.Visible = false
		Data.HealthText.Visible = false
		Data.HealthBarBackground.Visible = false
		Data.Line.Visible = false

		return
	end

	local BoundingCFrame,
		BoundingSize =
		Character:GetBoundingBox()

	local HalfHeight =
		BoundingSize.Y / 2

	local TopWorld =
		BoundingCFrame.Position +
		Vector3.new(
			0,
			HalfHeight,
			0
		)

	local BottomWorld =
		BoundingCFrame.Position -
		Vector3.new(
			0,
			HalfHeight,
			0
		)

	local TopScreen,
		TopVisible =
		Camera:WorldToViewportPoint(
			TopWorld
		)

	local BottomScreen,
		BottomVisible =
		Camera:WorldToViewportPoint(
			BottomWorld
		)

	local Root =
		Character:FindFirstChild(
			"HumanoidRootPart"
		)

	if not Root then
		return
	end

	local RootScreen,
		RootVisible =
		Camera:WorldToViewportPoint(
			Root.Position
		)

	if not (
		TopVisible
		or BottomVisible
		or RootVisible
	) then

		Data.NameLabel.Visible = false
		Data.DistanceLabel.Visible = false
		Data.HealthText.Visible = false
		Data.HealthBarBackground.Visible = false
		Data.Line.Visible = false

		return
	end

	local Distance = 0

	if LocalRoot then

		Distance =
			(
				Root.Position
				- LocalRoot.Position
			).Magnitude
	end

	--==================================================
	-- NAME
	--==================================================

	Data.NameLabel.TextColor3 =
		ESPSettings.TextColor

	Data.NameLabel.Text =
		Player.Name

	Data.NameLabel.Visible =
		ESPSettings.Enabled
		and ESPSettings.Names

	if Data.NameLabel.Visible then

		Data.NameLabel.Position =
			UDim2.fromOffset(
				math.floor(
					TopScreen.X - 90
				),
				math.floor(
					TopScreen.Y - 24
				)
			)
	end

	--==================================================
	-- DISTANCE
	--==================================================

	Data.DistanceLabel.Visible =
		ESPSettings.Enabled
		and ESPSettings.Distance

	Data.DistanceLabel.TextColor3 =
		ESPSettings.TextColor

	Data.DistanceLabel.Text =
		string.format(
			"%d studs",
			math.floor(
				Distance
			)
		)

	local InfoStartY =
		math.floor(
			BottomScreen.Y + 4
		)

	if Data.DistanceLabel.Visible then

		Data.DistanceLabel.Position =
			UDim2.fromOffset(
				math.floor(
					BottomScreen.X - 90
				),
				InfoStartY
			)

		InfoStartY += 17
	end

	--==================================================
	-- HEALTH
	--==================================================

	local Humanoid =
		Character:FindFirstChildOfClass(
			"Humanoid"
		)

	if not ESPSettings.Enabled
		or not ESPSettings.Health
		or not Humanoid then

		Data.HealthText.Visible = false
		Data.HealthBarBackground.Visible = false

	elseif HealthStyle == "Text" then

		Data.HealthText.Visible = true
		Data.HealthBarBackground.Visible = false

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

		Data.HealthText.Position =
			UDim2.fromOffset(
				math.floor(
					BottomScreen.X - 90
				),
				InfoStartY
			)

	else

		Data.HealthText.Visible = false
		Data.HealthBarBackground.Visible = true

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

		local BarWidth =
			math.clamp(
				140 /
					(
						1
						+ Distance / 70
					),
				32,
				140
			)

		local Gap =
			math.clamp(
				6 -
					(
						Distance / 100
					),
				2,
				6
			)

		Data.HealthBarBackground.Size =
			UDim2.fromOffset(
				BarWidth,
				7
			)

		Data.HealthBarBackground.Position =
			UDim2.fromOffset(
				math.floor(
					BottomScreen.X -
						BarWidth / 2
				),
				InfoStartY + Gap
			)

		if HealthRatio > 0.5 then

			local T =
				(
					1 -
					HealthRatio
				) * 2

			Data.HealthBarFill.BackgroundColor3 =
				Color3.fromRGB(
					math.floor(
						70 + 185 * T
					),
					220,
					90
				)

		else

			local T =
				HealthRatio * 2

			Data.HealthBarFill.BackgroundColor3 =
				Color3.fromRGB(
					220,
					math.floor(
						70 + 150 * T
					),
					70
				)
		end
	end

	--==================================================
	-- LINES
	--==================================================

	if ESPSettings.Enabled
		and ESPSettings.Lines
		and RootVisible then

		local Viewport =
			Camera.ViewportSize

		local Start =
			Vector2.new(
				Viewport.X / 2,
				Viewport.Y
			)

		local End =
			Vector2.new(
				RootScreen.X,
				RootScreen.Y
			)

		local Difference =
			End - Start

		local Length =
			Difference.Magnitude

		Data.Line.Visible = true

		Data.Line.BackgroundColor3 =
			ESPSettings.Color

		Data.Line.Size =
			UDim2.fromOffset(
				2,
				Length
			)

		Data.Line.Position =
			UDim2.fromOffset(
				(Start.X + End.X) / 2,
				(Start.Y + End.Y) / 2
			)

		Data.Line.Rotation =
			math.deg(
				math.atan2(
					Difference.Y,
					Difference.X
				)
			) + 90

	else

		Data.Line.Visible = false
	end
end

