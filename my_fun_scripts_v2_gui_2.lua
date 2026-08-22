--==================================================
-- AIMBOT HELPERS
--==================================================

local function GetAimbotTargetPart(
	Character
)

	if not Character then
		return nil
	end

	if AimbotSettings.TargetMode == "Head" then

		return Character:FindFirstChild(
			"Head"
		)

	elseif AimbotSettings.TargetMode == "Torso" then

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

		if AlternateTarget == "Head" then

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

	if LocalPlayer.Character then
		table.insert(
			FilterList,
			LocalPlayer.Character
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
		Players:GetPlayers()
	) do

		if Player == LocalPlayer then
			continue
		end

		if Player.Team then
			if not AimbotSettings.SelectedTeams
				or not AimbotSettings.SelectedTeams[Player.Team.Name] then
				continue
			end
		else
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
			AimbotSettings.Radius then

			continue
		end

		if AimbotSettings.LineOfSight then

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

	if not AimbotSettings.Enabled
		or not AimbotHolding
		or SpectatingPlayer then

		AimbotTarget = nil
		return
	end

	AimbotTarget =
		GetClosestAimbotTarget()
end

--==================================================
-- PLAYER SETUP
--==================================================

for _, Player in ipairs(
	Players:GetPlayers()
) do

	CreatePlayerButton(
		Player
	)

	SetupESPPlayer(
		Player
	)

	Player.CharacterAdded:Connect(
		function(Character)

			HandleCharacterAdded(
				Player,
				Character
			)
		end
	)
end

SortPlayerButtons()

Players.PlayerAdded:Connect(
	function(Player)

		CreatePlayerButton(
			Player
		)

		SetupESPPlayer(
			Player
		)

		Player.CharacterAdded:Connect(
			function(Character)

				HandleCharacterAdded(
					Player,
					Character
				)
			end
		)

		SortPlayerButtons()
	end
)

Players.PlayerRemoving:Connect(
	function(Player)

		RemovePlayerESP(
			Player
		)

		RemovePlayerButton(
			Player
		)
	end
)

--==================================================
-- LIVE UPDATE
--==================================================

RunService.RenderStepped:Connect(
	function()

		--==============================================
		-- PLAYER LIST
		--==============================================

		for Player in pairs(
			PlayerButtons
		) do

			if Player.Parent ==
				Players then

				UpdatePlayerButton(
					Player
				)
			end
		end

		--==============================================
		-- LOCAL ROOT
		--==============================================

		local LocalCharacter =
			LocalPlayer.Character

		local LocalRoot =
			LocalCharacter
			and LocalCharacter:FindFirstChild(
				"HumanoidRootPart"
			)

		--==============================================
		-- ESP
		--==============================================

		for Player, Data in pairs(
			ESPObjects
		) do

			UpdateESPOnScreen(
				Player,
				Data,
				LocalRoot
			)

			if Data.Highlight then

				Data.Highlight.Enabled =
					ESPSettings.Enabled

				Data.Highlight.FillColor =
					ESPSettings.Color

				Data.Highlight.OutlineColor =
					ESPSettings.Color
			end
		end

		--==============================================
		-- AIMBOT FOV CIRCLE
		--==============================================

		local Viewport =
			Camera.ViewportSize

		AimbotCircle.Size =
			UDim2.fromOffset(
				AimbotSettings.Radius * 2,
				AimbotSettings.Radius * 2
			)

		AimbotCircle.Position =
			UDim2.fromOffset(
				Viewport.X / 2,
				Viewport.Y / 2
			)

		AimbotCircle.Visible =
			AimbotSettings.Enabled
			and AimbotSettings.ShowFOV

		AimbotCircleStroke.Transparency =
			1 - AimbotSettings.FOVOpacity

		AimbotCircleStroke.Color =
			AimbotSettings.FOVColor

		--==============================================
		-- SPECTATE
		--==============================================

		if SpectatingPlayer then

			local Humanoid =
				GetHumanoid(
					SpectatingPlayer
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

RunService:BindToRenderStep(
	"FunScripts_AimbotCamera",
	Enum.RenderPriority.Camera.Value + 1,
	function()

		if not AimbotSettings.Enabled
			or not AimbotHolding
			or SpectatingPlayer then

			return
		end

		local TargetPlayer =
			AimbotTarget

		if not TargetPlayer
			or TargetPlayer.Parent ~=
				Players then

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

			AimbotTarget = nil
			return
		end

		local TargetPart =
			GetAimbotTargetPart(
				Character
			)

		if not TargetPart then
			AimbotTarget = nil
			return
		end

		if AimbotSettings.LineOfSight then

			if not HasClearLineOfSight(
				Character,
				TargetPart
			) then

				AimbotTarget = nil
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

StopButton.MouseButton1Click:Connect(
	function()

		StopSpectating()
	end
)

--==================================================
-- AIMBOT INPUT
--==================================================

UserInputService.InputBegan:Connect(
	function(Input)

		if Input.UserInputType ==
			AimbotSettings.AimKey then

			if not AimbotSettings.Enabled
				or SpectatingPlayer then

				return
			end

			AimbotHolding = true

			if AimbotSettings.TargetMode ==
				"Alternate" then

				if AlternateTarget == "Head" then
					AlternateTarget = "Torso"
				else
					AlternateTarget = "Head"
				end
			end
		end
	end
)

UserInputService.InputEnded:Connect(
	function(Input)

		if Input.UserInputType ==
			AimbotSettings.AimKey then

			AimbotHolding = false
			AimbotTarget = nil
		end
	end
)

--==================================================
-- KEYBIND UI
--==================================================

TeleportKeybind.MouseButton1Click:Connect(
	function()

		if WaitingForTeleportKey then
			return
		end

		WaitingForTeleportKey = true

		TeleportKeybind.Text =
			"Press a key..."

		TeleportKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

ReopenKeybind.MouseButton1Click:Connect(
	function()

		if WaitingForReopenKey then
			return
		end

		WaitingForReopenKey = true

		ReopenKeybind.Text =
			"Press a key..."

		ReopenKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

StopSpectatingKeybind.MouseButton1Click:Connect(
	function()

		if WaitingForStopSpectatingKey then
			return
		end

		WaitingForStopSpectatingKey = true

		StopSpectatingKeybind.Text =
			"Press a key..."

		StopSpectatingKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

UnlockCamKeybind.MouseButton1Click:Connect(
	function()

		if WaitingForUnlockCamKey then
			return
		end

		WaitingForUnlockCamKey = true

		UnlockCamKeybind.Text =
			"Press a key..."

		UnlockCamKeybind.TextColor3 =
			Color3.fromRGB(
				255,
				220,
				100
			)
	end
)

AimbotKeybind.MouseButton1Click:Connect(
	function()

		if WaitingForAimbotKey then
			return
		end

		WaitingForAimbotKey = true

		AimbotKeybind.Text =
			"Press a key..."

		AimbotKeybind.TextColor3 =
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

UserInputService.InputBegan:Connect(
	function(Input)

		--==============================================
		-- TELEPORT ASSIGNMENT
		--==============================================

		if WaitingForTeleportKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				BoundReopenKey
				or Input.KeyCode ==
					BoundStopSpectatingKey
				or Input.KeyCode ==
					BoundUnlockCamKey
				or (
					BoundAimbotKey
					and Input.KeyCode ==
						BoundAimbotKey
				) then

				TeleportKeybind.Text =
					"Already used"

				TeleportKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						TeleportKeybind.Text =
							KeyName(BoundTeleportKey)

						TeleportKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				WaitingForTeleportKey = false
				return
			end

			BoundTeleportKey =
				Input.KeyCode

			WaitingForTeleportKey = false

			TeleportKeybind.Text =
				KeyName(BoundTeleportKey)

			TeleportKeybind.TextColor3 =
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

		if WaitingForReopenKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				BoundTeleportKey
				or Input.KeyCode ==
					BoundStopSpectatingKey
				or Input.KeyCode ==
					BoundUnlockCamKey
				or (
					BoundAimbotKey
					and Input.KeyCode ==
						BoundAimbotKey
				) then

				ReopenKeybind.Text =
					"Already used"

				ReopenKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						ReopenKeybind.Text =
							KeyName(BoundReopenKey)

						ReopenKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				WaitingForReopenKey = false
				return
			end

			BoundReopenKey =
				Input.KeyCode

			WaitingForReopenKey = false

			ReopenKeybind.Text =
				KeyName(BoundReopenKey)

			ReopenKeybind.TextColor3 =
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

		if WaitingForStopSpectatingKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				BoundTeleportKey
				or Input.KeyCode ==
					BoundReopenKey
				or Input.KeyCode ==
					BoundUnlockCamKey
				or (
					BoundAimbotKey
					and Input.KeyCode ==
						BoundAimbotKey
				) then

				StopSpectatingKeybind.Text =
					"Already used"

				StopSpectatingKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						StopSpectatingKeybind.Text =
							KeyName(BoundStopSpectatingKey)

						StopSpectatingKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				WaitingForStopSpectatingKey = false
				return
			end

			BoundStopSpectatingKey =
				Input.KeyCode

			WaitingForStopSpectatingKey = false

			StopSpectatingKeybind.Text =
				KeyName(BoundStopSpectatingKey)

			StopSpectatingKeybind.TextColor3 =
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

		if WaitingForUnlockCamKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				BoundTeleportKey
				or Input.KeyCode ==
					BoundReopenKey
				or Input.KeyCode ==
					BoundStopSpectatingKey
				or (
					BoundAimbotKey
					and Input.KeyCode ==
						BoundAimbotKey
				) then

				UnlockCamKeybind.Text =
					"Already used"

				UnlockCamKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						UnlockCamKeybind.Text =
							KeyName(BoundUnlockCamKey)

						UnlockCamKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				WaitingForUnlockCamKey = false
				return
			end

			BoundUnlockCamKey =
				Input.KeyCode

			WaitingForUnlockCamKey = false

			UnlockCamKeybind.Text =
				KeyName(BoundUnlockCamKey)

			UnlockCamKeybind.TextColor3 =
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

		if WaitingForAimbotKey then

			if Input.UserInputType ~=
				Enum.UserInputType.Keyboard then

				return
			end

			if Input.KeyCode ==
				BoundTeleportKey
				or Input.KeyCode ==
					BoundReopenKey
				or Input.KeyCode ==
					BoundStopSpectatingKey
				or Input.KeyCode ==
					BoundUnlockCamKey then

				AimbotKeybind.Text =
					"Already used"

				AimbotKeybind.TextColor3 =
					Color3.fromRGB(
						255,
						100,
						100
					)

				task.delay(
					1,
					function()

						if BoundAimbotKey then
							AimbotKeybind.Text =
								KeyName(BoundAimbotKey)
						else
							AimbotKeybind.Text =
								"UNBOUND"
						end

						AimbotKeybind.TextColor3 =
							Color3.fromRGB(
								100,
								255,
								100
							)
					end
				)

				WaitingForAimbotKey = false
				return
			end

			BoundAimbotKey =
				Input.KeyCode

			WaitingForAimbotKey = false

			AimbotKeybind.Text =
				KeyName(BoundAimbotKey)

			AimbotKeybind.TextColor3 =
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

		if BoundAimbotKey
			and Input.KeyCode ==
				BoundAimbotKey then

			AimbotSettings.Enabled =
				not AimbotSettings.Enabled

			if not AimbotSettings.Enabled then

				AimbotHolding = false
				AimbotTarget = nil
			end

			UpdateAimbotTabToggle()
			return
		end

		--==============================================
		-- STOP SPECTATING
		--==============================================

		if BoundStopSpectatingKey
			and Input.KeyCode ==
				BoundStopSpectatingKey then

			StopSpectating()
			return
		end

		--==============================================
		-- REOPEN
		--==============================================

		if BoundReopenKey
			and Input.KeyCode ==
				BoundReopenKey then

			Main.Visible = true
			return
		end

		--==============================================
		-- FREE CAM
		--==============================================

		if BoundUnlockCamKey
			and Input.KeyCode ==
				BoundUnlockCamKey then

			ToggleUnlockCam()
			return
		end

		--==============================================
		-- TELEPORT
		--==============================================

		if BoundTeleportKey
			and Input.KeyCode ==
				BoundTeleportKey then

			local Character =
				LocalPlayer.Character

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
				Mouse.Hit.Position

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

UpdateTabs()