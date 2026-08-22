--==================================================
-- FUN SCRIPTS
-- ESP + Aimbot + Spectate + Settings
-- LocalScript
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--==================================================
-- KEYBINDS
--==================================================

local BoundTeleportKey = nil
local WaitingForTeleportKey = false

local BoundReopenKey = Enum.KeyCode.F9
local WaitingForReopenKey = false

local BoundStopSpectatingKey = Enum.KeyCode.LeftAlt
local WaitingForStopSpectatingKey = false

local BoundUnlockCamKey = Enum.KeyCode.Z
local WaitingForUnlockCamKey = false

local BoundAimbotKey = nil
local WaitingForAimbotKey = false

--==================================================
-- MENU
--==================================================

local Minimized = false
local CurrentTab = "Aimbot"

--==================================================
-- ESP SETTINGS
--==================================================

local ESPSettings = {
	Enabled = true,
	Names = true,
	Distance = true,
	Health = true,
	Lines = false,

	Color = Color3.fromRGB(255, 48, 51),
	TextColor = Color3.fromRGB(255, 255, 255)
}

local HealthStyle = "Bar"

local ESPObjects = {}

--==================================================
-- AIMBOT SETTINGS
--==================================================

local AimbotSettings = {
	Enabled = true,
	Radius = 150,
	TargetMode = "Head",
	ShowFOV = true,
	LineOfSight = true,

	FOVOpacity = 0.85,
	FOVColor = Color3.fromRGB(255, 255, 255),

	AimKey = Enum.UserInputType.MouseButton2
}

local AimbotHolding = false
local AimbotTarget = nil
local AlternateTarget = "Head"

--==================================================
-- CAMERA
--==================================================

local UnlockCamEnabled = false
local SpectatingPlayer = nil
local OriginalCameraSubject = nil
local UnlockCamStateBeforeSpectate = false

local OriginalCameraMaxZoomDistance =
	LocalPlayer.CameraMaxZoomDistance

local OriginalCameraMinZoomDistance =
	LocalPlayer.CameraMinZoomDistance

local OriginalOcclusionMode =
	LocalPlayer.DevCameraOcclusionMode

local UNLOCKED_MAX_ZOOM = 1000000

--==================================================
-- WINDOW
--==================================================

local MIN_WIDTH = 500
local MIN_HEIGHT = 360

local DEFAULT_WIDTH = 620
local DEFAULT_HEIGHT = 460

