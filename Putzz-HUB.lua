-- ================== DRIP CLIENT - DELTA EDITION ==================
-- By Putzzdev
-- Support Delta Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Warna
local cyan = Color3.fromRGB(0, 255, 255)
local darkBg = Color3.fromRGB(10, 10, 15)
local grayBg = Color3.fromRGB(25, 25, 35)

-- ================== VARIABEL FITUR ==================
-- Fly
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local bv = nil
local bg = nil
local vert = 0
local horiz = 0
local touching = false
local touchStart = nil

-- Lainnya
local speedEnabled = false
local noclipEnabled = false
local noclipConn = nil
local jumpEnabled = false
local godEnabled = false
local godConn = nil
local spinEnabled = false
local spinConn = nil
local spinDir = 1
local spinSpeed = 200
local crosshairEnabled = false
local crosshairObj = nil
local chamsEnabled = false
local chamsConnections = {}
local chamsData = {}

-- ESP
local espEnabled = false
local espBoxes = {}
local espLines = {}
local espNames = {}
local espHealths = {}

-- ================== FLY FUNCTION ==================
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

-- Touch Control
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

-- ================== NOCLIP ==================
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

-- ================== GOD MODE ==================
local function updateGod()
    if godConn then godConn:Disconnect() end
    godConn = RunService.Heartbeat:Connect(function()
        if godEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        end
    end)
end

-- ================== SPIN ==================
local function updateSpin()
    if spinConn then spinConn:Disconnect() end
    spinConn = RunService.Heartbeat:Connect(function()
        if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * spinDir), 0)
        end
    end)
end

-- ================== INFINITY JUMP ==================
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- ================== CROSSHAIR ==================
local function createCrosshair()
    if crosshairObj then pcall(function() crosshairObj:Destroy() end) end
    local gui = Instance.new("ScreenGui")
    gui.Name = "DripCrosshair"
    gui.Parent = game.CoreGui
    local outer = Instance.new("Frame")
    outer.Parent = gui
    outer.Size = UDim2.new(0, 22, 0, 22)
    outer.Position = UDim2.new(0.5, -11, 0.5, -11)
    outer.BackgroundTransparency = 1
    outer.BorderSizePixel = 2
    outer.BorderColor3 = cyan
    local oc = Instance.new("UICorner")
    oc.Parent = outer
    oc.CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame")
    dot.Parent = gui
    dot.Size = UDim2.new(0, 4, 0, 4)
    dot.Position = UDim2.new(0.5, -2, 0.5, -2)
    dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    dot.BorderSizePixel = 0
    local dc = Instance.new("UICorner")
    dc.Parent = dot
    dc.CornerRadius = UDim.new(1, 0)
    crosshairObj = gui
end

local function removeCrosshair()
    if crosshairObj then pcall(function() crosshairObj:Destroy() end) end
end

-- ================== CHAMS ==================
local function getRainbow()
    local t = tick() * 2 % (math.pi * 2)
    return Color3.new(math.abs(math.sin(t)), math.abs(math.sin(t + 0.5)), math.abs(math.cos(t)))
end

local function applyChams(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    if chamsConnections[player] then chamsConnections[player]:Disconnect() end
    if not chamsData[player] then chamsData[player] = {} end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if not chamsData[player][part] then
                chamsData[player][part] = {Material = part.Material, Transparency = part.Transparency, Color = part.Color}
            end
            part.Material = Enum.Material.Neon
            part.Transparency = 0.35
        end
    end
    
    local conn = RunService.RenderStepped:Connect(function()
        if not chamsEnabled then return end
        if not player or not player.Parent then conn:Disconnect() return end
        local char = player.Character
        if not char then return end
        local col = getRainbow()
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.Color = col
                    part.Material = Enum.Material.Neon
                    part.Transparency = 0.35
                end)
            end
        end
    end)
    chamsConnections[player] = conn
end

local function removeChams(player)
    if chamsConnections[player] then chamsConnections[player]:Disconnect() chamsConnections[player] = nil end
    if chamsData[player] then
        for part, data in pairs(chamsData[player]) do
            if part and part.Parent then
                pcall(function()
                    part.Material = data.Material
                    part.Transparency = data.Transparency
                    part.Color = data.Color
                end)
            end
        end
        chamsData[player] = nil
    end
end

-- ================== ESP ==================
local function updateESP()
    for _, v in pairs(espBoxes) do pcall(function() v:Remove() end) end
    for _, v in pairs(espLines) do pcall(function() v:Remove() end) end
    for _, v in pairs(espNames) do pcall(function() v:Remove() end) end
    for _, v in pairs(espHealths) do pcall(function() v:Remove() end) end
    espBoxes = {}
    espLines = {}
    espNames = {}
    espHealths = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local box = Drawing.new("Square")
            box.Thickness = 2
            box.Color = cyan
            box.Filled = false
            box.Visible = false
            table.insert(espBoxes, box)
            
            local line = Drawing.new("Line")
            line.Thickness = 2
            line.Color = cyan
            line.Visible = false
            table.insert(espLines, line)
            
            local name = Drawing.new("Text")
            name.Size = 13
            name.Color = Color3.fromRGB(255, 255, 255)
            name.Center = true
            name.Outline = true
            name.OutlineColor = Color3.fromRGB(0, 0, 0)
            name.Visible = false
            table.insert(espNames, name)
            
            local health = Drawing.new("Square")
            health.Thickness = 0
            health.Color = Color3.fromRGB(0, 255, 0)
            health.Filled = true
            health.Visible = false
            table.insert(espHealths, health)
        end
    end
end

-- ESP Render
RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for i = 1, #espBoxes do
            espBoxes[i].Visible = false
            espLines[i].Visible = false
            espNames[i].Visible = false
            espHealths[i].Visible = false
        end
        return
    end
    
    local idx = 1
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and myPos then
                local hrp = char.HumanoidRootPart
                local head = char.Head
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                local dist = (myPos - hrp.Position).Magnitude
                
                if vis and dist <= 150 then
                    local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(top.Y - bottom.Y)
                    local width = height / 2
                    
                    espBoxes[idx].Size = Vector2.new(width, height)
                    espBoxes[idx].Position = Vector2.new(pos.X - width/2, top.Y)
                    espBoxes[idx].Visible = true
                    
                    espLines[idx].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    espLines[idx].To = Vector2.new(pos.X, pos.Y)
                    espLines[idx].Visible = true
                    
                    espNames[idx].Position = Vector2.new(pos.X, top.Y - 16)
                    espNames[idx].Text = player.Name .. " [" .. math.floor(dist) .. "m]"
                    espNames[idx].Visible = true
                    
                    if humanoid then
                        local hpPercent = humanoid.Health / humanoid.MaxHealth
                        local barW = width * 0.8
                        local barH = 4
                        local barX = pos.X - barW / 2
                        local barY = top.Y - 22
                        espHealths[idx].Size = Vector2.new(barW * hpPercent, barH)
                        espHealths[idx].Position = Vector2.new(barX, barY)
                        espHealths[idx].Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
                        espHealths[idx].Visible = true
                    end
                else
                    espBoxes[idx].Visible = false
                    espLines[idx].Visible = false
                    espNames[idx].Visible = false
                    espHealths[idx].Visible = false
                end
            else
                espBoxes[idx].Visible = false
                espLines[idx].Visible = false
                espNames[idx].Visible = false
                espHealths[idx].Visible = false
            end
            idx = idx + 1
        end
    end
end)

-- ================== CHARACTER RESPAWN ==================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flyEnabled then startFly() end
    if noclipEnabled then updateNoclip() end
    if speedEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 70 end
    end
    if chamsEnabled then
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then applyChams(p) end end
    end
end)

-- ================== BUAT MENU GUI ==================
task.wait(1)

local gui = Instance.new("ScreenGui")
gui.Name = "DripClient"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 400, 0, 520)
frame.Position = UDim2.new(0.5, -200, 0.5, -260)
frame.BackgroundColor3 = darkBg
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.Parent = frame
frameCorner.CornerRadius = UDim.new(0, 24)

-- Border Glow
local border = Instance.new("Frame")
border.Parent = frame
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = cyan
local borderCorner = Instance.new("UICorner")
borderCorner.Parent = border
borderCorner.CornerRadius = UDim.new(0, 24)

-- Header
local header = Instance.new("Frame")
header.Parent = frame
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = cyan
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
local headerCorner = Instance.new("UICorner")
headerCorner.Parent = header
headerCorner.CornerRadius = UDim.new(0, 24)

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 0.6, 0)
title.Position = UDim2.new(0, 0, 0, 15)
title.BackgroundTransparency = 1
title.Text = "DRIP CLIENT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Center

local subtitle = Instance.new("TextLabel")
subtitle.Parent = header
subtitle.Size = UDim2.new(1, 0, 0.3, 0)
subtitle.Position = UDim2.new(0, 0, 0, 48)
subtitle.BackgroundTransparency = 1
subtitle.Text = "DELTA EDITION | By Putzzdev"
subtitle.TextColor3 = cyan
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Center

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Parent = frame
tabBar.Size = UDim2.new(0.96, 0, 0, 42)
tabBar.Position = UDim2.new(0.02, 0, 0.14, 0)
tabBar.BackgroundColor3 = grayBg
tabBar.BackgroundTransparency = 0.5
tabBar.BorderSizePixel = 0
local tabCorner = Instance.new("UICorner")
tabCorner.Parent = tabBar
tabCorner.CornerRadius = UDim.new(0, 12)

-- Tab buttons
local tabMain = Instance.new("TextButton")
tabMain.Parent = tabBar
tabMain.Size = UDim2.new(0.25, -2, 1, -4)
tabMain.Position = UDim2.new(0, 2, 0, 2)
tabMain.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabMain.BackgroundTransparency = 0.5
tabMain.Text = "MAIN"
tabMain.TextColor3 = Color3.fromRGB(200, 200, 200)
tabMain.Font = Enum.Font.GothamBold
tabMain.TextSize = 12
local tab1Corner = Instance.new("UICorner")
tab1Corner.Parent = tabMain
tab1Corner.CornerRadius = UDim.new(0, 8)

local tabEsp = Instance.new("TextButton")
tabEsp.Parent = tabBar
tabEsp.Size = UDim2.new(0.25, -2, 1, -4)
tabEsp.Position = UDim2.new(0.25, 2, 0, 2)
tabEsp.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabEsp.BackgroundTransparency = 0.5
tabEsp.Text = "ESP"
tabEsp.TextColor3 = Color3.fromRGB(200, 200, 200)
tabEsp.Font = Enum.Font.GothamBold
tabEsp.TextSize = 12
local tab2Corner = Instance.new("UICorner")
tab2Corner.Parent = tabEsp
tab2Corner.CornerRadius = UDim.new(0, 8)

local tabUtil = Instance.new("TextButton")
tabUtil.Parent = tabBar
tabUtil.Size = UDim2.new(0.25, -2, 1, -4)
tabUtil.Position = UDim2.new(0.5, 2, 0, 2)
tabUtil.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabUtil.BackgroundTransparency = 0.5
tabUtil.Text = "UTILITY"
tabUtil.TextColor3 = Color3.fromRGB(200, 200, 200)
tabUtil.Font = Enum.Font.GothamBold
tabUtil.TextSize = 12
local tab3Corner = Instance.new("UICorner")
tab3Corner.Parent = tabUtil
tab3Corner.CornerRadius = UDim.new(0, 8)

local tabInfo = Instance.new("TextButton")
tabInfo.Parent = tabBar
tabInfo.Size = UDim2.new(0.25, -2, 1, -4)
tabInfo.Position = UDim2.new(0.75, 2, 0, 2)
tabInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
tabInfo.BackgroundTransparency = 0.5
tabInfo.Text = "INFO"
tabInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
tabInfo.Font = Enum.Font.GothamBold
tabInfo.TextSize = 12
local tab4Corner = Instance.new("UICorner")
tab4Corner.Parent = tabInfo
tab4Corner.CornerRadius = UDim.new(0, 8)

-- Content containers
local contentMain = Instance.new("ScrollingFrame")
contentMain.Parent = frame
contentMain.Size = UDim2.new(0.94, 0, 0.72, 0)
contentMain.Position = UDim2.new(0.03, 0, 0.22, 0)
contentMain.BackgroundColor3 = grayBg
contentMain.BackgroundTransparency = 0.3
contentMain.BorderSizePixel = 0
contentMain.ScrollBarThickness = 5
contentMain.ScrollBarImageColor3 = cyan
contentMain.CanvasSize = UDim2.new(0, 0, 0, 0)
contentMain.AutomaticCanvasSize = Enum.AutomaticSize.Y
local contentCorner = Instance.new("UICorner")
contentCorner.Parent = contentMain
contentCorner.CornerRadius = UDim.new(0, 12)
local layout1 = Instance.new("UIListLayout")
layout1.Parent = contentMain
layout1.Padding = UDim.new(0, 8)
layout1.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentEsp = Instance.new("ScrollingFrame")
contentEsp.Parent = frame
contentEsp.Size = UDim2.new(0.94, 0, 0.72, 0)
contentEsp.Position = UDim2.new(0.03, 0, 0.22, 0)
contentEsp.BackgroundColor3 = grayBg
contentEsp.BackgroundTransparency = 0.3
contentEsp.BorderSizePixel = 0
contentEsp.ScrollBarThickness = 5
contentEsp.ScrollBarImageColor3 = cyan
contentEsp.CanvasSize = UDim2.new(0, 0, 0, 0)
contentEsp.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentEsp.Visible = false
local espCorner = Instance.new("UICorner")
espCorner.Parent = contentEsp
espCorner.CornerRadius = UDim.new(0, 12)
local layout2 = Instance.new("UIListLayout")
layout2.Parent = contentEsp
layout2.Padding = UDim.new(0, 8)
layout2.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentUtil = Instance.new("ScrollingFrame")
contentUtil.Parent = frame
contentUtil.Size = UDim2.new(0.94, 0, 0.72, 0)
contentUtil.Position = UDim2.new(0.03, 0, 0.22, 0)
contentUtil.BackgroundColor3 = grayBg
contentUtil.BackgroundTransparency = 0.3
contentUtil.BorderSizePixel = 0
contentUtil.ScrollBarThickness = 5
contentUtil.ScrollBarImageColor3 = cyan
contentUtil.CanvasSize = UDim2.new(0, 0, 0, 0)
contentUtil.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentUtil.Visible = false
local utilCorner = Instance.new("UICorner")
utilCorner.Parent = contentUtil
utilCorner.CornerRadius = UDim.new(0, 12)
local layout3 = Instance.new("UIListLayout")
layout3.Parent = contentUtil
layout3.Padding = UDim.new(0, 8)
layout3.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentInfo = Instance.new("Frame")
contentInfo.Parent = frame
contentInfo.Size = UDim2.new(0.94, 0, 0.72, 0)
contentInfo.Position = UDim2.new(0.03, 0, 0.22, 0)
contentInfo.BackgroundColor3 = grayBg
contentInfo.BackgroundTransparency = 0.3
contentInfo.BorderSizePixel = 0
contentInfo.Visible = false
local infoCorner = Instance.new("UICorner")
infoCorner.Parent = contentInfo
infoCorner.CornerRadius = UDim.new(0, 12)

-- Fungsi Toggle
local function createToggle(parent, text, callback)
    local f = Instance.new("Frame")
    f.Parent = parent
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
    return f
end

-- Fungsi Button
local function createButton(parent, text, callback)
    local f = Instance.new("Frame")
    f.Parent = parent
    f.Size = UDim2.new(0.95, 0, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    local fc = Instance.new("UICorner")
    fc.Parent = f
    fc.CornerRadius = UDim.new(0, 10)
    
    local btn = Instance.new("TextButton")
    btn.Parent = f
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.MouseButton1Click:Connect(callback)
    return f
end

-- Slider Fly Speed
local flyFrame = Instance.new("Frame")
flyFrame.Parent = contentMain
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

-- ================== TAB MAIN ==================
createToggle(contentMain, "✈️ FLY MODE", function(s)
    flyEnabled = s
    if s then startFly() else stopFly() end
end)

createToggle(contentMain, "⚡ SPEED BOOST", function(s)
    speedEnabled = s
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = s and 70 or 16 end
end)

createToggle(contentMain, "🌀 NOCLIP", function(s)
    noclipEnabled = s
    if s then updateNoclip() end
end)

createToggle(contentMain, "🦘 INFINITY JUMP", function(s)
    jumpEnabled = s
end)

createToggle(contentMain, "🎯 CROSSHAIR", function(s)
    crosshairEnabled = s
    if s then createCrosshair() else removeCrosshair() end
end)

-- ================== TAB ESP ==================
createToggle(contentEsp, "📦 ESP BOX", function(s)
    espEnabled = s
    if s then updateESP() end
end)

createToggle(contentEsp, "📏 ESP LINE", function(s)
    -- Line sudah termasuk di ESP render
    if not espEnabled and s then
        espEnabled = true
        updateESP()
    end
end)

createToggle(contentEsp, "❤️ HEALTH BAR", function(s)
    -- Health bar sudah termasuk di ESP render
    if not espEnabled and s then
        espEnabled = true
        updateESP()
    end
end)

createToggle(contentEsp, "✨ HOLOGRAM CHAMS", function(s)
    chamsEnabled = s
    if s then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then applyChams(p) end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            removeChams(p)
        end
    end
end)

-- ================== TAB UTILITY ==================
createToggle(contentUtil, "💀 GOD MODE", function(s)
    godEnabled = s
    if s then updateGod() elseif godConn then godConn:Disconnect() end
end)

createToggle(contentUtil, "🌀 SPIN", function(s)
    spinEnabled = s
    if s then updateSpin() elseif spinConn then spinConn:Disconnect() end
end)

createButton(contentUtil, "🔄 GANTI ARAH SPIN", function()
    spinDir = spinDir * -1
end)

-- ================== TAB INFO ==================
local infoText = Instance.new("TextLabel")
infoText.Parent = contentInfo
infoText.Size = UDim2.new(1, 0, 1, 0)
infoText.BackgroundTransparency = 1
infoText.Text = "DRIP CLIENT DELTA EDITION\n\n👨‍💻 DEVELOPER: Putzzdev\n📱 TIKTOK: @Putzz_mvpp\n📞 WHATSAPP: 088976255131\n\n✨ SEMUA FITUR WORKING!\n🔥 THANKS FOR USING!"
infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 13
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Center

-- Tombol Copy
local copyTikTok = Instance.new("TextButton")
copyTikTok.Parent = contentInfo
copyTikTok.Size = UDim2.new(0.8, 0, 0, 40)
copyTikTok.Position = UDim2.new(0.1, 0, 0.65, 0)
copyTikTok.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
copyTikTok.BackgroundTransparency = 0.3
copyTikTok.Text = "📋 COPY TIKTOK"
copyTikTok.TextColor3 = Color3.fromRGB(255, 255, 255)
copyTikTok.Font = Enum.Font.GothamBold
copyTikTok.TextSize = 13
local tikCorner = Instance.new("UICorner")
tikCorner.Parent = copyTikTok
tikCorner.CornerRadius = UDim.new(0, 10)

local copyWA = Instance.new("TextButton")
copyWA.Parent = contentInfo
copyWA.Size = UDim2.new(0.8, 0, 0, 40)
copyWA.Position = UDim2.new(0.1, 0, 0.78, 0)
copyWA.BackgroundColor3 = Color3.fromRGB(37, 211, 102)
copyWA.BackgroundTransparency = 0.3
copyWA.Text = "📋 COPY WHATSAPP"
copyWA.TextColor3 = Color3.fromRGB(255, 255, 255)
copyWA.Font = Enum.Font.GothamBold
copyWA.TextSize = 13
local waCorner = Instance.new("UICorner")
waCorner.Parent = copyWA
waCorner.CornerRadius = UDim.new(0, 10)

copyTikTok.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard("Putzz_mvpp")
            local notif = Instance.new("ScreenGui")
            notif.Parent = game.CoreGui
            local nf = Instance.new("Frame")
            nf.Parent = notif
            nf.Size = UDim2.new(0, 200, 0, 40)
            nf.Position = UDim2.new(0.5, -100, 0.5, -20)
            nf.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            local nc = Instance.new("UICorner")
            nc.Parent = nf
            nc.CornerRadius = UDim.new(0, 10)
            local nt = Instance.new("TextLabel")
            nt.Parent = nf
            nt.Size = UDim2.new(1, 0, 1, 0)
            nt.BackgroundTransparency = 1
            nt.Text = "✅ TikTok disalin!"
            nt.TextColor3 = Color3.fromRGB(255, 255, 255)
            nt.Font = Enum.Font.GothamBold
            nt.TextSize = 14
            task.wait(1.5)
            notif:Destroy()
        end
    end)
end)

copyWA.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard("088976255131")
            local notif = Instance.new("ScreenGui")
            notif.Parent = game.CoreGui
            local nf = Instance.new("Frame")
            nf.Parent = notif
            nf.Size = UDim2.new(0, 200, 0, 40)
            nf.Position = UDim2.new(0.5, -100, 0.5, -20)
            nf.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            local nc = Instance.new("UICorner")
            nc.Parent = nf
            nc.CornerRadius = UDim.new(0, 10)
            local nt = Instance.new("TextLabel")
            nt.Parent = nf
            nt.Size = UDim2.new(1, 0, 1, 0)
            nt.BackgroundTransparency = 1
            nt.Text = "✅ WhatsApp disalin!"
            nt.TextColor3 = Color3.fromRGB(255, 255, 255)
            nt.Font = Enum.Font.GothamBold
            nt.TextSize = 14
            task.wait(1.5)
            notif:Destroy()
        end
    end)
end)

-- Tab selection
tabMain.MouseButton1Click:Connect(function()
    tabMain.BackgroundColor3 = cyan
    tabMain.BackgroundTransparency = 0.3
    tabMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabEsp.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabEsp.BackgroundTransparency = 0.5
    tabEsp.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabUtil.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabUtil.BackgroundTransparency = 0.5
    tabUtil.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabInfo.BackgroundTransparency = 0.5
    tabInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentMain.Visible = true
    contentEsp.Visible = false
    contentUtil.Visible = false
    contentInfo.Visible = false
end)

tabEsp.MouseButton1Click:Connect(function()
    tabEsp.BackgroundColor3 = cyan
    tabEsp.BackgroundTransparency = 0.3
    tabEsp.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabMain.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabMain.BackgroundTransparency = 0.5
    tabMain.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabUtil.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabUtil.BackgroundTransparency = 0.5
    tabUtil.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabInfo.BackgroundTransparency = 0.5
    tabInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentMain.Visible = false
    contentEsp.Visible = true
    contentUtil.Visible = false
    contentInfo.Visible = false
end)

tabUtil.MouseButton1Click:Connect(function()
    tabUtil.BackgroundColor3 = cyan
    tabUtil.BackgroundTransparency = 0.3
    tabUtil.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabMain.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabMain.BackgroundTransparency = 0.5
    tabMain.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabEsp.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabEsp.BackgroundTransparency = 0.5
    tabEsp.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabInfo.BackgroundTransparency = 0.5
    tabInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentMain.Visible = false
    contentEsp.Visible = false
    contentUtil.Visible = true
    contentInfo.Visible = false
end)

tabInfo.MouseButton1Click:Connect(function()
    tabInfo.BackgroundColor3 = cyan
    tabInfo.BackgroundTransparency = 0.3
    tabInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabMain.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabMain.BackgroundTransparency = 0.5
    tabMain.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabEsp.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabEsp.BackgroundTransparency = 0.5
    tabEsp.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabUtil.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabUtil.BackgroundTransparency = 0.5
    tabUtil.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentMain.Visible = false
    contentEsp.Visible = false
    contentUtil.Visible = false
    contentInfo.Visible = true
end)

-- Tombol toggle menu (di pojok kiri)
local menuBtn = Instance.new("TextButton")
menuBtn.Parent = gui
menuBtn.Size = UDim2.new(0, 90, 0, 40)
menuBtn.Position = UDim2.new(0, 10, 0.5, -20)
menuBtn.BackgroundColor3 = cyan
menuBtn.BackgroundTransparency = 0.2
menuBtn.Text = "⚡ DRIP"
menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
menuBtn.Font = Enum.Font.GothamBlack
menuBtn.TextSize = 13
menuBtn.Draggable = true
local menuCorner = Instance.new("UICorner")
menuCorner.Parent = menuBtn
menuCorner.CornerRadius = UDim.new(0, 12)

local menuVisible = true
menuBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
end)

-- Update canvas sizes
task.wait(0.2)
local function updateCanvas(content)
    local h = 0
    for _, child in pairs(content:GetChildren()) do
        if child:IsA("Frame") then h = h + child.Size.Y.Offset + 8 end
    end
    content.CanvasSize = UDim2.new(0, 0, 0, h + 20)
end
updateCanvas(contentMain)
updateCanvas(contentEsp)
updateCanvas(contentUtil)

-- Notifikasi sukses
local notifGui = Instance.new("ScreenGui")
notifGui.Parent = game.CoreGui
local nf = Instance.new("Frame")
nf.Parent = notifGui
nf.Size = UDim2.new(0, 320, 0, 55)
nf.Position = UDim2.new(0.5, -160, 0, -80)
nf.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
nf.BackgroundTransparency = 0.1
local ncorner = Instance.new("UICorner")
ncorner.Parent = nf
ncorner.CornerRadius = UDim.new(0, 12)
local nt = Instance.new("TextLabel")
nt.Parent = nf
nt.Size = UDim2.new(1, 0, 1, 0)
nt.BackgroundTransparency = 1
nt.Text = "✅ DRIP CLIENT ACTIVATED! Klik DRIP di pojok kiri"
nt.TextColor3 = Color3.fromRGB(255, 255, 255)
nt.Font = Enum.Font.GothamBold
nt.TextSize = 13
TweenService:Create(nf, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -160, 0, 20)}):Play()
task.wait(3)
TweenService:Create(nf, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -160, 0, -80)}):Play()
task.wait(0.5)
notifGui:Destroy()

print("✅ DRIP CLIENT - DELTA EDITION READY!")