--[[
    ██████╗ ██╗   ██╗████████╗███████╗███████╗
    ██╔══██╗██║   ██║╚══██╔══╝╚══███╔╝██╔════╝
    ██████╔╝██║   ██║   ██║     ███╔╝ █████╗  
    ██╔═══╝ ██║   ██║   ██║    ███╔╝  ██╔══╝  
    ██║     ╚██████╔╝   ██║   ███████╗███████╗
    ╚═╝      ╚═════╝    ╚═╝   ╚══════╝╚══════╝
    
    [ Putzz Developer - HP/MOBILE EDITION ]
    Fitur: ESP Dotted Line/Box, Fly Bebas, Touch Control
]]

-- Load Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Anti Kick
local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then return nil end
    return oldNamecall(self, ...)
end)

-- GUI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PutzzMobile_" .. math.random(1000, 9999)
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

-- Variables
local ESPEnabled = false
local ESPBox = false
local ESPName = false
local ESPDistance = false
local ESPHealth = false
local ESPLine = false
local FlyEnabled = false
local NoclipEnabled = false
local AimbotEnabled = false
local CurrentColor = Color3.fromRGB(0, 255, 255)
local ESPObjects = {}
local FlySpeed = 50
local BodyGyro, BodyVelocity
local UIScale = 1

-- Deteksi HP
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
if isMobile then
    UIScale = 1.5 -- Ukuran lebih besar untuk HP
end

-- Create UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450 * UIScale, 0, 600 * UIScale)
MainFrame.Position = UDim2.new(0.5, -225 * UIScale, 0.5, -300 * UIScale)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 50, 1, 50)
Shadow.Position = UDim2.new(0, -25, 0, -25)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 60 * UIScale)
TitleBar.BackgroundColor3 = CurrentColor
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Putzz Mobile Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 28 * UIScale
Title.Font = Enum.Font.GothamBold
Title.Parent = TitleBar

-- Close Button (FIXED)
local CloseBtn = Instance.new("ImageButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 50 * UIScale, 0, 50 * UIScale)
CloseBtn.Position = UDim2.new(1, -60 * UIScale, 0.5, -25 * UIScale)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Image = "rbxassetid://6031280882" -- Ikon X
CloseBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("ImageButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 50 * UIScale, 0, 50 * UIScale)
MinimizeBtn.Position = UDim2.new(1, -120 * UIScale, 0.5, -25 * UIScale)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Image = "rbxassetid://6031280882" -- Ganti dengan ikon minimize
MinimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Parent = TitleBar

-- Tab Buttons (diperbesar untuk touch)
local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(1, 0, 0, 80 * UIScale)
TabFrame.Position = UDim2.new(0, 0, 0, 60 * UIScale)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local ESPTab = Instance.new("TextButton")
ESPTab.Name = "ESPTab"
ESPTab.Size = UDim2.new(0.33, -10, 0.8, 0)
ESPTab.Position = UDim2.new(0.01, 0, 0.1, 0)
ESPTab.BackgroundColor3 = CurrentColor
ESPTab.BackgroundTransparency = 0.3
ESPTab.Text = "ESP"
ESPTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPTab.TextSize = 22 * UIScale
ESPTab.Font = Enum.Font.GothamBold
ESPTab.Parent = TabFrame

local MainTab = Instance.new("TextButton")
MainTab.Name = "MainTab"
MainTab.Size = UDim2.new(0.33, -10, 0.8, 0)
MainTab.Position = UDim2.new(0.335, 0, 0.1, 0)
MainTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainTab.BackgroundTransparency = 0.3
MainTab.Text = "MAIN"
MainTab.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTab.TextSize = 22 * UIScale
MainTab.Font = Enum.Font.GothamBold
MainTab.Parent = TabFrame

local AimbotTab = Instance.new("TextButton")
AimbotTab.Name = "AimbotTab"
AimbotTab.Size = UDim2.new(0.33, -10, 0.8, 0)
AimbotTab.Position = UDim2.new(0.67, 0, 0.1, 0)
AimbotTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AimbotTab.BackgroundTransparency = 0.3
AimbotTab.Text = "AIM"
AimbotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotTab.TextSize = 22 * UIScale
AimbotTab.Font = Enum.Font.GothamBold
AimbotTab.Parent = TabFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0.95, 0, 0, 400 * UIScale)
ContentFrame.Position = UDim2.new(0.025, 0, 0, 150 * UIScale)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BackgroundTransparency = 0.2
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 15)
ContentCorner.Parent = ContentFrame

-- ESP Frame
local ESPFrame = Instance.new("ScrollingFrame")
ESPFrame.Name = "ESPFrame"
ESPFrame.Size = UDim2.new(1, 0, 1, 0)
ESPFrame.BackgroundTransparency = 1
ESPFrame.BorderSizePixel = 0
ESPFrame.ScrollBarThickness = 10 * UIScale
ESPFrame.Visible = true
ESPFrame.Parent = ContentFrame

local ESPLayout = Instance.new("UIListLayout")
ESPLayout.Padding = UDim.new(0, 10 * UIScale)
ESPLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ESPLayout.Parent = ESPFrame

-- Main Frame
local MainFrameFrame = Instance.new("ScrollingFrame")
MainFrameFrame.Name = "MainFrameFrame"
MainFrameFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrameFrame.BackgroundTransparency = 1
MainFrameFrame.BorderSizePixel = 0
MainFrameFrame.ScrollBarThickness = 10 * UIScale
MainFrameFrame.Visible = false
MainFrameFrame.Parent = ContentFrame

local MainLayout = Instance.new("UIListLayout")
MainLayout.Padding = UDim.new(0, 10 * UIScale)
MainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MainLayout.Parent = MainFrameFrame

-- Aimbot Frame
local AimbotFrame = Instance.new("ScrollingFrame")
AimbotFrame.Name = "AimbotFrame"
AimbotFrame.Size = UDim2.new(1, 0, 1, 0)
AimbotFrame.BackgroundTransparency = 1
AimbotFrame.BorderSizePixel = 0
AimbotFrame.ScrollBarThickness = 10 * UIScale
AimbotFrame.Visible = false
AimbotFrame.Parent = ContentFrame

local AimbotLayout = Instance.new("UIListLayout")
AimbotLayout.Padding = UDim.new(0, 10 * UIScale)
AimbotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
AimbotLayout.Parent = AimbotFrame

-- Fly Control untuk HP (Touch Buttons)
local FlyControlFrame = Instance.new("Frame")
FlyControlFrame.Name = "FlyControlFrame"
FlyControlFrame.Size = UDim2.new(1, 0, 0, 200 * UIScale)
FlyControlFrame.BackgroundTransparency = 1
FlyControlFrame.Visible = false
FlyControlFrame.Parent = ScreenGui

-- Tombol WASD untuk HP
local function createFlyButton(pos, text, color, vector)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80 * UIScale, 0, 80 * UIScale)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 30 * UIScale
    btn.Font = Enum.Font.GothamBold
    btn.Parent = FlyControlFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 15)
    btnCorner.Parent = btn
    
    btn.MouseButton1Down:Connect(function()
        if FlyEnabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                if vector.Y ~= 0 then
                    -- Vertical
                    root.Velocity = vector * FlySpeed
                else
                    -- Horizontal based on camera
                    local move = (Camera.CFrame.LookVector * vector.Z + Camera.CFrame.RightVector * vector.X) * FlySpeed
                    root.Velocity = Vector3.new(move.X, root.Velocity.Y, move.Z)
                end
            end
        end
    end)
    
    btn.MouseButton1Up:Connect(function()
        if FlyEnabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    return btn
end

-- Buat tombol fly
local centerX = Camera.ViewportSize.X / 2
local centerY = Camera.ViewportSize.Y - 150 * UIScale

createFlyButton(UDim2.new(0.5, -120 * UIScale, 1, -100 * UIScale), "W", Color3.fromRGB(255, 0, 0), Vector3.new(0, 0, 1))
createFlyButton(UDim2.new(0.5, -40 * UIScale, 1, -100 * UIScale), "S", Color3.fromRGB(0, 255, 0), Vector3.new(0, 0, -1))
createFlyButton(UDim2.new(0.5, -200 * UIScale, 1, -20 * UIScale), "A", Color3.fromRGB(0, 0, 255), Vector3.new(-1, 0, 0))
createFlyButton(UDim2.new(0.5, 40 * UIScale, 1, -20 * UIScale), "D", Color3.fromRGB(255, 255, 0), Vector3.new(1, 0, 0))
createFlyButton(UDim2.new(0.5, -80 * UIScale, 1, 20 * UIScale), "UP", Color3.fromRGB(255, 0, 255), Vector3.new(0, 1, 0))
createFlyButton(UDim2.new(0.5, 0 * UIScale, 1, 20 * UIScale), "DOWN", Color3.fromRGB(0, 255, 255), Vector3.new(0, -1, 0))

-- Create Toggle Button Function
local function CreateToggleButton(parent, text)
    local btn = Instance.new("Frame")
    btn.Name = text.."Btn"
    btn.Size = UDim2.new(0.95, 0, 0, 70 * UIScale)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.3
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 15)
    btnCorner.Parent = btn
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 20, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = 20 * UIScale
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = btn
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 80 * UIScale, 0, 50 * UIScale)
    toggle.Position = UDim2.new(1, -100 * UIScale, 0.5, -25 * UIScale)
    toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    toggle.BackgroundTransparency = 0.3
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 18 * UIScale
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = btn
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggle
    
    return {Frame = btn, Button = toggle}
end

-- Create ESP Toggles
local ESPBoxBtn = CreateToggleButton(ESPFrame, "ESP Box (Dotted)")
local ESPNameBtn = CreateToggleButton(ESPFrame, "ESP Name")
local ESPDistanceBtn = CreateToggleButton(ESPFrame, "ESP Distance")
local ESPHealthBtn = CreateToggleButton(ESPFrame, "ESP Health")
local ESPLineBtn = CreateToggleButton(ESPFrame, "ESP Line (Dotted)")

-- Create Main Toggles
local FlyBtn = CreateToggleButton(MainFrameFrame, "Fly Mode")
local NoclipBtn = CreateToggleButton(MainFrameFrame, "Noclip")

-- Teleport Input (diperbesar untuk HP)
local TPFrame = Instance.new("Frame")
TPFrame.Name = "TPFrame"
TPFrame.Size = UDim2.new(0.95, 0, 0, 100 * UIScale)
TPFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TPFrame.BackgroundTransparency = 0.3
TPFrame.Parent = MainFrameFrame

local TPCorner = Instance.new("UICorner")
TPCorner.CornerRadius = UDim.new(0, 15)
TPCorner.Parent = TPFrame

local TPLabel = Instance.new("TextLabel")
TPLabel.Size = UDim2.new(1, 0, 0, 40 * UIScale)
TPLabel.Position = UDim2.new(0, 20, 0, 10)
TPLabel.BackgroundTransparency = 1
TPLabel.Text = "Teleport ke Player:"
TPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TPLabel.TextXAlignment = Enum.TextXAlignment.Left
TPLabel.TextSize = 18 * UIScale
TPLabel.Font = Enum.Font.Gotham
TPLabel.Parent = TPFrame

local TPInput = Instance.new("TextBox")
TPInput.Size = UDim2.new(0.7, 0, 0, 50 * UIScale)
TPInput.Position = UDim2.new(0, 20, 0, 50)
TPInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TPInput.PlaceholderText = "Nama Player"
TPInput.Text = ""
TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TPInput.TextSize = 18 * UIScale
TPInput.Font = Enum.Font.Gotham
TPInput.Parent = TPFrame

local TPInputCorner = Instance.new("UICorner")
TPInputCorner.CornerRadius = UDim.new(0, 10)
TPInputCorner.Parent = TPInput

local TPButton = Instance.new("TextButton")
TPButton.Size = UDim2.new(0.2, 0, 0, 50 * UIScale)
TPButton.Position = UDim2.new(0.75, 0, 0, 50)
TPButton.BackgroundColor3 = CurrentColor
TPButton.BackgroundTransparency = 0.3
TPButton.Text = "TP"
TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TPButton.TextSize = 22 * UIScale
TPButton.Font = Enum.Font.GothamBold
TPButton.Parent = TPFrame

local TPButtonCorner = Instance.new("UICorner")
TPButtonCorner.CornerRadius = UDim.new(0, 10)
TPButtonCorner.Parent = TPButton

-- Create Aimbot Toggle
local AimbotToggle = CreateToggleButton(AimbotFrame, "Aimbot (Hold Right Click)")

-- Color Picker Sederhana
local ColorFrame = Instance.new("Frame")
ColorFrame.Name = "ColorFrame"
ColorFrame.Size = UDim2.new(0.95, 0, 0, 100 * UIScale)
ColorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ColorFrame.BackgroundTransparency = 0.3
ColorFrame.Parent = AimbotFrame

local ColorCorner = Instance.new("UICorner")
ColorCorner.CornerRadius = UDim.new(0, 15)
ColorCorner.Parent = ColorFrame

local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(1, 0, 0, 40 * UIScale)
ColorLabel.Position = UDim2.new(0, 20, 0, 10)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "Warna ESP:"
ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorLabel.TextSize = 18 * UIScale
ColorLabel.Font = Enum.Font.Gotham
ColorLabel.Parent = ColorFrame

local ColorPicker = Instance.new("TextBox")
ColorPicker.Size = UDim2.new(0.7, 0, 0, 50 * UIScale)
ColorPicker.Position = UDim2.new(0, 20, 0, 50)
ColorPicker.BackgroundColor3 = CurrentColor
ColorPicker.Text = "Cyan"
ColorPicker.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPicker.TextSize = 18 * UIScale
ColorPicker.Font = Enum.Font.GothamBold
ColorPicker.Parent = ColorFrame

local ColorPickerCorner = Instance.new("UICorner")
ColorPickerCorner.CornerRadius = UDim.new(0, 10)
ColorPickerCorner.Parent = ColorPicker

-- Toggle Button (untuk buka/tutup GUI)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 70 * UIScale, 0, 70 * UIScale)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -35 * UIScale)
ToggleBtn.BackgroundColor3 = CurrentColor
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Image = "rbxassetid://6031280882" -- Ikon menu
ToggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

-- Event Handlers
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
end)

-- Tab switching
ESPTab.MouseButton1Click:Connect(function()
    ESPFrame.Visible = true
    MainFrameFrame.Visible = false
    AimbotFrame.Visible = false
    ESPTab.BackgroundColor3 = CurrentColor
    MainTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    AimbotTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

MainTab.MouseButton1Click:Connect(function()
    ESPFrame.Visible = false
    MainFrameFrame.Visible = true
    AimbotFrame.Visible = false
    ESPTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainTab.BackgroundColor3 = CurrentColor
    AimbotTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

AimbotTab.MouseButton1Click:Connect(function()
    ESPFrame.Visible = false
    MainFrameFrame.Visible = false
    AimbotFrame.Visible = true
    ESPTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    AimbotTab.BackgroundColor3 = CurrentColor
end)

-- Toggle Functions
ESPBoxBtn.Button.MouseButton1Click:Connect(function()
    ESPBox = not ESPBox
    ESPBoxBtn.Button.BackgroundColor3 = ESPBox and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ESPBoxBtn.Button.Text = ESPBox and "ON" or "OFF"
    if ESPBox then ESPEnabled = true else CheckESPStatus() end
end)

ESPNameBtn.Button.MouseButton1Click:Connect(function()
    ESPName = not ESPName
    ESPNameBtn.Button.BackgroundColor3 = ESPName and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ESPNameBtn.Button.Text = ESPName and "ON" or "OFF"
    if ESPName then ESPEnabled = true else CheckESPStatus() end
end)

ESPDistanceBtn.Button.MouseButton1Click:Connect(function()
    ESPDistance = not ESPDistance
    ESPDistanceBtn.Button.BackgroundColor3 = ESPDistance and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ESPDistanceBtn.Button.Text = ESPDistance and "ON" or "OFF"
    if ESPDistance then ESPEnabled = true else CheckESPStatus() end
end)

ESPHealthBtn.Button.MouseButton1Click:Connect(function()
    ESPHealth = not ESPHealth
    ESPHealthBtn.Button.BackgroundColor3 = ESPHealth and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ESPHealthBtn.Button.Text = ESPHealth and "ON" or "OFF"
    if ESPHealth then ESPEnabled = true else CheckESPStatus() end
end)

ESPLineBtn.Button.MouseButton1Click:Connect(function()
    ESPLine = not ESPLine
    ESPLineBtn.Button.BackgroundColor3 = ESPLine and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ESPLineBtn.Button.Text = ESPLine and "ON" or "OFF"
    if ESPLine then ESPEnabled = true else CheckESPStatus() end
end)

FlyBtn.Button.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyBtn.Button.BackgroundColor3 = FlyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    FlyBtn.Button.Text = FlyEnabled and "ON" or "OFF"
    FlyControlFrame.Visible = FlyEnabled
    ToggleFly()
end)

NoclipBtn.Button.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    NoclipBtn.Button.BackgroundColor3 = NoclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    NoclipBtn.Button.Text = NoclipEnabled and "ON" or "OFF"
    ToggleNoclip()
end)

AimbotToggle.Button.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotToggle.Button.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    AimbotToggle.Button.Text = AimbotEnabled and "ON" or "OFF"
end)

TPButton.MouseButton1Click:Connect(function()
    TeleportToPlayer(TPInput.Text)
end)

-- Color Picker
local colors = {
    Merah = Color3.fromRGB(255, 0, 0),
    Hijau = Color3.fromRGB(0, 255, 0),
    Biru = Color3.fromRGB(0, 0, 255),
    Kuning = Color3.fromRGB(255, 255, 0),
    Pink = Color3.fromRGB(255, 0, 255),
    Cyan = Color3.fromRGB(0, 255, 255),
    Orange = Color3.fromRGB(255, 128, 0),
    Ungu = Color3.fromRGB(128, 0, 255)
}

ColorPicker.FocusLost:Connect(function()
    local input = ColorPicker.Text:lower()
    for name, color in pairs(colors) do
        if name:lower():find(input) or input:find(name:lower()) then
            CurrentColor = color
            ColorPicker.BackgroundColor3 = CurrentColor
            ColorPicker.Text = name
            TitleBar.BackgroundColor3 = CurrentColor
            ESPTab.BackgroundColor3 = CurrentColor
            MainTab.BackgroundColor3 = ESPFrame.Visible and CurrentColor or Color3.fromRGB(40, 40, 40)
            AimbotTab.BackgroundColor3 = AimbotFrame.Visible and CurrentColor or Color3.fromRGB(40, 40, 40)
            TPButton.BackgroundColor3 = CurrentColor
            ToggleBtn.BackgroundColor3 = CurrentColor
            break
        end
    end
end)

-- Helper Functions
function CheckESPStatus()
    ESPEnabled = ESPBox or ESPName or ESPDistance or ESPHealth or ESPLine
    if not ESPEnabled then
        for player, objects in pairs(ESPObjects) do
            for _, obj in ipairs(objects) do
                pcall(function() if obj and obj.Parent then obj:Destroy() end end)
            end
        end
        ESPObjects = {}
    end
end

-- Fly Function (FIXED - Bisa terbang bebas)
function ToggleFly()
    if FlyEnabled then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then return end
        
        humanoid.PlatformStand = true
        rootPart.Velocity = Vector3.new(0, 0, 0)
        
        -- Gravity off
        rootPart.Velocity = Vector3.new(0, 0, 0)
        
        task.spawn(function()
            while FlyEnabled and task.wait() do
                local char = LocalPlayer.Character
                if not char or not char.Parent then break end
                
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Maintain altitude if no input
                    if root.Velocity.Y > -0.1 and root.Velocity.Y < 0.1 then
                        root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    end
                end
            end
        end)
    else
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.PlatformStand = false
            end
            if rootPart then
                rootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

-- Noclip Function
function ToggleNoclip()
    task.spawn(function()
        while NoclipEnabled and task.wait() do
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

-- Teleport Function
function TeleportToPlayer(playerName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(playerName:lower()) or (player.DisplayName and player.DisplayName:lower():find(playerName:lower())) then
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    return
                end
            end
        end
    end
end

-- ESP Functions with Dotted Style
function CreateESP(player)
    if not player or player == LocalPlayer then return end
    
    local espObjects = {}
    
    -- Box ESP (Dotted style)
    if ESPBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP_Box"
        box.Size = Vector3.new(4, 6, 4)
        box.Transparency = 0.3
        box.Color3 = CurrentColor
        box.ZIndex = 10
        box.AlwaysOnTop = true
        box.Adornee = player.Character
        box.LineThickness = 2 -- Lebih tebal
        box.Parent = player.Character
        table.insert(espObjects, box)
    end
    
    -- Line ESP (Dotted style)
    if ESPLine then
        -- Buat multiple lines untuk efek dotted
        local line = Instance.new("SelectionBox")
        line.Name = "ESP_Line"
        line.LineThickness = 3
        line.Color3 = CurrentColor
        line.Transparency = 0.2
        line.Adornee = player.Character
        line.Parent = player.Character
        table.insert(espObjects, line)
        
        -- Tambah garis dari player ke target
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") then
            local beam = Instance.new("SelectionBox")
            beam.Name = "ESP_Beam"
            beam.LineThickness = 2
            beam.Color3 = CurrentColor
            beam.Transparency = 0.3
            beam.Adornee = char.HumanoidRootPart
            beam.Parent = char
            table.insert(espObjects, beam)
        end
    end
    
    -- Name ESP
    if ESPName then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Name"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = CurrentColor
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextSize = 20
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = billboard
        
        billboard.Parent = player.Character
        table.insert(espObjects, billboard)
    end
    
    ESPObjects[player] = espObjects
end

-- Aimbot
task.spawn(function()
    while task.wait() do
        if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local closestPlayer = nil
            local shortestDistance = math.huge
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local headPos = player.Character.Head.Position
                    local screenPos, onScreen = Camera:WorldToScreenPoint(headPos)
                    
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if distance < shortestDistance and distance < 150 then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
            
            if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
            end
        end
    end
end)

-- Update ESP
task.spawn(function()
    while task.wait() do
        if ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if not ESPObjects[player] then
                        CreateESP(player)
                    end
                    
                    -- Update info
                    for _, obj in ipairs(ESPObjects[player] or {}) do
                        pcall(function()
                            if obj:IsA("BoxHandleAdornment") or obj:IsA("SelectionBox") then
                                obj.Color3 = CurrentColor
                            elseif obj:IsA("BillboardGui") and obj:FindFirstChildOfClass("TextLabel") then
                                local label = obj:FindFirstChildOfClass("TextLabel")
                                label.TextColor3 = CurrentColor
                                local text = player.Name
                                
                                if ESPDistance then
                                    local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                    text = text .. " [" .. math.floor(dist) .. "m]"
                                end
                                
                                if ESPHealth and player.Character:FindFirstChildOfClass("Humanoid") then
                                    local health = player.Character:FindFirstChildOfClass("Humanoid").Health
                                    text = text .. " [" .. math.floor(health) .. "HP]"
                                end
                                
                                label.Text = text
                            end
                        end)
                    end
                elseif ESPObjects[player] then
                    for _, obj in ipairs(ESPObjects[player]) do
                        pcall(function() if obj and obj.Parent then obj:Destroy() end end)
                    end
                    ESPObjects[player] = nil
                end
            end
        end
    end
end)

-- Player Added
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)

-- Notifikasi
local Notif = Instance.new("Frame")
Notif.Size = UDim2.new(0, 400 * UIScale, 0, 80 * UIScale)
Notif.Position = UDim2.new(0.5, -200 * UIScale, 0, 20)
Notif.BackgroundColor3 = CurrentColor
Notif.BackgroundTransparency = 0.1
Notif.Parent = ScreenGui

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 20)
NotifCorner.Parent = Notif

local NotifText = Instance.new("TextLabel")
NotifText.Size = UDim2.new(1, 0, 1, 0)
NotifText.BackgroundTransparency = 1
NotifText.Text = "Putzz Mobile Hub Loaded! Tekan tombol menu"
NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifText.TextSize = 20 * UIScale
NotifText.Font = Enum.Font.GothamBold
NotifText.Parent = Notif

task.wait(3)
Notif:Destroy()

print("✅ Putzz Mobile Hub siap digunakan!")