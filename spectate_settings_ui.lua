local SpectatePage =
	Instance.new("Frame")
SpectatePage.Size =
	UDim2.new(
		1,
		-20,
		1,
		-20
	)
SpectatePage.Position =
	UDim2.new(
		0,
		10,
		0,
		10
	)
SpectatePage.BackgroundTransparency = 1
SpectatePage.ClipsDescendants = true
SpectatePage.Visible = false
SpectatePage.Parent =
	ContentArea
local SpectateHeader =
	Instance.new("TextLabel")
SpectateHeader.Size =
	UDim2.new(
		1,
		0,
		0,
		30
	)
SpectateHeader.BackgroundTransparency = 1
SpectateHeader.Text = "SPECTATE"
SpectateHeader.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)
SpectateHeader.TextSize = 18
SpectateHeader.Font = Enum.Font.GothamBold
SpectateHeader.TextXAlignment =
	Enum.TextXAlignment.Left
SpectateHeader.Parent =
	SpectatePage
local SpectateSubheader =
	Instance.new("TextLabel")
SpectateSubheader.Size =
	UDim2.new(
		1,
		0,
		0,
		20
	)
SpectateSubheader.Position =
	UDim2.new(
		0,
		0,
		0,
		28
	)
SpectateSubheader.BackgroundTransparency = 1
SpectateSubheader.Text =
	"Select a player to spectate"
SpectateSubheader.TextColor3 =
	Color3.fromRGB(
		130,
		130,
		130
	)
SpectateSubheader.TextSize = 11
SpectateSubheader.Font = Enum.Font.Gotham
SpectateSubheader.TextXAlignment =
	Enum.TextXAlignment.Left
SpectateSubheader.Parent =
	SpectatePage
local PlayerList =
	Instance.new("ScrollingFrame")
PlayerList.Size =
	UDim2.new(
		1,
		0,
		1,
		-115
	)
PlayerList.Position =
	UDim2.new(
		0,
		0,
		0,
		58
	)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 5
PlayerList.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		0
	)
PlayerList.AutomaticCanvasSize =
	Enum.AutomaticSize.Y
PlayerList.Parent =
	SpectatePage
local ListLayout =
	Instance.new("UIListLayout")
ListLayout.Padding =
	UDim.new(
		0,
		6
	)
ListLayout.SortOrder =
	Enum.SortOrder.LayoutOrder
ListLayout.Parent =
	PlayerList
local ListPadding =
	Instance.new("UIPadding")
ListPadding.PaddingTop =
	UDim.new(
		0,
		2
	)
ListPadding.PaddingBottom =
	UDim.new(
		0,
		2
	)
ListPadding.Parent =
	PlayerList
local StopButton =
	Instance.new("TextButton")
StopButton.Size =
	UDim2.new(
		1,
		0,
		0,
		40
	)
StopButton.Position =
	UDim2.new(
		0,
		0,
		1,
		-40
	)
StopButton.BackgroundColor3 =
	Color3.fromRGB(
		65,
		35,
		35
	)
StopButton.BorderSizePixel = 0
StopButton.Text = "STOP SPECTATING"
StopButton.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)
StopButton.TextSize = 13
StopButton.Font = Enum.Font.GothamBold
StopButton.Parent =
	SpectatePage
local StopCorner =
	Instance.new("UICorner")
StopCorner.CornerRadius =
	UDim.new(
		0,
		6
	)
StopCorner.Parent =
	StopButton
local SettingsPage =
	Instance.new("ScrollingFrame")
SettingsPage.Size =
	UDim2.new(
		1,
		-20,
		1,
		-20
	)
SettingsPage.Position =
	UDim2.new(
		0,
		10,
		0,
		10
	)
SettingsPage.BackgroundTransparency = 1
SettingsPage.BorderSizePixel = 0
SettingsPage.ScrollBarThickness = 6
SettingsPage.ScrollBarImageTransparency = 0.15
SettingsPage.ScrollingDirection =
	Enum.ScrollingDirection.Y
SettingsPage.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		560
	)
SettingsPage.ClipsDescendants = true
SettingsPage.Visible = false
SettingsPage.Parent =
	ContentArea
local SettingsHeader =
	Instance.new("TextLabel")
SettingsHeader.Size =
	UDim2.new(
		1,
		-10,
		0,
		30
	)
SettingsHeader.BackgroundTransparency = 1
SettingsHeader.Text = "SETTINGS"
SettingsHeader.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)
SettingsHeader.TextSize = 18
SettingsHeader.Font = Enum.Font.GothamBold
SettingsHeader.TextXAlignment =
	Enum.TextXAlignment.Left
SettingsHeader.Parent =
	SettingsPage
local SettingsSubheader =
	Instance.new("TextLabel")
SettingsSubheader.Size =
	UDim2.new(
		1,
		-10,
		0,
		20
	)
SettingsSubheader.Position =
	UDim2.new(
		0,
		0,
		0,
		28
	)
SettingsSubheader.BackgroundTransparency = 1
SettingsSubheader.Text =
	"Configure your script keybinds"
SettingsSubheader.TextColor3 =
	Color3.fromRGB(
		130,
		130,
		130
	)
SettingsSubheader.TextSize = 11
SettingsSubheader.Font = Enum.Font.Gotham
SettingsSubheader.TextXAlignment =
	Enum.TextXAlignment.Left
SettingsSubheader.Parent =
	SettingsPage
local function CreateKeybindSection(
	Parent,
	Name,
	Description,
	Y,
	DefaultText
)
	local Section =
		Instance.new("Frame")
	Section.Size =
		UDim2.new(
			1,
			-10,
			0,
			85
		)
	Section.Position =
		UDim2.new(
			0,
			0,
			0,
			Y
		)
	Section.BackgroundColor3 =
		Color3.fromRGB(
			32,
			32,
			32
		)
	Section.BorderSizePixel = 0
	Section.Parent =
		Parent
	local Corner =
		Instance.new("UICorner")
	Corner.CornerRadius =
		UDim.new(
			0,
			7
		)
	Corner.Parent =
		Section
	local Label =
		Instance.new("TextLabel")
	Label.Size =
		UDim2.new(
			1,
			-210,
			0,
			24
		)
	Label.Position =
		UDim2.new(
			0,
			12,
			0,
			10
		)
	Label.BackgroundTransparency = 1
	Label.Text = Name
	Label.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)
	Label.TextSize = 14
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment =
		Enum.TextXAlignment.Left
	Label.Parent =
		Section
	local Desc =
		Instance.new("TextLabel")
	Desc.Size =
		UDim2.new(
			1,
			-210,
			0,
			20
		)
	Desc.Position =
		UDim2.new(
			0,
			12,
			0,
			35
		)
	Desc.BackgroundTransparency = 1
	Desc.Text = Description
	Desc.TextColor3 =
		Color3.fromRGB(
			130,
			130,
			130
		)
	Desc.TextSize = 10
	Desc.Font = Enum.Font.Gotham
	Desc.TextXAlignment =
		Enum.TextXAlignment.Left
	Desc.Parent =
		Section
	local Unbind =
		Instance.new("TextButton")
	Unbind.Size =
		UDim2.new(0, 70, 0, 38)
	Unbind.Position =
		UDim2.new(1, -190, 0, 23)
	Unbind.BackgroundColor3 =
		Color3.fromRGB(85, 40, 40)
	Unbind.BorderSizePixel = 0
	Unbind.Text = "UNBIND"
	Unbind.TextColor3 =
		Color3.fromRGB(255, 120, 120)
	Unbind.TextSize = 10
	Unbind.Font = Enum.Font.GothamBold
	Unbind.Parent = Section
	local UnbindCorner =
		Instance.new("UICorner")
	UnbindCorner.CornerRadius =
		UDim.new(0, 6)
	UnbindCorner.Parent = Unbind
	local Keybind =
		Instance.new("TextButton")
	Keybind.Size =
		UDim2.new(
			0,
			100,
			0,
			38
		)
	Keybind.Position =
		UDim2.new(
			1,
			-112,
			0,
			23
		)
	Keybind.BackgroundColor3 =
		Color3.fromRGB(
			45,
			45,
			45
		)
	Keybind.BorderSizePixel = 0
	Keybind.Text = DefaultText
	Keybind.TextColor3 =
		Color3.fromRGB(
			100,
			255,
			100
		)
	Keybind.TextSize = 12
	Keybind.Font = Enum.Font.Gotham
	Keybind.Parent =
		Section
	local KeyCorner =
		Instance.new("UICorner")
	KeyCorner.CornerRadius =
		UDim.new(
			0,
			6
		)
	KeyCorner.Parent =
		Keybind
	return Keybind, Unbind
end
local TeleportKeybind, TeleportUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Teleport",
		"Teleport to your mouse position",
		65,
		"UNBOUND"
	)
local ReopenKeybind, ReopenUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Reopen",
		"Key used to reopen Fun Scripts",
		160,
		"F9"
	)
local StopSpectatingKeybind, StopSpectatingUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Stop Spectating",
		"Quickly return the camera to yourself",
		255,
		"LeftAlt"
	)
local UnlockCamKeybind, UnlockCamUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Free Cam",
		"Toggle unlimited zoom and wall-through camera",
		350,
		"Z"
	)
local AimbotKeybind, AimbotUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Aimbot",
		"Toggle aimbot on or off",
		445,
		"UNBOUND"
	)
TeleportUnbind.MouseButton1Click:Connect(function()
	BoundTeleportKey = nil
	WaitingForTeleportKey = false
	TeleportKeybind.Text = "UNBOUND"
	TeleportKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
end)
ReopenUnbind.MouseButton1Click:Connect(function()
	BoundReopenKey = nil
	WaitingForReopenKey = false
	ReopenKeybind.Text = "UNBOUND"
	ReopenKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
end)
StopSpectatingUnbind.MouseButton1Click:Connect(function()
	BoundStopSpectatingKey = nil
	WaitingForStopSpectatingKey = false
	StopSpectatingKeybind.Text = "UNBOUND"
	StopSpectatingKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
end)
UnlockCamUnbind.MouseButton1Click:Connect(function()
	BoundUnlockCamKey = nil
	WaitingForUnlockCamKey = false
	UnlockCamKeybind.Text = "UNBOUND"
	UnlockCamKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
end)
AimbotUnbind.MouseButton1Click:Connect(function()
	BoundAimbotKey = nil
	WaitingForAimbotKey = false
	AimbotKeybind.Text = "UNBOUND"
	AimbotKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
end)
local Tooltip =
	Instance.new("TextLabel")
Tooltip.Size =
	UDim2.new(
		0,
		180,
		0,
		28
	)
Tooltip.BackgroundColor3 =
	Color3.fromRGB(
		15,
		15,
		15
	)
Tooltip.BorderSizePixel = 0
Tooltip.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)
Tooltip.TextSize = 12
Tooltip.Font = Enum.Font.Gotham
Tooltip.Visible = false
Tooltip.ZIndex = 100
Tooltip.Parent =
	ScreenGui
local TooltipCorner =
	Instance.new("UICorner")
TooltipCorner.CornerRadius =
	UDim.new(
		0,
		5
	)
TooltipCorner.Parent =
	Tooltip
