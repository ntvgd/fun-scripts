--==================================================
-- FUN SCRIPTS LOGIC / RUNTIME
-- Execute ui.lua first, then this file.
--==================================================

local FS = getgenv().FunScripts
if not FS then
    error("FUN SCRIPTS: execute ui.lua first")
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

	if not FS.ESPSettings.Enabled
		or not Player.Team
		or not FS.ESPSettings.TargetTeams
		or next(FS.ESPSettings.TargetTeams) == nil
		or not FS.ESPSettings.TargetTeams[Player.Team.Name] then
		Data.NameLabel.Visible = false
		Data.DistanceLabel.Visible = false
		Data.HealthText.Visible = false
		Data.HealthBarBackground.Visible = false
		Data.Line.Visible = false
		return
	end

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
		FS.Camera:WorldToViewportPoint(
			TopWorld
		)

	local BottomScreen,
		BottomVisible =
		FS.Camera:WorldToViewportPoint(
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
		FS.Camera:WorldToViewportPoint(
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
		FS.ESPSettings.TextColor

	Data.NameLabel.Text =
		Player.Name

	Data.NameLabel.Visible =
		FS.ESPSettings.Enabled
		and FS.ESPSettings.Names

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
		FS.ESPSettings.Enabled
		and FS.ESPSettings.Distance

	Data.DistanceLabel.TextColor3 =
		FS.ESPSettings.TextColor

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

	if not FS.ESPSettings.Enabled
		or not FS.ESPSettings.Health
		or not Humanoid then

		Data.HealthText.Visible = false
		Data.HealthBarBackground.Visible = false

	elseif FS.HealthStyle == "Text" then

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
			FS.ESPSettings.TextColor

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

	if FS.ESPSettings.Enabled
		and FS.ESPSettings.Lines
		and RootVisible then

		local Viewport =
			FS.Camera.ViewportSize

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
			FS.ESPSettings.Color

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


--==================================================
-- AIMBOT HELPERS
--==================================================

local function GetAimbotTargetPart(
	Character
)

	if not Character then
		return nil
	end

	if FS.AimbotSettings.TargetMode == "Head" then

		return Character:FindFirstChild(
			"Head"
		)

	elseif FS.AimbotSettings.TargetMode == "Torso" then

		return Character:FindFirstChild(
			"UpperTorso"
		)
		or Character:FindFirstChild(
			"Torso"
		)
		or Character:FindFirstChild(
			"HumanoidRootPart"
		)

	else

		if FS.AlternateTarget == "Head" then

			return Character:FindFirstChild(
				"Head"
			)

		else

			return Character:FindFirstChild(
				"UpperTorso"
			)
			or Character:FindFirstChild(
				"Torso"
			)
			or Character:FindFirstChild(
				"HumanoidRootPart"
			)
		end
	end
end

local function HasClearLineOfSight(
	TargetCharacter,
	TargetPart
)

	if not TargetCharacter
		or not TargetPart then

		return false
	end

	local CurrentCamera =
		workspace.CurrentCamera

	if not CurrentCamera then
		return false
	end

	local Origin =
		CurrentCamera.CFrame.Position

	local TargetPosition =
		TargetPart.Position

	local Direction =
		TargetPosition - Origin

	if Direction.Magnitude <= 0 then
		return false
	end

	local Params =
		RaycastParams.new()

	Params.FilterType =
		Enum.RaycastFilterType.Exclude

	local FilterList = {}

	if FS.LocalPlayer.Character then
		table.insert(
			FilterList,
			FS.LocalPlayer.Character
		)
	end

	Params.FilterDescendantsInstances =
		FilterList

	Params.IgnoreWater = true

	local Result =
		workspace:Raycast(
			Origin,
			Direction,
			Params
		)

	if not Result then
		return true
	end

	return Result.Instance:IsDescendantOf(
		TargetCharacter
	)
end

local function GetClosestAimbotTarget()

	local CurrentCamera =
		workspace.CurrentCamera

	if not CurrentCamera then
		return nil
	end

	local Viewport =
		CurrentCamera.ViewportSize

	local Center =
		Vector2.new(
			Viewport.X / 2,
			Viewport.Y / 2
		)

	local BestPlayer = nil
	local BestScreenDistance = math.huge

	for _, Player in ipairs(
		FS.Players:GetPlayers()
	) do

		if Player == FS.LocalPlayer then
			continue
		end

		if not Player.Team then
			continue
		end

		local TargetTeams =
			FS.AimbotSettings.TargetTeams

		if TargetTeams
			and next(TargetTeams) ~= nil
			and not TargetTeams[Player.Team.Name] then
			continue
		end

		local Character =
			Player.Character

		if not Character then
			continue
		end

		local Humanoid =
			Character:FindFirstChildOfClass(
				"Humanoid"
			)

		if not Humanoid
			or Humanoid.Health <= 0 then

			continue
		end

		local TargetPart =
			GetAimbotTargetPart(
				Character
			)

		if not TargetPart then
			continue
		end

		local ScreenPosition,
			OnScreen =
			CurrentCamera:WorldToViewportPoint(
				TargetPart.Position
			)

		if not OnScreen then
			continue
		end

		local ScreenPoint =
			Vector2.new(
				ScreenPosition.X,
				ScreenPosition.Y
			)

		local ScreenDistance =
			(
				ScreenPoint - Center
			).Magnitude

		if ScreenDistance >
			FS.AimbotSettings.Radius then

			continue
		end

		if FS.AimbotSettings.LineOfSight then

			if not HasClearLineOfSight(
				Character,
				TargetPart
			) then

				continue
			end
		end

		if ScreenDistance <
			BestScreenDistance then

			BestScreenDistance =
				ScreenDistance

			BestPlayer =
				Player
		end
	end

	return BestPlayer
end

local function UpdateAimbotTarget()

	if not FS.AimbotSettings.Enabled
		or not FS.AimbotHolding
		or FS.SpectatingPlayer then

		FS.AimbotTarget = nil
		return
	end

	FS.AimbotTarget =
		GetClosestAimbotTarget()
end

--==================================================
-- PLAYER SETUP
--==================================================

for _, Player in ipairs(
	FS.Players:GetPlayers()
) do

	FS.CreatePlayerButton(
		Player
	)

	FS.SetupESPPlayer(
		Player
	)

	Player.CharacterAdded:Connect(
		function(Character)

			FS.HandleCharacterAdded(
				Player,
				Character
			)
		end
	)
end

FS.SortPlayerButtons()

FS.Players.PlayerAdded:Connect(
	function(Player)

		FS.CreatePlayerButton(
			Player
		)

		FS.SetupESPPlayer(
			Player
		)

		Player.CharacterAdded:Connect(
			function(Character)

				FS.HandleCharacterAdded(
					Player,
					Character
				)
			end
		)

		FS.SortPlayerButtons()
	end
)

FS.Players.PlayerRemoving:Connect(
	function(Player)

		FS.RemovePlayerESP(
			Player
		)

		FS.RemovePlayerButton(
			Player
		)
	end
)

--==================================================
-- LIVE UPDATE
--==================================================

FS.RunService.RenderStepped:Connect(
	function()

		--==============================================
		-- PLAYER LIST
		--==============================================

		for Player in pairs(
			FS.PlayerButtons
		) do

			if Player.Parent ==
				FS.Players then

				FS.UpdatePlayerButton(
					Player
				)
			end
		end

		--==============================================
		-- LOCAL ROOT
		--==============================================

		local LocalCharacter =
			FS.LocalPlayer.Character

		local LocalRoot =
			LocalCharacter
			and LocalCharacter:FindFirstChild(
				"HumanoidRootPart"
			)

		--==============================================
		-- ESP
		--==============================================

		for Player, Data in pairs(
			FS.ESPObjects
		) do

			UpdateESPOnScreen(
				Player,
				Data,
				LocalRoot
			)

			if Data.Highlight then

				local TeamSelected =
					Player.Team
					and FS.ESPSettings.TargetTeams
					and next(FS.ESPSettings.TargetTeams) ~= nil
					and FS.ESPSettings.TargetTeams[Player.Team.Name] == true

				Data.Highlight.Enabled =
					FS.ESPSettings.Enabled
					and TeamSelected == true

				local HighlightColor =
					FS.ESPSettings.Color

				if FS.ESPSettings.UseTeamColor
					and Player.Team
					and Player.Team.TeamColor then
					HighlightColor = Player.Team.TeamColor.Color
				end

				Data.Highlight.FillColor = HighlightColor
				Data.Highlight.OutlineColor = HighlightColor
			end
		end

		--==============================================
		-- AIMBOT FOV CIRCLE
		--==============================================

		local Viewport =
			FS.Camera.ViewportSize

		FS.AimbotCircle.Size =
			UDim2.fromOffset(
				FS.AimbotSettings.Radius * 2,
				FS.AimbotSettings.Radius * 2
			)

		FS.AimbotCircle.Position =
			UDim2.fromOffset(
				Viewport.X / 2,
				Viewport.Y / 2
			)

		FS.AimbotCircle.Visible =
			FS.AimbotSettings.Enabled
			and FS.AimbotSettings.ShowFOV

		FS.AimbotCircleStroke.Transparency =
			1 - FS.AimbotSettings.FOVOpacity

		FS.AimbotCircleStroke.Color =
			FS.AimbotSettings.FOVColor

		--==============================================
		-- SPECTATE
		--==============================================

		if FS.SpectatingPlayer then

			local Humanoid =
				FS.GetHumanoid(
					FS.SpectatingPlayer
				)

			local CurrentCamera =
				workspace.CurrentCamera

			if Humanoid
				and CurrentCamera.CameraSubject
					~= Humanoid then

				CurrentCamera.CameraType =
					Enum.CameraType.Custom

				CurrentCamera.CameraSubject =
					Humanoid
			end
		end

		--==============================================
		-- AIMBOT TARGET SEARCH
		--==============================================

		UpdateAimbotTarget()
	end
)

--==================================================
-- AIMBOT CAMERA LOCK
--==================================================

FS.RunService:BindToRenderStep(
	"FunScripts_AimbotCamera",
	Enum.RenderPriority.Camera.Value + 1,
	function()

		if not FS.AimbotSettings.Enabled
			or not FS.AimbotHolding
			or FS.SpectatingPlayer then

			return
		end

		local TargetPlayer =
			FS.AimbotTarget

		if not TargetPlayer
			or TargetPlayer.Parent ~=
				FS.Players then

			return
		end

		local Character =
			TargetPlayer.Character

		if not Character then
			return
		end

		local Humanoid =
			Character:FindFirstChildOfClass(
				"Humanoid"
			)

		if not Humanoid
			or Humanoid.Health <= 0 then

			FS.AimbotTarget = nil
			return
		end

		local TargetPart =
			GetAimbotTargetPart(
				Character
			)

		if not TargetPart then
			FS.AimbotTarget = nil
			return
		end

		if FS.AimbotSettings.LineOfSight then

			if not HasClearLineOfSight(
				Character,
				TargetPart
			) then

				FS.AimbotTarget = nil
				return
			end
		end

		local CurrentCamera =
			workspace.CurrentCamera

		CurrentCamera.CFrame =
			CFrame.lookAt(
				CurrentCamera.CFrame.Position,
				TargetPart.Position
			)
	end
)

--==================================================
-- STOP SPECTATING
--==================================================

FS.StopButton.MouseButton1Click:Connect(
	function()

		FS.StopSpectating()
	end
)

--==================================================
-- AIMBOT INPUT
--==================================================

FS.UserInputService.InputBegan:Connect(
	function(Input)

		if Input.UserInputType ==
			FS.AimbotSettings.AimKey then

			if not FS.AimbotSettings.Enabled
				or FS.SpectatingPlayer then

				return
			end

			FS.AimbotHolding = true

			if FS.AimbotSettings.TargetMode ==
				"Alternate" then

				if FS.AlternateTarget == "Head" then
					FS.AlternateTarget = "Torso"
				else
					FS.AlternateTarget = "Head"
				end
			end
		end
	end
)

FS.UserInputService.InputEnded:Connect(
	function(Input)

		if Input.UserInputType ==
			FS.AimbotSettings.AimKey then

			FS.AimbotHolding = false
			FS.AimbotTarget = nil
		end
	end
)

--==================================================
-- KEYBIND UI
--==================================================

FS.TeleportKeybind.MouseButton1Click:Connect(
	function()

		if FS.WaitingForTeleportKey then
			return
		end

		FS.WaitingForTeleportKey = true

		FS.TeleportKeybind.Text =
			"Press a key..."

		FS.TeleportKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

FS.ReopenKeybind.MouseButton1Click:Connect(
	function()

		if FS.WaitingForReopenKey then
			return
		end

		FS.WaitingForReopenKey = true

		FS.ReopenKeybind.Text =
			"Press a key..."

		FS.ReopenKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

FS.StopSpectatingKeybind.MouseButton1Click:Connect(
	function()

		if FS.WaitingForStopSpectatingKey then
			return
		end

		FS.WaitingForStopSpectatingKey = true

		FS.StopSpectatingKeybind.Text =
			"Press a key..."

		FS.StopSpectatingKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

FS.UnlockCamKeybind.MouseButton1Click:Connect(
	function()

		if FS.WaitingForUnlockCamKey then
			return
		end

		FS.WaitingForUnlockCamKey = true

		FS.UnlockCamKeybind.Text =
			"Press a key..."

		FS.UnlockCamKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

FS.AimbotKeybind.MouseButton1Click:Connect(
	function()

		if FS.WaitingForAimbotKey then
			return
		end

		FS.WaitingForAimbotKey = true

		FS.AimbotKeybind.Text =
			"Press a key..."

		FS.AimbotKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

--==================================================
-- KEYBIND DISPLAY HELPER
--==================================================

local function KeyName(Key)
	return Key and Key.Name or "UNBOUND"
end

--==================================================
-- INPUT
--==================================================

FS.UserInputService.InputBegan:Connect(
	function(Input)

		--==============================================
		-- TELEPORT ASSIGNMENT
		--==============================================

		if FS.WaitingForTeleportKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				FS.BoundReopenKey
				or Input.KeyCode ==
					FS.BoundStopSpectatingKey
				or Input.KeyCode ==
					FS.BoundUnlockCamKey
				or (
					FS.BoundAimbotKey
					and Input.KeyCode ==
						FS.BoundAimbotKey
				) then

				FS.TeleportKeybind.Text =
					"Already used"

				FS.TeleportKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						FS.TeleportKeybind.Text =
							KeyName(FS.BoundTeleportKey)

						FS.TeleportKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				FS.WaitingForTeleportKey = false
				return
			end

			FS.BoundTeleportKey =
				Input.KeyCode

			FS.WaitingForTeleportKey = false

			FS.TeleportKeybind.Text =
				KeyName(FS.BoundTeleportKey)

			FS.TeleportKeybind.TextColor3 =
				Color3.fromRGB(
					100,
					255,
					100
				)

			return
		end

		--==============================================
		-- REOPEN ASSIGNMENT
		--==============================================

		if FS.WaitingForReopenKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				FS.BoundTeleportKey
				or Input.KeyCode ==
					FS.BoundStopSpectatingKey
				or Input.KeyCode ==
					FS.BoundUnlockCamKey
				or (
					FS.BoundAimbotKey
					and Input.KeyCode ==
						FS.BoundAimbotKey
				) then

				FS.ReopenKeybind.Text =
					"Already used"

				FS.ReopenKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						FS.ReopenKeybind.Text =
							KeyName(FS.BoundReopenKey)

						FS.ReopenKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				FS.WaitingForReopenKey = false
				return
			end

			FS.BoundReopenKey =
				Input.KeyCode

			FS.WaitingForReopenKey = false

			FS.ReopenKeybind.Text =
				KeyName(FS.BoundReopenKey)

			FS.ReopenKeybind.TextColor3 =
				Color3.fromRGB(
					100,
					255,
					100
				)

			return
		end

		--==============================================
		-- STOP SPECTATING ASSIGNMENT
		--==============================================

		if FS.WaitingForStopSpectatingKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				FS.BoundTeleportKey
				or Input.KeyCode ==
					FS.BoundReopenKey
				or Input.KeyCode ==
					FS.BoundUnlockCamKey
				or (
					FS.BoundAimbotKey
					and Input.KeyCode ==
						FS.BoundAimbotKey
				) then

				FS.StopSpectatingKeybind.Text =
					"Already used"

				FS.StopSpectatingKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						FS.StopSpectatingKeybind.Text =
							KeyName(FS.BoundStopSpectatingKey)

						FS.StopSpectatingKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				FS.WaitingForStopSpectatingKey = false
				return
			end

			FS.BoundStopSpectatingKey =
				Input.KeyCode

			FS.WaitingForStopSpectatingKey = false

			FS.StopSpectatingKeybind.Text =
				KeyName(FS.BoundStopSpectatingKey)

			FS.StopSpectatingKeybind.TextColor3 =
				Color3.fromRGB(
					100,
					255,
					100
				)

			return
		end

		--==============================================
		-- FREE CAM ASSIGNMENT
		--==============================================

		if FS.WaitingForUnlockCamKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				FS.BoundTeleportKey
				or Input.KeyCode ==
					FS.BoundReopenKey
				or Input.KeyCode ==
					FS.BoundStopSpectatingKey
				or (
					FS.BoundAimbotKey
					and Input.KeyCode ==
						FS.BoundAimbotKey
				) then

				FS.UnlockCamKeybind.Text =
					"Already used"

				FS.UnlockCamKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						FS.UnlockCamKeybind.Text =
							KeyName(FS.BoundUnlockCamKey)

						FS.UnlockCamKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				FS.WaitingForUnlockCamKey = false
				return
			end

			FS.BoundUnlockCamKey =
				Input.KeyCode

			FS.WaitingForUnlockCamKey = false

			FS.UnlockCamKeybind.Text =
				KeyName(FS.BoundUnlockCamKey)

			FS.UnlockCamKeybind.TextColor3 =
				Color3.fromRGB(
					100,
					255,
					100
				)

			return
		end

		--==============================================
		-- AIMBOT ASSIGNMENT
		--==============================================

		if FS.WaitingForAimbotKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				FS.BoundTeleportKey
				or Input.KeyCode ==
					FS.BoundReopenKey
				or Input.KeyCode ==
					FS.BoundStopSpectatingKey
				or Input.KeyCode ==
					FS.BoundUnlockCamKey then

				FS.AimbotKeybind.Text =
					"Already used"

				FS.AimbotKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						if FS.BoundAimbotKey then
							FS.AimbotKeybind.Text =
								KeyName(FS.BoundAimbotKey)
						else
							FS.AimbotKeybind.Text =
								"UNBOUND"
						end

						FS.AimbotKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				FS.WaitingForAimbotKey = false
				return
			end

			FS.BoundAimbotKey =
				Input.KeyCode

			FS.WaitingForAimbotKey = false

			FS.AimbotKeybind.Text =
				KeyName(FS.BoundAimbotKey)

			FS.AimbotKeybind.TextColor3 =
				Color3.fromRGB(
					100,
					255,
					100
				)

			return
		end

		--==============================================
		-- AIMBOT TOGGLE KEY
		--==============================================

		if FS.BoundAimbotKey
			and Input.KeyCode ==
				FS.BoundAimbotKey then

			FS.AimbotSettings.Enabled =
				not FS.AimbotSettings.Enabled

			if not FS.AimbotSettings.Enabled then

				FS.AimbotHolding = false
				FS.AimbotTarget = nil
			end

			FS.UpdateAimbotTabToggle()
			return
		end

		--==============================================
		-- STOP SPECTATING
		--==============================================

		if FS.BoundStopSpectatingKey
			and Input.KeyCode ==
				FS.BoundStopSpectatingKey then

			FS.StopSpectating()
			return
		end

		--==============================================
		-- REOPEN
		--==============================================

		if FS.BoundReopenKey
			and Input.KeyCode ==
				FS.BoundReopenKey then

			FS.Main.Visible = true
			return
		end

		--==============================================
		-- FREE CAM
		--==============================================

		if FS.BoundUnlockCamKey
			and Input.KeyCode ==
				FS.BoundUnlockCamKey then

			FS.ToggleUnlockCam()
			return
		end

		--==============================================
		-- TELEPORT
		--==============================================

		if FS.BoundTeleportKey
			and Input.KeyCode ==
				FS.BoundTeleportKey then

			local Character =
				FS.LocalPlayer.Character

			if not Character then
				return
			end

			local Root =
				Character:FindFirstChild(
					"HumanoidRootPart"
				)

			if not Root then
				return
			end

			local TargetPosition =
				FS.Mouse.Hit.Position

			local FinalPosition =
				TargetPosition +
				Vector3.new(
					0,
					3,
					0
				)

			local CurrentCFrame =
				Root.CFrame

			local RotationOnly =
				CurrentCFrame -
				CurrentCFrame.Position

			Root.CFrame =
				CFrame.new(
					FinalPosition
				) *
				RotationOnly
		end
	end
)

--==================================================
-- INITIAL TAB
--==================================================

FS.UpdateTabs()
FS.LogicReady = true
