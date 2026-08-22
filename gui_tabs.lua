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
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, DEFAULT_WIDTH, 0, DEFAULT_HEIGHT)
Main.Position = UDim2.new(0.5, -310, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Parent = Main
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
local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, 0, 1, -42)
Body.Position = UDim2.new(0, 0, 0, 42)
Body.BackgroundTransparency = 1
Body.ClipsDescendants = true
Body.Parent = Main
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
local function UpdateAimbotTabToggle()
	if AimbotSettings.Enabled then
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
		AimbotSettings.Enabled =
			not AimbotSettings.Enabled
		if not AimbotSettings.Enabled then
			AimbotHolding = false
			AimbotTarget = nil
		end
		UpdateAimbotTabToggle()
	end
)
UpdateAimbotTabToggle()
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
	if ESPSettings.Enabled then
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
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -160, 1, 0)
ContentArea.Position = UDim2.new(0, 160, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent = Body
local AimbotCircle = Instance.new("Frame")
AimbotCircle.Name = "AimbotFOV"
AimbotCircle.AnchorPoint = Vector2.new(0.5, 0.5)
AimbotCircle.BackgroundTransparency = 1
AimbotCircle.BorderSizePixel = 0
AimbotCircle.ZIndex = 20
AimbotCircle.Parent = ESPGui
local AimbotCircleCorner = Instance.new("UICorner")
AimbotCircleCorner.CornerRadius = UDim.new(1, 0)
AimbotCircleCorner.Parent = AimbotCircle
local AimbotCircleStroke = Instance.new("UIStroke")
AimbotCircleStroke.Thickness = 1.5
AimbotCircleStroke.Transparency =
	1 - AimbotSettings.FOVOpacity
AimbotCircleStroke.Color =
	AimbotSettings.FOVColor
AimbotCircleStroke.Parent = AimbotCircle
