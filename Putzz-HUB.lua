-- ================== DRIP CLIENT - DELTA FINAL ==================
-- By Putzzdev - PASTI JALAN

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
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local bv = nil
local bg = nil
local vert = 0
local horiz = 0
local touching = false
local touchStart = nil
local speedEnabled = false
local noclipEnabled = false
local noclipConn = nil
local jumpEnabled = false
local godEnabled = false
local godConn = nil

-- ================== FLY ==================
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    if not torso then return end
    if torso:FindFirstChild("FlyBV") then torso.FlyBV:Destroy() end
    if torso:FindFirstChild("FlyBG") then torso.FlyBG:Destroy() end
    bv = Instance.new("BodyVelocity")
    bv.Name = "FlyBV"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = torso
    bg = Instance.new("BodyGyro")
    bg.Name = "FlyBG"
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.Parent = torso
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end
    if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled then return end
        local ct = LocalPlayer.Character
        if not ct then return end
        local t = ct:FindFirstChild("UpperTorso") or ct:FindFirstChild("Torso") or ct:FindFirstChild("HumanoidRootPart")
        if not t then return end
        local b = t:FindFirstChild("FlyBV")
        local g = t:FindFirstChild("FlyBG")
        if not b or not g then return end
        local cf = Camera.CFrame
        local f = cf.LookVector
        local r = cf.RightVector
        local u = cf.UpVector
        local dir = f
        if horiz ~= 0 then
            local ang = horiz * 0.5
            dir = (f * math.cos(ang) + r * math.sin(ang)).Unit
        end
        b.Velocity = (dir * flySpeed) + (u * vert * flySpeed * 0.7)
        g.CFrame = cf
    end)
end

local function stopFly()
    flyEnabled = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
        if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
        local t = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        if t then
            if t:FindFirstChild("FlyBV") then t.FlyBV:Destroy() end
            if t:FindFirstChild("FlyBG") then t.FlyBG:Destroy() end
        end
    end
    vert = 0
    horiz = 0
end

-- TOUCH
UserInputService.TouchBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        touching = true
        touchStart = input.Position
    end
end)
UserInputService.TouchMoved:Connect(function(input, gp)
    if gp then return end
    if not flyEnabled then return end
    if touching and touchStart then
        local d = input.Position - touchStart
        vert = math.abs(d.Y) > 15 and (d.Y < 0 and 1 or -1) or 0
        horiz = math.abs(d.X) > 15 and (d.X < 0 and -1 or 1) or 0
        touchStart = input.Position
    end
end)
UserInputService.TouchEnded:Connect(function()
    touching = false
    vert = 0
    horiz = 0
end)

-- NOCLIP
local function updateNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end

-- GOD MODE
local function updateGod()
    if godConn then godConn:Disconnect() end
    godConn = RunService.Heartbeat:Connect(function()
        if godEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        end
    end)
end

-- INFINITY JUMP
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- RESPAWN HANDLER
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flyEnabled then startFly() end
    if noclipEnabled then updateNoclip() end
    if speedEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 70 end
    end
end)

-- ================== BUAT MENU (SEDERHANA) ==================
task.wait(1)

local gui = Instance.new("ScreenGui")
gui.Name = "DripClient"
gui.Parent = game.CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = darkBg
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = frame
corner.CornerRadius = UDim.new(0, 20)

local border = Instance.new("Frame")
border.Parent = frame
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = cyan
local borderCorner = Instance.new("UICorner")
borderCorner.Parent = border
borderCorner.CornerRadius = UDim.new(0, 20)

-- Header
local header = Instance.new("Frame")
header.Parent = frame
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = cyan
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
local headerCorner = Instance.new("UICorner")
headerCorner.Parent = header
headerCorner.CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DRIP CLIENT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18

-- Content ScrollingFrame
local content = Instance.new("ScrollingFrame")
content.Parent = frame
content.Size = UDim2.new(0.94, 0, 0.76, 0)
content.Position = UDim2.new(0.03, 0, 0.16, 0)
content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = cyan
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
local contentCorner = Instance.new("UICorner")
contentCorner.Parent = content
contentCorner.CornerRadius = UDim.new(0, 12)

local layout = Instance.new("UIListLayout")
layout.Parent = content
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Fungsi Toggle
local function addToggle(text, callback)
    local f = Instance.new("Frame")
    f.Parent = content
    f.Size = UDim2.new(0.95, 0, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    local fc = Instance.new("UICorner")
    fc.Parent = f
    fc.CornerRadius = UDim.new(0, 10)
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = f
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0.05, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local sw = Instance.new("Frame")
    sw.Parent = f
    sw.Size = UDim2.new(0, 45, 0, 23)
    sw.Position = UDim2.new(0.82, 0, 0.5, -11.5)
    sw.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sw.BorderSizePixel = 0
    local swc = Instance.new("UICorner")
    swc.Parent = sw
    swc.CornerRadius = UDim.new(0, 12)
    
    local circle = Instance.new("Frame")
    circle.Parent = sw
    circle.Size = UDim2.new(0, 19, 0, 19)
    circle.Position = UDim2.new(0.05, 0, 0.5, -9.5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    local circ = Instance.new("UICorner")
    circ.Parent = circle
    circ.CornerRadius = UDim.new(1, 0)
    
    local state = false
    local btn = Instance.new("TextButton")
    btn.Parent = f
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = state and cyan or Color3.fromRGB(60, 60, 70)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -21, 0.5, -9.5) or UDim2.new(0.05, 0, 0.5, -9.5)}):Play()
        callback(state)
    end)
end

-- Slider Fly Speed
local flyFrame = Instance.new("Frame")
flyFrame.Parent = content
flyFrame.Size = UDim2.new(0.95, 0, 0, 55)
flyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
flyFrame.BackgroundTransparency = 0.2
flyFrame.BorderSizePixel = 0
local flyCorner = Instance.new("UICorner")
flyCorner.Parent = flyFrame
flyCorner.CornerRadius = UDim.new(0, 10)

local flyLabel = Instance.new("TextLabel")
flyLabel.Parent = flyFrame
flyLabel.Size = UDim2.new(0.45, 0, 1, 0)
flyLabel.Position = UDim2.new(0.05, 0, 0, 0)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "🚀 Fly Speed: 50"
flyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyLabel.Font = Enum.Font.Gotham
flyLabel.TextSize = 12
flyLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderBar = Instance.new("Frame")
sliderBar.Parent = flyFrame
sliderBar.Size = UDim2.new(0.35, 0, 0, 5)
sliderBar.Position = UDim2.new(0.55, 0, 0.5, -2.5)
sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
sliderBar.BorderSizePixel = 0
local barCorner = Instance.new("UICorner")
barCorner.Parent = sliderBar
barCorner.CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame")
sliderFill.Parent = sliderBar
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = cyan
sliderFill.BorderSizePixel = 0
local fillCorner = Instance.new("UICorner")
fillCorner.Parent = sliderFill
fillCorner.CornerRadius = UDim.new(1, 0)

local sliderBtn = Instance.new("TextButton")
sliderBtn.Parent = sliderBar
sliderBtn.Size = UDim2.new(0, 16, 0, 16)
sliderBtn.Position = UDim2.new(0.5, -8, 0.5, -8)
sliderBtn.BackgroundColor3 = cyan
sliderBtn.BorderSizePixel = 0
sliderBtn.Text = ""
local btnCorner = Instance.new("UICorner")
btnCorner.Parent = sliderBtn
btnCorner.CornerRadius = UDim.new(1, 0)

local dragging = false
sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local barPos = sliderBar.AbsolutePosition.X
        local barW = sliderBar.AbsoluteSize.X
        local percent = math.clamp((input.Position.X - barPos) / barW, 0, 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderBtn.Position = UDim2.new(percent, -8, 0.5, -8)
        flySpeed = math.floor(percent * 80 + 20)
        flyLabel.Text = "🚀 Fly Speed: " .. flySpeed
    end
end)

-- ================== TAMBAH FITUR ==================
addToggle("✈️ FLY MODE", function(s)
    flyEnabled = s
    if s then startFly() else stopFly() end
end)

addToggle("⚡ SPEED BOOST", function(s)
    speedEnabled = s
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = s and 70 or 16 end
end)

addToggle("🌀 NOCLIP", function(s)
    noclipEnabled = s
    if s then updateNoclip() end
end)

addToggle("🦘 INFINITY JUMP", function(s)
    jumpEnabled = s
end)

addToggle("💀 GOD MODE", function(s)
    godEnabled = s
    if s then updateGod() elseif godConn then godConn:Disconnect() end
end)

-- Info text
local infoFrame = Instance.new("Frame")
infoFrame.Parent = content
infoFrame.Size = UDim2.new(0.95, 0, 0, 100)
infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
infoFrame.BackgroundTransparency = 0.2
infoFrame.BorderSizePixel = 0
local infoCorner = Instance.new("UICorner")
infoCorner.Parent = infoFrame
infoCorner.CornerRadius = UDim.new(0, 10)

local infoText = Instance.new("TextLabel")
infoText.Parent = infoFrame
infoText.Size = UDim2.new(1, 0, 1, 0)
infoText.BackgroundTransparency = 1
infoText.Text = "DRIP CLIENT\n\n👨‍💻 Putzzdev\n📱 TikTok: @Putzz_mvpp"
infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 12
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Center

-- Tombol toggle menu
local menuBtn = Instance.new("TextButton")
menuBtn.Parent = gui
menuBtn.Size = UDim2.new(0, 80, 0, 35)
menuBtn.Position = UDim2.new(0, 10, 0.5, -17)
menuBtn.BackgroundColor3 = cyan
menuBtn.BackgroundTransparency = 0.2
menuBtn.Text = "⚡ MENU"
menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
menuBtn.Font = Enum.Font.GothamBlack
menuBtn.TextSize = 12
menuBtn.Draggable = true
local menuCorner = Instance.new("UICorner")
menuCorner.Parent = menuBtn
menuCorner.CornerRadius = UDim.new(0, 10)

local menuVisible = true
menuBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
end)

-- Notifikasi
local notif = Instance.new("ScreenGui")
notif.Parent = game.CoreGui
local nf = Instance.new("Frame")
nf.Parent = notif
nf.Size = UDim2.new(0, 280, 0, 50)
nf.Position = UDim2.new(0.5, -140, 0, -80)
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
TweenService:Create(nf, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -140, 0, 20)}):Play()
task.wait(2.5)
TweenService:Create(nf, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -140, 0, -80)}):Play()
task.wait(0.5)
notif:Destroy()

print("✅ DRIP CLIENT READY!")