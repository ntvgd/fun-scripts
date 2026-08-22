local RightResize =
	Instance.new("Frame")
RightResize.Size =
	UDim2.new(
		0,
		8,
		1,
		-50
	)
RightResize.Position =
	UDim2.new(
		1,
		-4,
		0,
		42
	)
RightResize.BackgroundTransparency = 1
RightResize.BorderSizePixel = 0
RightResize.Active = true
RightResize.ZIndex = 50
RightResize.Parent =
	Main
local RightIndicator =
	Instance.new("Frame")
RightIndicator.Size =
	UDim2.new(
		0,
		3,
		1,
		-10
	)
RightIndicator.Position =
	UDim2.new(
		0.5,
		-1,
		0,
		5
	)
RightIndicator.BackgroundColor3 =
	Color3.fromRGB(
		80,
		80,
		80
	)
RightIndicator.BackgroundTransparency = 1
RightIndicator.BorderSizePixel = 0
RightIndicator.Parent =
	RightResize
local BottomResize =
	Instance.new("Frame")
BottomResize.Size =
	UDim2.new(
		1,
		-50,
		0,
		8
	)
BottomResize.Position =
	UDim2.new(
		0,
		42,
		1,
		-4
	)
BottomResize.BackgroundTransparency = 1
BottomResize.BorderSizePixel = 0
BottomResize.Active = true
BottomResize.ZIndex = 50
BottomResize.Parent =
	Main
local BottomIndicator =
	Instance.new("Frame")
BottomIndicator.Size =
	UDim2.new(
		1,
		-10,
		0,
		3
	)
BottomIndicator.Position =
	UDim2.new(
		0,
		5,
		0.5,
		-1
	)
BottomIndicator.BackgroundColor3 =
	Color3.fromRGB(
		80,
		80,
		80
	)
BottomIndicator.BackgroundTransparency = 1
BottomIndicator.BorderSizePixel = 0
BottomIndicator.Parent =
	BottomResize
local CornerResize =
	Instance.new("Frame")
CornerResize.Size =
	UDim2.new(
		0,
		16,
		0,
		16
	)
CornerResize.Position =
	UDim2.new(
		1,
		-16,
		1,
		-16
	)
CornerResize.BackgroundTransparency = 1
CornerResize.BorderSizePixel = 0
CornerResize.Active = true
CornerResize.ZIndex = 55
CornerResize.Parent =
	Main
local CornerGrip =
	Instance.new("Frame")
CornerGrip.Size =
	UDim2.new(
		0,
		10,
		0,
		10
	)
CornerGrip.Position =
	UDim2.new(
		1,
		-10,
		1,
		-10
	)
CornerGrip.BackgroundTransparency = 1
CornerGrip.BorderSizePixel = 0
CornerGrip.Parent =
	CornerResize
local Grip1 =
	Instance.new("Frame")
Grip1.Size =
	UDim2.new(
		0,
		2,
		0,
		8
	)
Grip1.Position =
	UDim2.new(
		0,
		3,
		0,
		2
	)
Grip1.Rotation = 45
Grip1.BackgroundColor3 =
	Color3.fromRGB(
		80,
		80,
		80
	)
Grip1.BackgroundTransparency = 1
Grip1.BorderSizePixel = 0
Grip1.Parent =
	CornerGrip
local Grip2 =
	Instance.new("Frame")
Grip2.Size =
	UDim2.new(
		0,
		2,
		0,
		8
	)
Grip2.Position =
	UDim2.new(
		0,
		6,
		0,
		1
	)
Grip2.Rotation = 45
Grip2.BackgroundColor3 =
	Color3.fromRGB(
		80,
		80,
		80
	)
Grip2.BackgroundTransparency = 1
Grip2.BorderSizePixel = 0
Grip2.Parent =
	CornerGrip
local function SetResizeHover(
	Indicator,
	Hovered
)
	if Hovered then
		Indicator.BackgroundTransparency = 0
		Indicator.BackgroundColor3 =
			Color3.fromRGB(
				120,
				180,
				255
			)
	else
		Indicator.BackgroundTransparency = 1
	end
end
RightResize.MouseEnter:Connect(
	function()
		SetResizeHover(
			RightIndicator,
			true
		)
	end
)
RightResize.MouseLeave:Connect(
	function()
		SetResizeHover(
			RightIndicator,
			false
		)
	end
)
BottomResize.MouseEnter:Connect(
	function()
		SetResizeHover(
			BottomIndicator,
			true
		)
	end
)
BottomResize.MouseLeave:Connect(
	function()
		SetResizeHover(
			BottomIndicator,
			false
		)
	end
)
CornerResize.MouseEnter:Connect(
	function()
		RightIndicator.BackgroundTransparency = 0
		BottomIndicator.BackgroundTransparency = 0
		Grip1.BackgroundTransparency = 0
		Grip2.BackgroundTransparency = 0
		local C =
			Color3.fromRGB(
				120,
				180,
				255
			)
		RightIndicator.BackgroundColor3 = C
		BottomIndicator.BackgroundColor3 = C
		Grip1.BackgroundColor3 = C
		Grip2.BackgroundColor3 = C
	end
)
CornerResize.MouseLeave:Connect(
	function()
		RightIndicator.BackgroundTransparency = 1
		BottomIndicator.BackgroundTransparency = 1
		Grip1.BackgroundTransparency = 1
		Grip2.BackgroundTransparency = 1
	end
)
local ResizeMode = nil
local ResizeStartMouse = nil
local ResizeStartSize = nil
local function BeginResize(
	Mode,
	Input
)
	ResizeMode = Mode
	ResizeStartMouse = Input.Position
	ResizeStartSize = Main.AbsoluteSize
end
RightResize.InputBegan:Connect(
	function(Input)
		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then
			BeginResize(
				"Right",
				Input
			)
		end
	end
)
BottomResize.InputBegan:Connect(
	function(Input)
		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then
			BeginResize(
				"Bottom",
				Input
			)
		end
	end
)
CornerResize.InputBegan:Connect(
	function(Input)
		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then
			BeginResize(
				"Corner",
				Input
			)
		end
	end
)
UserInputService.InputChanged:Connect(
	function(Input)
		if not ResizeMode then
			return
		end
		if Input.UserInputType ~=
			Enum.UserInputType.MouseMovement then
			return
		end
		local Delta =
			Input.Position -
			ResizeStartMouse
		local NewWidth =
			ResizeStartSize.X
		local NewHeight =
			ResizeStartSize.Y
		if ResizeMode == "Right"
			or ResizeMode == "Corner" then
			NewWidth =
				math.max(
					MIN_WIDTH,
					ResizeStartSize.X +
						Delta.X
				)
		end
		if ResizeMode == "Bottom"
			or ResizeMode == "Corner" then
			NewHeight =
				math.max(
					MIN_HEIGHT,
					ResizeStartSize.Y +
						Delta.Y
				)
		end
		Main.Size =
			UDim2.new(
				0,
				NewWidth,
				0,
				NewHeight
			)
	end
)
UserInputService.InputEnded:Connect(
	function(Input)
		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then
			ResizeMode = nil
		end
	end
)
local function UpdateTabs()
	if CurrentTab == "Aimbot" then
		AimbotPage.Visible = true
		ESPPage.Visible = false
		SpectatePage.Visible = false
		SettingsPage.Visible = false
		AimbotTab.BackgroundColor3 =
			Color3.fromRGB(
				45,
				45,
				45
			)
		ESPTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		SpectateTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		SettingsTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
	elseif CurrentTab == "ESP" then
		AimbotPage.Visible = false
		ESPPage.Visible = true
		SpectatePage.Visible = false
		SettingsPage.Visible = false
		AimbotTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		ESPTab.BackgroundColor3 =
			Color3.fromRGB(
				45,
				45,
				45
			)
		SpectateTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		SettingsTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
	elseif CurrentTab == "Spectate" then
		AimbotPage.Visible = false
		ESPPage.Visible = false
		SpectatePage.Visible = true
		SettingsPage.Visible = false
		AimbotTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		ESPTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		SpectateTab.BackgroundColor3 =
			Color3.fromRGB(
				45,
				45,
				45
			)
		SettingsTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
	else
		AimbotPage.Visible = false
		ESPPage.Visible = false
		SpectatePage.Visible = false
		SettingsPage.Visible = true
		AimbotTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		ESPTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		SpectateTab.BackgroundColor3 =
			Color3.fromRGB(
				32,
				32,
				32
			)
		SettingsTab.BackgroundColor3 =
			Color3.fromRGB(
				45,
				45,
				45
			)
	end
end
AimbotTab.MouseButton1Click:Connect(
	function()
		CurrentTab = "Aimbot"
		UpdateTabs()
	end
)
ESPTab.MouseButton1Click:Connect(
	function()
		CurrentTab = "ESP"
		UpdateTabs()
	end
)
SpectateTab.MouseButton1Click:Connect(
	function()
		CurrentTab = "Spectate"
		UpdateTabs()
	end
)
SettingsTab.MouseButton1Click:Connect(
	function()
		CurrentTab = "Settings"
		UpdateTabs()
	end
)
local Dragging = false
local DragStart
local StartPosition
TitleBar.InputBegan:Connect(
	function(Input)
		if Input.UserInputType ~=
			Enum.UserInputType.MouseButton1 then
			return
		end
		local P = Input.Position
		local MinPos =
			MinimizeButton.AbsolutePosition
		local MinSize =
			MinimizeButton.AbsoluteSize
		local ClosePos =
			CloseButton.AbsolutePosition
		local CloseSize =
			CloseButton.AbsoluteSize
		local OnMin =
			P.X >= MinPos.X
			and P.X <=
				MinPos.X + MinSize.X
			and P.Y >= MinPos.Y
			and P.Y <=
				MinPos.Y + MinSize.Y
		local OnClose =
			P.X >= ClosePos.X
			and P.X <=
				ClosePos.X + CloseSize.X
			and P.Y >= ClosePos.Y
			and P.Y <=
				ClosePos.Y + CloseSize.Y
		if OnMin or OnClose then
			return
		end
		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position
	end
)
UserInputService.InputChanged:Connect(
	function(Input)
		if not Dragging then
			return
		end
		if Input.UserInputType ~=
			Enum.UserInputType.MouseMovement then
			return
		end
		local Delta =
			Input.Position -
			DragStart
		Main.Position =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset +
					Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset +
					Delta.Y
			)
	end
)
UserInputService.InputEnded:Connect(
	function(Input)
		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then
			Dragging = false
		end
	end
)
MinimizeButton.MouseButton1Click:Connect(
	function()
		Minimized =
			not Minimized
		if Minimized then
			Body.Visible = false
			Main.Size =
				UDim2.new(
					0,
					Main.AbsoluteSize.X,
					0,
					42
				)
			MinimizeButton.Text = "+"
		else
			Body.Visible = true
			Main.Size =
				UDim2.new(
					0,
					math.max(
						MIN_WIDTH,
						Main.AbsoluteSize.X
					),
					0,
					DEFAULT_HEIGHT
				)
			MinimizeButton.Text = "—"
		end
	end
)
CloseButton.MouseButton1Click:Connect(
	function()
		Main.Visible = false
	end
)
local function EnableUnlockedCamera()
	LocalPlayer.CameraMaxZoomDistance =
		UNLOCKED_MAX_ZOOM
	LocalPlayer.DevCameraOcclusionMode =
		Enum.DevCameraOcclusionMode.Invisicam
end
local function RestoreNormalCamera()
	LocalPlayer.CameraMaxZoomDistance =
		OriginalCameraMaxZoomDistance
	LocalPlayer.CameraMinZoomDistance =
		OriginalCameraMinZoomDistance
	LocalPlayer.DevCameraOcclusionMode =
		OriginalOcclusionMode
end
local function UpdateUnlockCamButton()
	if UnlockCamEnabled then
		UnlockCamButton.BackgroundColor3 =
			Color3.fromRGB(
				60,
				200,
				90
			)
		UnlockCamButton.Text =
			"UNLOCK CAM: ON"
	else
		UnlockCamButton.BackgroundColor3 =
			Color3.fromRGB(
				200,
				60,
				60
			)
		UnlockCamButton.Text =
			"UNLOCK CAM: OFF"
	end
end
local function ToggleUnlockCam()
	UnlockCamEnabled =
		not UnlockCamEnabled
	if UnlockCamEnabled then
		EnableUnlockedCamera()
	else
		RestoreNormalCamera()
	end
	UpdateUnlockCamButton()
end
UnlockCamButton.MouseButton1Click:Connect(
	function()
		ToggleUnlockCam()
	end
)
UpdateUnlockCamButton()
local function GetHumanoid(Player)
	local Character =
		Player.Character
	if not Character then
		return nil
	end
	return Character:FindFirstChildOfClass(
		"Humanoid"
	)
end
local function StopSpectating()
	SpectatingPlayer = nil
	local CurrentCamera =
		workspace.CurrentCamera
	if OriginalCameraSubject
		and OriginalCameraSubject.Parent then
		CurrentCamera.CameraSubject =
			OriginalCameraSubject
	else
		local Character =
			LocalPlayer.Character
		local Humanoid =
			Character
			and Character:FindFirstChildOfClass(
				"Humanoid"
			)
		if Humanoid then
			CurrentCamera.CameraSubject =
				Humanoid
		end
	end
	CurrentCamera.CameraType =
		Enum.CameraType.Custom
	UnlockCamEnabled =
		UnlockCamStateBeforeSpectate
	if UnlockCamEnabled then
		EnableUnlockedCamera()
	else
		RestoreNormalCamera()
	end
	UpdateUnlockCamButton()
end
local function StartSpectating(Player)
	if Player == LocalPlayer then
		return
	end
	local Humanoid =
		GetHumanoid(Player)
	if not Humanoid then
		return
	end
	local CurrentCamera =
		workspace.CurrentCamera
	if not SpectatingPlayer then
		OriginalCameraSubject =
			CurrentCamera.CameraSubject
		UnlockCamStateBeforeSpectate =
			UnlockCamEnabled
	end
	SpectatingPlayer =
		Player
	CurrentCamera.CameraType =
		Enum.CameraType.Custom
	CurrentCamera.CameraSubject =
		Humanoid
	UnlockCamEnabled = true
	EnableUnlockedCamera()
	UpdateUnlockCamButton()
end
local PlayerButtons = {}
local function GetTeamSortValue(Player)
	if Player.Team then
		return Player.Team.Name
	end
	return "ZZZZZZZZ"
end
local function SortPlayerButtons()
	local Data = {}
	for Player, Info in pairs(
		PlayerButtons
	) do
		if Player.Parent ==
			Players
			and Info.Button
			and Info.Button.Parent then
			table.insert(
				Data,
				{
					Player = Player,
					Info = Info
				}
			)
		end
	end
	table.sort(
		Data,
		function(A, B)
			local TeamA =
				GetTeamSortValue(
					A.Player
				)
			local TeamB =
				GetTeamSortValue(
					B.Player
				)
			if TeamA ~= TeamB then
				return TeamA:lower()
					< TeamB:lower()
			end
			return A.Player.DisplayName:lower()
				< B.Player.DisplayName:lower()
		end
	)
	for Index, Entry in ipairs(
		Data
	) do
		Entry.Info.Button.LayoutOrder =
			Index
	end
end
local function UpdatePlayerButton(Player)
	local Data =
		PlayerButtons[Player]
	if not Data
		or not Data.Button.Parent then
		return
	end
	Data.NameLabel.Text =
		Player.DisplayName
	if Player.Team then
		Data.NameLabel.TextColor3 =
			Player.TeamColor.Color
	else
		Data.NameLabel.TextColor3 =
			Color3.fromRGB(
				255,
				255,
				255
			)
	end
	local LocalCharacter =
		LocalPlayer.Character
	local LocalRoot =
		LocalCharacter
		and LocalCharacter:FindFirstChild(
			"HumanoidRootPart"
		)
	local TargetCharacter =
		Player.Character
	local TargetRoot =
		TargetCharacter
		and TargetCharacter:FindFirstChild(
			"HumanoidRootPart"
		)
	if LocalRoot
		and TargetRoot then
		local Distance =
			(
				TargetRoot.Position
				- LocalRoot.Position
			).Magnitude
		Data.DistanceLabel.Text =
			string.format(
				"%d studs",
				math.floor(
					Distance
				)
			)
	else
		Data.DistanceLabel.Text =
			"-- studs"
	end
end
local function CreatePlayerButton(Player)
	if Player == LocalPlayer
		or PlayerButtons[Player] then
		return
	end
	local Button =
		Instance.new("TextButton")
	Button.Size =
		UDim2.new(
			1,
			-4,
			0,
			38
		)
	Button.BackgroundColor3 =
		Color3.fromRGB(
			40,
			40,
			40
		)
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.Parent =
		PlayerList
	local Corner =
		Instance.new("UICorner")
	Corner.CornerRadius =
		UDim.new(
			0,
			6
		)
	Corner.Parent =
		Button
	local NameLabel =
		Instance.new("TextLabel")
	NameLabel.Size =
		UDim2.new(
			1,
			-95,
			1,
			0
		)
	NameLabel.Position =
		UDim2.new(
			0,
			10,
			0,
			0
		)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text =
		Player.DisplayName
	NameLabel.TextSize = 14
	NameLabel.Font = Enum.Font.Gotham
	NameLabel.TextXAlignment =
		Enum.TextXAlignment.Left
	NameLabel.Parent =
		Button
	local DistanceLabel =
		Instance.new("TextLabel")
	DistanceLabel.Size =
		UDim2.new(
			0,
			85,
			1,
			0
		)
	DistanceLabel.Position =
		UDim2.new(
			1,
			-90,
			0,
			0
		)
	DistanceLabel.BackgroundTransparency = 1
	DistanceLabel.Text =
		"-- studs"
	DistanceLabel.TextColor3 =
		Color3.fromRGB(
			180,
			180,
			180
		)
	DistanceLabel.TextSize = 11
	DistanceLabel.Font = Enum.Font.Gotham
	DistanceLabel.TextXAlignment =
		Enum.TextXAlignment.Right
	DistanceLabel.Parent =
		Button
	Button.MouseEnter:Connect(
		function()
			Tooltip.Text =
				"@" .. Player.Name
			Tooltip.Visible = true
			local MouseLocation =
				UserInputService:GetMouseLocation()
			Tooltip.Position =
				UDim2.new(
					0,
					MouseLocation.X + 12,
					0,
					MouseLocation.Y + 12
				)
		end
	)
	Button.MouseMoved:Connect(
		function()
			if Tooltip.Visible then
				local MouseLocation =
					UserInputService:GetMouseLocation()
				Tooltip.Position =
					UDim2.new(
						0,
						MouseLocation.X + 12,
						0,
						MouseLocation.Y + 12
					)
			end
		end
	)
	Button.MouseLeave:Connect(
		function()
			Tooltip.Visible = false
		end
	)
	Button.MouseButton1Click:Connect(
		function()
			StartSpectating(
				Player
			)
		end
	)
	PlayerButtons[Player] = {
		Button = Button,
		NameLabel = NameLabel,
		DistanceLabel = DistanceLabel
	}
	UpdatePlayerButton(
		Player
	)
	SortPlayerButtons()
	Player:GetPropertyChangedSignal(
		"Team"
	):Connect(
		function()
			UpdatePlayerButton(
				Player
			)
			SortPlayerButtons()
		end
	)
	Player:GetPropertyChangedSignal(
		"TeamColor"
	):Connect(
		function()
			UpdatePlayerButton(
				Player
			)
			SortPlayerButtons()
		end
	)
	Player:GetPropertyChangedSignal(
		"DisplayName"
	):Connect(
		function()
			UpdatePlayerButton(
				Player
			)
			SortPlayerButtons()
		end
	)
end
local function RemovePlayerButton(Player)
	local Data =
		PlayerButtons[Player]
	if Data and Data.Button then
		Data.Button:Destroy()
	end
	PlayerButtons[Player] = nil
	if SpectatingPlayer ==
		Player then
		StopSpectating()
	end
	if AimbotTarget ==
		Player then
		AimbotTarget = nil
	end
	SortPlayerButtons()
end
local function HandleCharacterAdded(
	Player,
	Character
)
	task.spawn(
		function()
			local Humanoid =
				Character:WaitForChild(
					"Humanoid",
					10
				)
			Character:WaitForChild(
				"HumanoidRootPart",
				10
			)
			UpdatePlayerButton(
				Player
			)
			if SpectatingPlayer ==
				Player
				and Humanoid then
				local CurrentCamera =
					workspace.CurrentCamera
				CurrentCamera.CameraType =
					Enum.CameraType.Custom
				CurrentCamera.CameraSubject =
					Humanoid
				if UnlockCamEnabled then
					EnableUnlockedCamera()
				end
			end
		end
	)
end
