-- ================== DRIP CLIENT - ESP LINE + GUI ==================
-- By Putzzdev
-- Bisa ON/OFF dari tombol

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Warna
local cyan = Color3.fromRGB(0, 255, 255)
local darkBg = Color3.fromRGB(10, 10, 15)

-- ================== VARIABEL ==================
local espEnabled = true  -- Default ON
local lines = {}

-- ================== FUNGSI ESP LINE ==================
local function createLine(player)
    if player == LocalPlayer then return end
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = cyan
    line.Visible = false
    lines[player] = line
end

local function removeLine(player)
    if lines[player] then
        lines[player]:Remove()
        lines[player] = nil
    end
end

local function updateAllLines()
    for player, line in pairs(lines) do
        line.Visible = espEnabled
    end
end

-- Render ESP
RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for _, line in pairs(lines) do
            line.Visible = false
        end
        return
    end
    
    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position
    
    for player, line in pairs(lines) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and myPos then
            local hrp = char.HumanoidRootPart
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
            local distance = (myPos - hrp.Position).Magnitude
            
            if visible and distance <= 150 then
                local fromX = Camera.ViewportSize.X / 2
                local fromY = 0
                line.From = Vector2.new(fromX, fromY)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end)

-- Inisialisasi player
for _, player in pairs(Players:GetPlayers()) do
    createLine(player)
end

Players.PlayerAdded:Connect(function(player)
    createLine(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeLine(player)
end)

-- ================== BUAT GUI SEDERHANA ==================
task.wait(1)

local gui = Instance.new("ScreenGui")
gui.Name = "DripClient"
gui.Parent = game.CoreGui

-- Tombol toggle menu (di pojok kiri)
local menuBtn = Instance.new("TextButton")
menuBtn.Parent = gui
menuBtn.Size = UDim2.new(0, 80, 0, 40)
menuBtn.Position = UDim2.new(0, 10, 0.5, -20)
menuBtn.BackgroundColor3 = cyan
menuBtn.BackgroundTransparency = 0.2
menuBtn.Text = "⚡ MENU"
menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
menuBtn.Font = Enum.Font.GothamBlack
menuBtn.TextSize = 13
menuBtn.Draggable = true

local menuCorner = Instance.new("UICorner")
menuCorner.Parent = menuBtn
menuCorner.CornerRadius = UDim.new(0, 12)

-- Frame menu (awalnya muncul)
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = darkBg
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.Parent = frame
frameCorner.CornerRadius = UDim.new(0, 16)

local border = Instance.new("Frame")
border.Parent = frame
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = cyan
local borderCorner = Instance.new("UICorner")
borderCorner.Parent = border
borderCorner.CornerRadius = UDim.new(0, 16)

-- Header
local header = Instance.new("Frame")
header.Parent = frame
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = cyan
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
local headerCorner = Instance.new("UICorner")
headerCorner.Parent = header
headerCorner.CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DRIP CLIENT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18

-- Konten
local content = Instance.new("Frame")
content.Parent = frame
content.Size = UDim2.new(0.94, 0, 0.6, 0)
content.Position = UDim2.new(0.03, 0, 0.12, 0)
content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
local contentCorner = Instance.new("UICorner")
contentCorner.Parent = content
contentCorner.CornerRadius = UDim.new(0, 10)

-- Toggle ESP
local toggleFrame = Instance.new("Frame")
toggleFrame.Parent = content
toggleFrame.Size = UDim2.new(0.95, 0, 0, 45)
toggleFrame.Position = UDim2.new(0.025, 0, 0, 10)
toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
toggleFrame.BackgroundTransparency = 0.2
toggleFrame.BorderSizePixel = 0
local tfCorner = Instance.new("UICorner")
tfCorner.Parent = toggleFrame
tfCorner.CornerRadius = UDim.new(0, 10)

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Parent = toggleFrame
toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
toggleLabel.Position = UDim2.new(0.05, 0, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "📏 ESP LINE"
toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleLabel.Font = Enum.Font.Gotham
toggleLabel.TextSize = 13
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

local switch = Instance.new("Frame")
switch.Parent = toggleFrame
switch.Size = UDim2.new(0, 45, 0, 23)
switch.Position = UDim2.new(0.82, 0, 0.5, -11.5)
switch.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
switch.BorderSizePixel = 0
local swCorner = Instance.new("UICorner")
swCorner.Parent = switch
swCorner.CornerRadius = UDim.new(0, 12)

local circle = Instance.new("Frame")
circle.Parent = switch
circle.Size = UDim2.new(0, 19, 0, 19)
circle.Position = UDim2.new(0.05, 0, 0.5, -9.5)
circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle.BorderSizePixel = 0
local circCorner = Instance.new("UICorner")
circCorner.Parent = circle
circCorner.CornerRadius = UDim.new(1, 0)

-- State toggle (ON karena espEnabled = true)
switch.BackgroundColor3 = cyan
circle.Position = UDim2.new(1, -21, 0.5, -9.5)

local btn = Instance.new("TextButton")
btn.Parent = toggleFrame
btn.Size = UDim2.new(1, 0, 1, 0)
btn.BackgroundTransparency = 1
btn.Text = ""
btn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = cyan}):Play()
        TweenService:Create(circle, TweenInfo.new(0.15), {Position = UDim2.new(1, -21, 0.5, -9.5)}):Play()
    else
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.15), {Position = UDim2.new(0.05, 0, 0.5, -9.5)}):Play()
    end
    updateAllLines()
end)

-- Info kecil
local infoText = Instance.new("TextLabel")
infoText.Parent = content
infoText.Size = UDim2.new(0.95, 0, 0, 35)
infoText.Position = UDim2.new(0.025, 0, 0, 65)
infoText.BackgroundTransparency = 1
infoText.Text = "By Putzzdev | TikTok: @Putzz_mvpp"
infoText.TextColor3 = Color3.fromRGB(150, 150, 150)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 10
infoText.TextXAlignment = Enum.TextXAlignment.Center

-- Tombol toggle menu (buka/tutup)
local menuVisible = true
menuBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
end)

-- Notifikasi awal
local notif = Instance.new("ScreenGui")
notif.Parent = game.CoreGui
local nf = Instance.new("Frame")
nf.Parent = notif
nf.Size = UDim2.new(0, 260, 0, 45)
nf.Position = UDim2.new(0.5, -130, 0, -80)
nf.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
nf.BackgroundTransparency = 0.1
local ncorner = Instance.new("UICorner")
ncorner.Parent = nf
ncorner.CornerRadius = UDim.new(0, 12)
local nt = Instance.new("TextLabel")
nt.Parent = nf
nt.Size = UDim2.new(1, 0, 1, 0)
nt.BackgroundTransparency = 1
nt.Text = "✅ DRIP CLIENT READY! Klik MENU"
nt.TextColor3 = Color3.fromRGB(255, 255, 255)
nt.Font = Enum.Font.GothamBold
nt.TextSize = 13
TweenService:Create(nf, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -130, 0, 20)}):Play()
task.wait(2.5)
TweenService:Create(nf, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -130, 0, -80)}):Play()
task.wait(0.5)
notif:Destroy()

print("✅ DRIP CLIENT - ESP LINE + GUI READY!")