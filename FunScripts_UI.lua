--==================================================
-- FUN SCRIPTS UI / CORE
-- This script is executed independently from logic.lua.
--==================================================

local FS = getgenv().FunScripts or {}
getgenv().FunScripts = FS

--==================================================
-- FUN SCRIPTS
-- ESP + Aimbot + Spectate + Settings
-- LocalScript
--==================================================

FS.Players = game:GetService("Players")
local Teams = game:GetService("Teams")
FS.UserInputService = game:GetService("UserInputService")
FS.RunService = game:GetService("RunService")

FS.LocalPlayer = FS.Players.LocalPlayer
local PlayerGui = FS.LocalPlayer:WaitForChild("PlayerGui")
FS.Mouse = FS.LocalPlayer:GetMouse()
FS.Camera = workspace.CurrentCamera

--==================================================
-- KEYBINDS
--==================================================

FS.BoundTeleportKey = nil
FS.WaitingForTeleportKey = false

FS.BoundReopenKey = Enum.KeyCode.F9
FS.WaitingForReopenKey = false

FS.BoundStopSpectatingKey = Enum.KeyCode.LeftAlt
FS.WaitingForStopSpectatingKey = false

FS.BoundUnlockCamKey = Enum.KeyCode.Z
FS.WaitingForUnlockCamKey = false

FS.BoundAimbotKey = nil
FS.WaitingForAimbotKey = false

--==================================================
-- MENU
--==================================================

local Minimized = false
local CurrentTab = "Aimbot"

--==================================================
-- ESP SETTINGS
--==================================================

FS.ESPSettings = {
	Enabled = true,
	Names = true,
	Distance = true,
	Health = true,
	Lines = false,

	Color = Color3.fromRGB(255, 48, 51),
	TextColor = Color3.fromRGB(255, 255, 255),
	TargetTeams = {},
	UseTeamColor = false,
}

FS.HealthStyle = "Bar"

FS.ESPObjects = {}

--==================================================
-- AIMBOT SETTINGS
--==================================================

FS.AimbotSettings = {
	Enabled = true,
	Radius = 150,
	TargetMode = "Head",
	ShowFOV = true,
	LineOfSight = true,
	TargetTeam = "All",
	TargetTeams = {},

	FOVOpacity = 0.85,
	FOVColor = Color3.fromRGB(255, 255, 255),

	AimKey = Enum.UserInputType.MouseButton2
}

FS.AimbotHolding = false
FS.AimbotTarget = nil
FS.AlternateTarget = "Head"

--==================================================
-- CAMERA
--==================================================

local UnlockCamEnabled = false
FS.SpectatingPlayer = nil
local OriginalCameraSubject = nil
local UnlockCamStateBeforeSpectate = false

local OriginalCameraMaxZoomDistance =
	FS.LocalPlayer.CameraMaxZoomDistance

local OriginalCameraMinZoomDistance =
	FS.LocalPlayer.CameraMinZoomDistance

local OriginalOcclusionMode =
	FS.LocalPlayer.DevCameraOcclusionMode

local UNLOCKED_MAX_ZOOM = 1000000

--==================================================
-- WINDOW
--==================================================

local MIN_WIDTH = 500
local MIN_HEIGHT = 360

local DEFAULT_WIDTH = 620
local DEFAULT_HEIGHT = 460

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FunScripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "ESPOverlay"
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true
ESPGui.DisplayOrder = 5
ESPGui.Parent = PlayerGui

--==================================================
-- MAIN WINDOW
--==================================================

FS.Main = Instance.new("Frame")
FS.Main.Size = UDim2.new(0, DEFAULT_WIDTH, 0, DEFAULT_HEIGHT)
FS.Main.Position = UDim2.new(0.5, -310, 0.5, -230)
FS.Main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
FS.Main.BorderSizePixel = 0
FS.Main.Active = true
FS.Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = FS.Main

--==================================================
-- TITLE BAR
--==================================================

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Parent = FS.Main

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FUN SCRIPTS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -62, 0, 7)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -30, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(70, 35, 35)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

--==================================================
-- BODY
--==================================================

local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, 0, 1, -42)
Body.Position = UDim2.new(0, 0, 0, 42)
Body.BackgroundTransparency = 1
Body.ClipsDescendants = true
Body.Parent = FS.Main

--==================================================
-- LEFT TAB BAR
--==================================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 160, 1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
TabBar.BorderSizePixel = 0
TabBar.ClipsDescendants = true
TabBar.Parent = Body

local TabTitle = Instance.new("TextLabel")
TabTitle.Size = UDim2.new(1, -20, 0, 30)
TabTitle.Position = UDim2.new(0, 10, 0, 10)
TabTitle.BackgroundTransparency = 1
TabTitle.Text = "MENU"
TabTitle.TextColor3 = Color3.fromRGB(110, 110, 110)
TabTitle.TextSize = 11
TabTitle.Font = Enum.Font.GothamBold
TabTitle.TextXAlignment = Enum.TextXAlignment.Left
TabTitle.Parent = TabBar

--==================================================
-- AIMBOT TAB
--==================================================

local AimbotTab = Instance.new("TextButton")
AimbotTab.Size = UDim2.new(1, -20, 0, 40)
AimbotTab.Position = UDim2.new(0, 10, 0, 50)
AimbotTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
AimbotTab.BorderSizePixel = 0
AimbotTab.Text = "AIMBOT"
AimbotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotTab.TextSize = 13
AimbotTab.Font = Enum.Font.GothamBold
AimbotTab.TextXAlignment = Enum.TextXAlignment.Left
AimbotTab.Parent = TabBar

local AimbotPad = Instance.new("UIPadding")
AimbotPad.PaddingLeft = UDim.new(0, 12)
AimbotPad.PaddingRight = UDim.new(0, 68)
AimbotPad.Parent = AimbotTab

local AimbotTabCorner = Instance.new("UICorner")
AimbotTabCorner.CornerRadius = UDim.new(0, 6)
AimbotTabCorner.Parent = AimbotTab

--==================================================
-- AIMBOT MASTER TOGGLE
--==================================================

local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(0, 36, 0, 20)
AimbotToggle.Position = UDim2.new(1, -28, 0, 10)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
AimbotToggle.BorderSizePixel = 0
AimbotToggle.Text = ""
AimbotToggle.AutoButtonColor = false
AimbotToggle.ZIndex = 5
AimbotToggle.Parent = AimbotTab

local AimbotToggleCorner = Instance.new("UICorner")
AimbotToggleCorner.CornerRadius = UDim.new(1, 0)
AimbotToggleCorner.Parent = AimbotToggle

local AimbotToggleKnob = Instance.new("Frame")
AimbotToggleKnob.Size = UDim2.new(0, 16, 0, 16)
AimbotToggleKnob.Position = UDim2.new(1, -18, 0, 2)
AimbotToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggleKnob.BorderSizePixel = 0
AimbotToggleKnob.ZIndex = 6
AimbotToggleKnob.Parent = AimbotToggle

local AimbotKnobCorner = Instance.new("UICorner")
AimbotKnobCorner.CornerRadius = UDim.new(1, 0)
AimbotKnobCorner.Parent = AimbotToggleKnob

function FS.UpdateAimbotTabToggle()

	if FS.AimbotSettings.Enabled then

		AimbotToggle.BackgroundColor3 =
			Color3.fromRGB(
				60,
				200,
				90
			)

		AimbotToggleKnob.Position =
			UDim2.new(
				1,
				-18,
				0,
				2
			)

	else

		AimbotToggle.BackgroundColor3 =
			Color3.fromRGB(
				200,
				60,
				60
			)

		AimbotToggleKnob.Position =
			UDim2.new(
				0,
				2,
				0,
				2
			)
	end
end

AimbotToggle.MouseButton1Click:Connect(
	function()

		FS.AimbotSettings.Enabled =
			not FS.AimbotSettings.Enabled

		if not FS.AimbotSettings.Enabled then
			FS.AimbotHolding = false
			FS.AimbotTarget = nil
		end

		FS.UpdateAimbotTabToggle()
	end
)

FS.UpdateAimbotTabToggle()

--==================================================
-- ESP TAB
--==================================================

local ESPTab = Instance.new("TextButton")
ESPTab.Size = UDim2.new(1, -20, 0, 40)
ESPTab.Position = UDim2.new(0, 10, 0, 96)
ESPTab.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
ESPTab.BorderSizePixel = 0
ESPTab.Text = "ESP"
ESPTab.TextColor3 = Color3.fromRGB(170, 170, 170)
ESPTab.TextSize = 13
ESPTab.Font = Enum.Font.GothamBold
ESPTab.TextXAlignment = Enum.TextXAlignment.Left
ESPTab.Parent = TabBar

local ESPPad = Instance.new("UIPadding")
ESPPad.PaddingLeft = UDim.new(0, 12)
ESPPad.PaddingRight = UDim.new(0, 48)
ESPPad.Parent = ESPTab

local ESPTabCorner = Instance.new("UICorner")
ESPTabCorner.CornerRadius = UDim.new(0, 6)
ESPTabCorner.Parent = ESPTab

--==================================================
-- ESP MASTER TOGGLE
--==================================================

local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(0, 36, 0, 20)
ESPToggle.Position = UDim2.new(1, -46, 0, 10)
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
ESPToggle.BorderSizePixel = 0
ESPToggle.Text = ""
ESPToggle.AutoButtonColor = false
ESPToggle.ZIndex = 5
ESPToggle.Parent = ESPTab

local ESPToggleCorner = Instance.new("UICorner")
ESPToggleCorner.CornerRadius = UDim.new(1, 0)
ESPToggleCorner.Parent = ESPToggle

local ESPToggleKnob = Instance.new("Frame")
ESPToggleKnob.Size = UDim2.new(0, 16, 0, 16)
ESPToggleKnob.Position = UDim2.new(1, -18, 0, 2)
ESPToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ESPToggleKnob.BorderSizePixel = 0
ESPToggleKnob.ZIndex = 6
ESPToggleKnob.Parent = ESPToggle

local ESPKnobCorner = Instance.new("UICorner")
ESPKnobCorner.CornerRadius = UDim.new(1, 0)
ESPKnobCorner.Parent = ESPToggleKnob

local function UpdateESPTabToggle()

	if FS.ESPSettings.Enabled then

		ESPToggle.BackgroundColor3 =
			Color3.fromRGB(
				60,
				200,
				90
			)

		ESPToggleKnob.Position =
			UDim2.new(
				1,
				-18,
				0,
				2
			)

	else

		ESPToggle.BackgroundColor3 =
			Color3.fromRGB(
				200,
				60,
				60
			)

		ESPToggleKnob.Position =
			UDim2.new(
				0,
				2,
				0,
				2
			)
	end
end

--==================================================
-- SPECTATE TAB
--==================================================

local SpectateTab = Instance.new("TextButton")
SpectateTab.Size = UDim2.new(1, -20, 0, 40)
SpectateTab.Position = UDim2.new(0, 10, 0, 142)
SpectateTab.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
SpectateTab.BorderSizePixel = 0
SpectateTab.Text = "SPECTATE"
SpectateTab.TextColor3 = Color3.fromRGB(170, 170, 170)
SpectateTab.TextSize = 13
SpectateTab.Font = Enum.Font.GothamBold
SpectateTab.TextXAlignment = Enum.TextXAlignment.Left
SpectateTab.Parent = TabBar

local SpectatePad = Instance.new("UIPadding")
SpectatePad.PaddingLeft = UDim.new(0, 12)
SpectatePad.Parent = SpectateTab

local SpectateCorner = Instance.new("UICorner")
SpectateCorner.CornerRadius = UDim.new(0, 6)
SpectateCorner.Parent = SpectateTab

--==================================================
-- SETTINGS TAB
--==================================================

local SettingsTab = Instance.new("TextButton")
SettingsTab.Size = UDim2.new(1, -20, 0, 40)
SettingsTab.Position = UDim2.new(0, 10, 0, 188)
SettingsTab.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
SettingsTab.BorderSizePixel = 0
SettingsTab.Text = "SETTINGS"
SettingsTab.TextColor3 = Color3.fromRGB(170, 170, 170)
SettingsTab.TextSize = 13
SettingsTab.Font = Enum.Font.GothamBold
SettingsTab.TextXAlignment = Enum.TextXAlignment.Left
SettingsTab.Parent = TabBar

local SettingsPad = Instance.new("UIPadding")
SettingsPad.PaddingLeft = UDim.new(0, 12)
SettingsPad.Parent = SettingsTab

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 6)
SettingsCorner.Parent = SettingsTab

--==================================================
-- FREE CAM BUTTON
--==================================================

local UnlockCamButton = Instance.new("TextButton")
UnlockCamButton.Size = UDim2.new(0, 140, 0, 36)
UnlockCamButton.AnchorPoint = Vector2.new(0, 1)
UnlockCamButton.Position = UDim2.new(0, 10, 1, -10)
UnlockCamButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
UnlockCamButton.BorderSizePixel = 0
UnlockCamButton.Text = "UNLOCK CAM: OFF"
UnlockCamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockCamButton.TextSize = 11
UnlockCamButton.Font = Enum.Font.GothamBold
UnlockCamButton.Parent = Body

local UnlockCorner = Instance.new("UICorner")
UnlockCorner.CornerRadius = UDim.new(0, 6)
UnlockCorner.Parent = UnlockCamButton

--==================================================
-- CONTENT AREA
--==================================================

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -160, 1, 0)
ContentArea.Position = UDim2.new(0, 160, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent = Body

--==================================================
-- AIMBOT FOV CIRCLE
--==================================================

FS.AimbotCircle = Instance.new("Frame")
FS.AimbotCircle.Name = "AimbotFOV"
FS.AimbotCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FS.AimbotCircle.BackgroundTransparency = 1
FS.AimbotCircle.BorderSizePixel = 0
FS.AimbotCircle.ZIndex = 20
FS.AimbotCircle.Parent = ESPGui

local AimbotCircleCorner = Instance.new("UICorner")
AimbotCircleCorner.CornerRadius = UDim.new(1, 0)
AimbotCircleCorner.Parent = FS.AimbotCircle

FS.AimbotCircleStroke = Instance.new("UIStroke")
FS.AimbotCircleStroke.Thickness = 1.5
FS.AimbotCircleStroke.Transparency =
	1 - FS.AimbotSettings.FOVOpacity
FS.AimbotCircleStroke.Color =
	FS.AimbotSettings.FOVColor
FS.AimbotCircleStroke.Parent = FS.AimbotCircle

--==================================================
-- AIMBOT PAGE
--==================================================

local AimbotPage = Instance.new("ScrollingFrame")
AimbotPage.Size = UDim2.new(1, -20, 1, -20)
AimbotPage.Position = UDim2.new(0, 10, 0, 10)
AimbotPage.BackgroundTransparency = 1
AimbotPage.BorderSizePixel = 0
AimbotPage.ScrollBarThickness = 6
AimbotPage.ScrollBarImageTransparency = 0.15
AimbotPage.ScrollingDirection = Enum.ScrollingDirection.Y
AimbotPage.CanvasSize = UDim2.new(0, 0, 0, 670)
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
RadiusValue.Text = tostring(FS.AimbotSettings.Radius)
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
		Value = FS.AimbotSettings.Radius
	end

	Value = math.clamp(
		math.floor(Value),
		25,
		1000
	)

	FS.AimbotSettings.Radius = Value
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
			FS.AimbotSettings.Radius - 25
		)
	end
)

RadiusPlus.MouseButton1Click:Connect(
	function()

		SetAimbotRadius(
			FS.AimbotSettings.Radius + 25
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
			FS.AimbotSettings.TargetMode
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

		FS.AimbotSettings.TargetMode =
			TargetModes[TargetModeIndex]

		UpdateTargetModeButton()
	end
)

UpdateTargetModeButton()

--==================================================
-- AIMBOT TARGET TEAMS
--==================================================

local TargetTeamLabel = Instance.new("TextLabel")
TargetTeamLabel.Size = UDim2.new(1, -10, 0, 20)
TargetTeamLabel.Position = UDim2.new(0, 0, 0, 195)
TargetTeamLabel.BackgroundTransparency = 1
TargetTeamLabel.Text = "TARGET TEAMS"
TargetTeamLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
TargetTeamLabel.TextSize = 11
TargetTeamLabel.Font = Enum.Font.GothamBold
TargetTeamLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetTeamLabel.Parent = AimbotPage

local AimbotTeamGrid = Instance.new("ScrollingFrame")
AimbotTeamGrid.Size = UDim2.new(1, -10, 0, 128)
AimbotTeamGrid.Position = UDim2.new(0, 0, 0, 220)
AimbotTeamGrid.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
AimbotTeamGrid.BorderSizePixel = 0
AimbotTeamGrid.ScrollBarThickness = 5
AimbotTeamGrid.ScrollingDirection = Enum.ScrollingDirection.Y
AimbotTeamGrid.CanvasSize = UDim2.new(0, 0, 0, 0)
AimbotTeamGrid.Parent = AimbotPage

local AimbotTeamGridCorner = Instance.new("UICorner")
AimbotTeamGridCorner.CornerRadius = UDim.new(0, 6)
AimbotTeamGridCorner.Parent = AimbotTeamGrid

local AimbotTeamGridPadding = Instance.new("UIPadding")
AimbotTeamGridPadding.PaddingTop = UDim.new(0, 6)
AimbotTeamGridPadding.PaddingBottom = UDim.new(0, 6)
AimbotTeamGridPadding.PaddingLeft = UDim.new(0, 6)
AimbotTeamGridPadding.PaddingRight = UDim.new(0, 6)
AimbotTeamGridPadding.Parent = AimbotTeamGrid

local AimbotTeamGridLayout = Instance.new("UIGridLayout")
AimbotTeamGridLayout.CellSize = UDim2.new(0.333333, -8, 0, 34)
AimbotTeamGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
AimbotTeamGridLayout.FillDirection = Enum.FillDirection.Horizontal
AimbotTeamGridLayout.FillDirectionMaxCells = 3
AimbotTeamGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
AimbotTeamGridLayout.Parent = AimbotTeamGrid

FS.AimbotSettings.TargetTeams = FS.AimbotSettings.TargetTeams or {}

local function GetTeamNamesForSelector()
	local Names = {}
	local Seen = {}

	for _, Team in ipairs(Teams:GetChildren()) do
		if Team:IsA("Team") and not Seen[Team.Name] then
			Seen[Team.Name] = true
			table.insert(Names, Team.Name)
		end
	end

	for _, Player in ipairs(FS.Players:GetPlayers()) do
		if Player.Team and not Seen[Player.Team.Name] then
			Seen[Player.Team.Name] = true
			table.insert(Names, Player.Team.Name)
		end
	end

	table.sort(Names, function(A, B)
		return string.lower(A) < string.lower(B)
	end)

	return Names
end

local function SetAimbotAllSelected(Value)
	FS.AimbotSettings.TargetTeams = {}
	if Value then
		for _, Name in ipairs(GetTeamNamesForSelector()) do
			FS.AimbotSettings.TargetTeams[Name] = true
		end
	end
	FS.AimbotSettings.TargetTeam = Value and "All" or "None"
end

local function IsAimbotTeamSelected(Name)
	return FS.AimbotSettings.TargetTeams[Name] == true
end

local function UpdateAimbotTeamGrid()
	for _, Child in ipairs(AimbotTeamGrid:GetChildren()) do
		if Child:IsA("TextButton") then
			Child:Destroy()
		end
	end

	local Names = GetTeamNamesForSelector()
	local AllSelected = #Names > 0

	for _, Name in ipairs(Names) do
		if not IsAimbotTeamSelected(Name) then
			AllSelected = false
			break
		end
	end

	local AllButton = Instance.new("TextButton")
	AllButton.BackgroundColor3 = AllSelected and Color3.fromRGB(60, 200, 90) or Color3.fromRGB(45, 45, 45)
	AllButton.BorderSizePixel = 0
	AllButton.Text = "ALL"
	AllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	AllButton.TextSize = 11
	AllButton.Font = Enum.Font.GothamBold
	AllButton.AutoButtonColor = false
	AllButton.Parent = AimbotTeamGrid

	local AllCorner = Instance.new("UICorner")
	AllCorner.CornerRadius = UDim.new(0, 5)
	AllCorner.Parent = AllButton

	AllButton.MouseButton1Click:Connect(function()
		SetAimbotAllSelected(not AllSelected)
		FS.AimbotTarget = nil
		UpdateAimbotTeamGrid()
	end)

	for _, Name in ipairs(Names) do
		local Selected = IsAimbotTeamSelected(Name)
		local Button = Instance.new("TextButton")
		Button.BackgroundColor3 = Selected and Color3.fromRGB(60, 200, 90) or Color3.fromRGB(45, 45, 45)
		Button.BorderSizePixel = 0
		Button.Text = string.upper(Name)
		Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		Button.TextSize = 10
		Button.Font = Enum.Font.GothamBold
		Button.TextTruncate = Enum.TextTruncate.AtEnd
		Button.AutoButtonColor = false
		Button.Parent = AimbotTeamGrid

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 5)
		Corner.Parent = Button

		Button.MouseButton1Click:Connect(function()
			FS.AimbotSettings.TargetTeams[Name] = not IsAimbotTeamSelected(Name)
			FS.AimbotSettings.TargetTeam = "Multiple"
			FS.AimbotTarget = nil
			UpdateAimbotTeamGrid()
		end)
	end

	AimbotTeamGrid.CanvasSize = UDim2.new(0, 0, 0, AimbotTeamGridLayout.AbsoluteContentSize.Y + 12)
end

if next(FS.AimbotSettings.TargetTeams) == nil then
	SetAimbotAllSelected(true)
end

UpdateAimbotTeamGrid()

Teams.ChildAdded:Connect(function(Child)
	if Child:IsA("Team") then
		UpdateAimbotTeamGrid()
	end
end)

Teams.ChildRemoved:Connect(function(Child)
	if Child:IsA("Team") then
		FS.AimbotSettings.TargetTeams[Child.Name] = nil
		UpdateAimbotTeamGrid()
	end
end)

--==================================================
-- AIMBOT FOV TOGGLE
--==================================================


local FOVButton = Instance.new("TextButton")
FOVButton.Size = UDim2.new(1, -10, 0, 42)
FOVButton.Position = UDim2.new(0, 0, 0, 365)
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
			FS.AimbotSettings.ShowFOV
			and "ON"
			or "OFF"
		)

	FOVButton.TextColor3 =
		FS.AimbotSettings.ShowFOV
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

		FS.AimbotSettings.ShowFOV =
			not FS.AimbotSettings.ShowFOV

		UpdateFOVButton()
	end
)

UpdateFOVButton()

--==================================================
-- AIMBOT AIM KEY INFO
--==================================================

local AimKeyButton = Instance.new("TextButton")
AimKeyButton.Size = UDim2.new(1, -10, 0, 42)
AimKeyButton.Position = UDim2.new(0, 0, 0, 415)
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
VisibilityButton.Position = UDim2.new(0, 0, 0, 465)
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
			FS.AimbotSettings.LineOfSight
			and "ON"
			or "OFF"
		)

	VisibilityButton.TextColor3 =
		FS.AimbotSettings.LineOfSight
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

		FS.AimbotSettings.LineOfSight =
			not FS.AimbotSettings.LineOfSight

		FS.AimbotTarget = nil

		UpdateVisibilityButton()
	end
)

UpdateVisibilityButton()

--==================================================
-- AIMBOT FOV OPACITY
--==================================================

local FOVOpacityLabel = Instance.new("TextLabel")
FOVOpacityLabel.Size = UDim2.new(1, -10, 0, 20)
FOVOpacityLabel.Position = UDim2.new(0, 0, 0, 515)
FOVOpacityLabel.BackgroundTransparency = 1
FOVOpacityLabel.Text = "FOV OPACITY"
FOVOpacityLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
FOVOpacityLabel.TextSize = 11
FOVOpacityLabel.Font = Enum.Font.GothamBold
FOVOpacityLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVOpacityLabel.Parent = AimbotPage

local FOVOpacityValue = Instance.new("TextBox")
FOVOpacityValue.Size = UDim2.new(0, 110, 0, 38)
FOVOpacityValue.Position = UDim2.new(0, 0, 0, 540)
FOVOpacityValue.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
FOVOpacityValue.BorderSizePixel = 0
FOVOpacityValue.Text =
	tostring(
		math.floor(
			FS.AimbotSettings.FOVOpacity * 100
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
FOVOpacityMinus.Position = UDim2.new(0, 118, 0, 540)
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
FOVOpacityPlus.Position = UDim2.new(0, 162, 0, 540)
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
			FS.AimbotSettings.FOVOpacity * 100
	end

	Value = math.clamp(
		math.floor(Value),
		10,
		100
	)

	FS.AimbotSettings.FOVOpacity =
		Value / 100

	FOVOpacityValue.Text =
		tostring(Value)

	FS.AimbotCircleStroke.Transparency =
		1 - FS.AimbotSettings.FOVOpacity
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
			FS.AimbotSettings.FOVOpacity * 100 - 10
		)
	end
)

FOVOpacityPlus.MouseButton1Click:Connect(
	function()

		SetFOVOpacity(
			FS.AimbotSettings.FOVOpacity * 100 + 10
		)
	end
)

--==================================================
-- AIMBOT FOV COLOR
--==================================================

local FOVColorLabel = Instance.new("TextLabel")
FOVColorLabel.Size = UDim2.new(1, -10, 0, 20)
FOVColorLabel.Position = UDim2.new(0, 0, 0, 590)
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
FOVColorContainer.Position = UDim2.new(0, 0, 0, 610)
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

			FS.AimbotSettings.FOVColor =
				ColorData.Color

			FS.AimbotCircleStroke.Color =
				ColorData.Color
		end
	)
end

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
ESPPage.CanvasSize = UDim2.new(0, 0, 0, 690)
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
-- ESP TARGET TEAMS
--==================================================

local ESPTeamLabel = Instance.new("TextLabel")
ESPTeamLabel.Size = UDim2.new(1, -10, 0, 20)
ESPTeamLabel.Position = UDim2.new(0, 0, 0, 55)
ESPTeamLabel.BackgroundTransparency = 1
ESPTeamLabel.Text = "DISPLAY TEAMS"
ESPTeamLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
ESPTeamLabel.TextSize = 11
ESPTeamLabel.Font = Enum.Font.GothamBold
ESPTeamLabel.TextXAlignment = Enum.TextXAlignment.Left
ESPTeamLabel.Parent = ESPPage

local ESPTeamGrid = Instance.new("ScrollingFrame")
ESPTeamGrid.Size = UDim2.new(1, -10, 0, 128)
ESPTeamGrid.Position = UDim2.new(0, 0, 0, 80)
ESPTeamGrid.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
ESPTeamGrid.BorderSizePixel = 0
ESPTeamGrid.ScrollBarThickness = 5
ESPTeamGrid.ScrollingDirection = Enum.ScrollingDirection.Y
ESPTeamGrid.CanvasSize = UDim2.new(0, 0, 0, 0)
ESPTeamGrid.Parent = ESPPage

local ESPTeamGridCorner = Instance.new("UICorner")
ESPTeamGridCorner.CornerRadius = UDim.new(0, 6)
ESPTeamGridCorner.Parent = ESPTeamGrid

local ESPTeamGridPadding = Instance.new("UIPadding")
ESPTeamGridPadding.PaddingTop = UDim.new(0, 6)
ESPTeamGridPadding.PaddingBottom = UDim.new(0, 6)
ESPTeamGridPadding.PaddingLeft = UDim.new(0, 6)
ESPTeamGridPadding.PaddingRight = UDim.new(0, 6)
ESPTeamGridPadding.Parent = ESPTeamGrid

local ESPTeamGridLayout = Instance.new("UIGridLayout")
ESPTeamGridLayout.CellSize = UDim2.new(0.333333, -8, 0, 34)
ESPTeamGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
ESPTeamGridLayout.FillDirection = Enum.FillDirection.Horizontal
ESPTeamGridLayout.FillDirectionMaxCells = 3
ESPTeamGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
ESPTeamGridLayout.Parent = ESPTeamGrid

FS.ESPSettings.TargetTeams = FS.ESPSettings.TargetTeams or {}

local function UpdateESPTeamGrid()
	for _, Child in ipairs(ESPTeamGrid:GetChildren()) do
		if Child:IsA("TextButton") then
			Child:Destroy()
		end
	end

	local Names = GetTeamNamesForSelector()
	local AllSelected = #Names > 0
	for _, Name in ipairs(Names) do
		if FS.ESPSettings.TargetTeams[Name] ~= true then
			AllSelected = false
			break
		end
	end

	local AllButton = Instance.new("TextButton")
	AllButton.BackgroundColor3 = AllSelected and Color3.fromRGB(60, 200, 90) or Color3.fromRGB(45, 45, 45)
	AllButton.BorderSizePixel = 0
	AllButton.Text = "ALL"
	AllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	AllButton.TextSize = 11
	AllButton.Font = Enum.Font.GothamBold
	AllButton.AutoButtonColor = false
	AllButton.Parent = ESPTeamGrid

	local AllCorner = Instance.new("UICorner")
	AllCorner.CornerRadius = UDim.new(0, 5)
	AllCorner.Parent = AllButton

	AllButton.MouseButton1Click:Connect(function()
		FS.ESPSettings.TargetTeams = {}
		if not AllSelected then
			for _, Name in ipairs(Names) do
				FS.ESPSettings.TargetTeams[Name] = true
			end
			FS.ESPSettings.Enabled = true
		else
			FS.ESPSettings.Enabled = false
		end
		UpdateESPTabToggle()
		UpdateESPTeamGrid()
	end)

	for _, Name in ipairs(Names) do
		local Selected = FS.ESPSettings.TargetTeams[Name] == true
		local Button = Instance.new("TextButton")
		Button.BackgroundColor3 = Selected and Color3.fromRGB(60, 200, 90) or Color3.fromRGB(45, 45, 45)
		Button.BorderSizePixel = 0
		Button.Text = string.upper(Name)
		Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		Button.TextSize = 10
		Button.Font = Enum.Font.GothamBold
		Button.TextTruncate = Enum.TextTruncate.AtEnd
		Button.AutoButtonColor = false
		Button.Parent = ESPTeamGrid

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 5)
		Corner.Parent = Button

		Button.MouseButton1Click:Connect(function()
			FS.ESPSettings.TargetTeams[Name] = not Selected
			if next(FS.ESPSettings.TargetTeams) == nil then
				FS.ESPSettings.Enabled = false
			else
				FS.ESPSettings.Enabled = true
			end
			UpdateESPTabToggle()
			UpdateESPTeamGrid()
		end)
	end

	ESPTeamGrid.CanvasSize = UDim2.new(0, 0, 0, ESPTeamGridLayout.AbsoluteContentSize.Y + 12)
end

if next(FS.ESPSettings.TargetTeams) == nil then
	for _, Name in ipairs(GetTeamNamesForSelector()) do
		FS.ESPSettings.TargetTeams[Name] = true
	end
end

UpdateESPTeamGrid()

Teams.ChildAdded:Connect(function(Child)
	if Child:IsA("Team") then
		FS.ESPSettings.TargetTeams[Child.Name] = true
		UpdateESPTeamGrid()
	end
end)

Teams.ChildRemoved:Connect(function(Child)
	if Child:IsA("Team") then
		FS.ESPSettings.TargetTeams[Child.Name] = nil
		if next(FS.ESPSettings.TargetTeams) == nil then
			FS.ESPSettings.Enabled = false
			UpdateESPTabToggle()
		end
		UpdateESPTeamGrid()
	end
end)

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
			FS.ESPSettings[SettingName]

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

			FS.ESPSettings[SettingName] =
				not FS.ESPSettings[SettingName]

			Update()

			if SettingName ==
				"Enabled" then

				UpdateESPTabToggle()
			end
		end
	)

	Update()
end

CreateESPToggle("ESP", "Enabled", 220)
CreateESPToggle("Names", "Names", 268)
CreateESPToggle("Distance", "Distance", 316)
CreateESPToggle("Health", "Health", 364)
CreateESPToggle("Lines", "Lines", 412)
CreateESPToggle("Use Team Color", "UseTeamColor", 460)

ESPToggle.MouseButton1Click:Connect(
	function()

		FS.ESPSettings.Enabled =
			not FS.ESPSettings.Enabled

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
		508
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
		FS.ESPObjects
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

		if not FS.ESPSettings.Enabled
			or not FS.ESPSettings.Health then

			Data.HealthText.Visible = false
			Data.HealthBarBackground.Visible = false

			continue
		end

		if FS.HealthStyle == "Text" then

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

		if FS.HealthStyle == "Text" then

			FS.HealthStyle =
				"Bar"

			HealthStyleButton.Text =
				"   Health Style: BAR"

		else

			FS.HealthStyle =
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
		553
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
		573
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

			FS.ESPSettings.Color =
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
		620
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
		640
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

			FS.ESPSettings.TextColor =
				ColorData.Color
		end
	)
end

--==================================================
-- SPECTATE PAGE
--==================================================

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

FS.StopButton =
	Instance.new("TextButton")

FS.StopButton.Size =
	UDim2.new(
		1,
		0,
		0,
		40
	)

FS.StopButton.Position =
	UDim2.new(
		0,
		0,
		1,
		-40
	)

FS.StopButton.BackgroundColor3 =
	Color3.fromRGB(
		65,
		35,
		35
	)

FS.StopButton.BorderSizePixel = 0
FS.StopButton.Text = "STOP SPECTATING"

FS.StopButton.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

FS.StopButton.TextSize = 13
FS.StopButton.Font = Enum.Font.GothamBold
FS.StopButton.Parent =
	SpectatePage

local StopCorner =
	Instance.new("UICorner")

StopCorner.CornerRadius =
	UDim.new(
		0,
		6
	)

StopCorner.Parent =
	FS.StopButton

--==================================================
-- SETTINGS PAGE
--==================================================

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

--==================================================
-- KEYBIND CREATOR
--==================================================

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
			-180,
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
			-180,
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
			-170,
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

	local UnbindButton = Instance.new("TextButton")
	UnbindButton.Size = UDim2.new(0, 52, 0, 38)
	UnbindButton.Position = UDim2.new(1, -62, 0, 23)
	UnbindButton.BackgroundColor3 = Color3.fromRGB(70, 35, 35)
	UnbindButton.BorderSizePixel = 0
	UnbindButton.Text = "UNBIND"
	UnbindButton.TextColor3 = Color3.fromRGB(255, 170, 170)
	UnbindButton.TextSize = 10
	UnbindButton.Font = Enum.Font.GothamBold
	UnbindButton.AutoButtonColor = false
	UnbindButton.Parent = Section

	local UnbindCorner = Instance.new("UICorner")
	UnbindCorner.CornerRadius = UDim.new(0, 6)
	UnbindCorner.Parent = UnbindButton

	return Keybind, UnbindButton
end

FS.TeleportKeybind, TeleportUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Teleport",
		"Teleport to your mouse position",
		65,
		"UNBOUND"
	)

FS.ReopenKeybind, ReopenUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Reopen",
		"Key used to reopen Fun Scripts",
		160,
		"F9"
	)

FS.StopSpectatingKeybind, StopSpectatingUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Stop Spectating",
		"Quickly return the camera to yourself",
		255,
		"LeftAlt"
	)

FS.UnlockCamKeybind, UnlockCamUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Free Cam",
		"Toggle unlimited zoom and wall-through camera",
		350,
		"Z"
	)

FS.AimbotKeybind, AimbotUnbind =
	CreateKeybindSection(
		SettingsPage,
		"Aimbot",
		"Toggle aimbot on or off",
		445,
		"UNBOUND"
	)

--==================================================
-- KEYBIND UNBIND BUTTONS
--==================================================

local function ClearKeybind(Which)
	if Which == "Teleport" then
		FS.BoundTeleportKey = nil
		FS.WaitingForTeleportKey = false
		FS.TeleportKeybind.Text = "UNBOUND"
		FS.TeleportKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
	elseif Which == "Reopen" then
		FS.BoundReopenKey = nil
		FS.WaitingForReopenKey = false
		FS.ReopenKeybind.Text = "UNBOUND"
		FS.ReopenKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
	elseif Which == "StopSpectating" then
		FS.BoundStopSpectatingKey = nil
		FS.WaitingForStopSpectatingKey = false
		FS.StopSpectatingKeybind.Text = "UNBOUND"
		FS.StopSpectatingKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
	elseif Which == "UnlockCam" then
		FS.BoundUnlockCamKey = nil
		FS.WaitingForUnlockCamKey = false
		FS.UnlockCamKeybind.Text = "UNBOUND"
		FS.UnlockCamKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
	elseif Which == "Aimbot" then
		FS.BoundAimbotKey = nil
		FS.WaitingForAimbotKey = false
		FS.AimbotKeybind.Text = "UNBOUND"
		FS.AimbotKeybind.TextColor3 = Color3.fromRGB(100, 255, 100)
	end
end

TeleportUnbind.MouseButton1Click:Connect(function() ClearKeybind("Teleport") end)
ReopenUnbind.MouseButton1Click:Connect(function() ClearKeybind("Reopen") end)
StopSpectatingUnbind.MouseButton1Click:Connect(function() ClearKeybind("StopSpectating") end)
UnlockCamUnbind.MouseButton1Click:Connect(function() ClearKeybind("UnlockCam") end)
AimbotUnbind.MouseButton1Click:Connect(function() ClearKeybind("Aimbot") end)

--==================================================
-- TOOLTIP
--==================================================

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

--==================================================
-- RESIZE HANDLES
--==================================================

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
	FS.Main

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
	FS.Main

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
	FS.Main

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

--==================================================
-- RESIZE HOVER
--==================================================

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

--==================================================
-- RESIZE
--==================================================

local ResizeMode = nil
local ResizeStartMouse = nil
local ResizeStartSize = nil

local function BeginResize(
	Mode,
	Input
)

	ResizeMode = Mode
	ResizeStartMouse = Input.Position
	ResizeStartSize = FS.Main.AbsoluteSize
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

FS.UserInputService.InputChanged:Connect(
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

		FS.Main.Size =
			UDim2.new(
				0,
				NewWidth,
				0,
				NewHeight
			)
	end
)

FS.UserInputService.InputEnded:Connect(
	function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			ResizeMode = nil
		end
	end
)

--==================================================
-- TAB SWITCHING
--==================================================

function FS.UpdateTabs()

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
		FS.UpdateTabs()
	end
)

ESPTab.MouseButton1Click:Connect(
	function()

		CurrentTab = "ESP"
		FS.UpdateTabs()
	end
)

SpectateTab.MouseButton1Click:Connect(
	function()

		CurrentTab = "Spectate"
		FS.UpdateTabs()
	end
)

SettingsTab.MouseButton1Click:Connect(
	function()

		CurrentTab = "Settings"
		FS.UpdateTabs()
	end
)

--==================================================
-- DRAGGING
--==================================================

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
		StartPosition = FS.Main.Position
	end
)

FS.UserInputService.InputChanged:Connect(
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

		FS.Main.Position =
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

FS.UserInputService.InputEnded:Connect(
	function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging = false
		end
	end
)

--==================================================
-- MINIMIZE / CLOSE
--==================================================

MinimizeButton.MouseButton1Click:Connect(
	function()

		Minimized =
			not Minimized

		if Minimized then

			Body.Visible = false

			FS.Main.Size =
				UDim2.new(
					0,
					FS.Main.AbsoluteSize.X,
					0,
					42
				)

			MinimizeButton.Text = "+"

		else

			Body.Visible = true

			FS.Main.Size =
				UDim2.new(
					0,
					math.max(
						MIN_WIDTH,
						FS.Main.AbsoluteSize.X
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

		FS.Main.Visible = false
	end
)

--==================================================
-- CAMERA
--==================================================

local function EnableUnlockedCamera()

	FS.LocalPlayer.CameraMaxZoomDistance =
		UNLOCKED_MAX_ZOOM

	FS.LocalPlayer.DevCameraOcclusionMode =
		Enum.DevCameraOcclusionMode.Invisicam
end

local function RestoreNormalCamera()

	FS.LocalPlayer.CameraMaxZoomDistance =
		OriginalCameraMaxZoomDistance

	FS.LocalPlayer.CameraMinZoomDistance =
		OriginalCameraMinZoomDistance

	FS.LocalPlayer.DevCameraOcclusionMode =
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

function FS.ToggleUnlockCam()

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

		FS.ToggleUnlockCam()
	end
)

UpdateUnlockCamButton()

--==================================================
-- SPECTATE
--==================================================

function FS.GetHumanoid(Player)

	local Character =
		Player.Character

	if not Character then
		return nil
	end

	return Character:FindFirstChildOfClass(
		"Humanoid"
	)
end

function FS.StopSpectating()

	FS.SpectatingPlayer = nil

	local CurrentCamera =
		workspace.CurrentCamera

	if OriginalCameraSubject
		and OriginalCameraSubject.Parent then

		CurrentCamera.CameraSubject =
			OriginalCameraSubject

	else

		local Character =
			FS.LocalPlayer.Character

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

	if Player == FS.LocalPlayer then
		return
	end

	local Humanoid =
		FS.GetHumanoid(Player)

	if not Humanoid then
		return
	end

	local CurrentCamera =
		workspace.CurrentCamera

	if not FS.SpectatingPlayer then

		OriginalCameraSubject =
			CurrentCamera.CameraSubject

		UnlockCamStateBeforeSpectate =
			UnlockCamEnabled
	end

	FS.SpectatingPlayer =
		Player

	CurrentCamera.CameraType =
		Enum.CameraType.Custom

	CurrentCamera.CameraSubject =
		Humanoid

	UnlockCamEnabled = true

	EnableUnlockedCamera()
	UpdateUnlockCamButton()
end

--==================================================
-- PLAYER LIST
--==================================================

FS.PlayerButtons = {}

local function GetTeamSortValue(Player)

	if Player.Team then
		return Player.Team.Name
	end

	return "ZZZZZZZZ"
end

function FS.SortPlayerButtons()

	local Data = {}

	for Player, Info in pairs(
		FS.PlayerButtons
	) do

		if Player.Parent ==
			FS.Players
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

function FS.UpdatePlayerButton(Player)

	local Data =
		FS.PlayerButtons[Player]

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
		FS.LocalPlayer.Character

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

function FS.CreatePlayerButton(Player)

	if Player == FS.LocalPlayer
		or FS.PlayerButtons[Player] then
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
				FS.UserInputService:GetMouseLocation()

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
					FS.UserInputService:GetMouseLocation()

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

	FS.PlayerButtons[Player] = {
		Button = Button,
		NameLabel = NameLabel,
		DistanceLabel = DistanceLabel
	}

	FS.UpdatePlayerButton(
		Player
	)

	FS.SortPlayerButtons()

	Player:GetPropertyChangedSignal(
		"Team"
	):Connect(
		function()

			FS.UpdatePlayerButton(
				Player
			)

			FS.SortPlayerButtons()
		end
	)

	Player:GetPropertyChangedSignal(
		"TeamColor"
	):Connect(
		function()

			FS.UpdatePlayerButton(
				Player
			)

			FS.SortPlayerButtons()
		end
	)

	Player:GetPropertyChangedSignal(
		"DisplayName"
	):Connect(
		function()

			FS.UpdatePlayerButton(
				Player
			)

			FS.SortPlayerButtons()
		end
	)
end

function FS.RemovePlayerButton(Player)

	local Data =
		FS.PlayerButtons[Player]

	if Data and Data.Button then
		Data.Button:Destroy()
	end

	FS.PlayerButtons[Player] = nil

	if FS.SpectatingPlayer ==
		Player then

		FS.StopSpectating()
	end

	if FS.AimbotTarget ==
		Player then

		FS.AimbotTarget = nil
	end

	FS.SortPlayerButtons()
end

--==================================================
-- CHARACTER RESPAWN
--==================================================

function FS.HandleCharacterAdded(
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

			FS.UpdatePlayerButton(
				Player
			)

			if FS.SpectatingPlayer ==
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
		FS.ESPSettings.TextColor

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

function FS.RemovePlayerESP(Player)

	local Data =
		FS.ESPObjects[Player]

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

	FS.ESPObjects[Player] = nil
end

local function CreatePlayerESP(
	Player,
	Character
)

	if Player == FS.LocalPlayer then
		return
	end

	if not Character
		or not Character.Parent then
		return
	end

	FS.RemovePlayerESP(
		Player
	)

	local Highlight =
		Instance.new("Highlight")

	Highlight.Adornee =
		Character

	Highlight.FillColor =
		FS.ESPSettings.Color

	Highlight.OutlineColor =
		FS.ESPSettings.Color

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
		FS.ESPSettings.Color

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

	FS.ESPObjects[Player] = {

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

function FS.SetupESPPlayer(
	Player
)

	if Player == FS.LocalPlayer then
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


FS.UIReady = true
