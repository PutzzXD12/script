-- ================== AINCRAD MENU V1 ==================
-- By Putzzdev
-- LANGSUNG MUNCUL, TANPA KEY

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Warna Tema (Hitam + Cyan)
local themeColor = Color3.fromRGB(0, 255, 255) -- Cyan
local darkColor = Color3.fromRGB(15, 15, 20) -- Hitam gelap
local bgColor = Color3.fromRGB(25, 25, 35)

-- ================== VARIABEL FITUR ==================
-- Fly
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyBodyVel = nil
local flyBodyGyro = nil
local verticalControl = 0
local horizontalControl = 0
local touching = false
local touchStart = nil

-- Lainnya
local speedEnabled = false
local noclipEnabled = false
local noclipConnection = nil
local infinityJumpEnabled = false
local crosshairEnabled = false
local crosshairObject = nil
local spinEnabled = false
local spinConnection = nil
local spinDir = 1
local spinSpeed = 200
local antiDamageEnabled = false
local antiDamageHeartbeat = nil

-- ESP
local espEnabled = false
local lineEnabled = false
local healthEnabled = false
local skeletonEnabled = false
local ESPTable = {}
local SkeletonESP = {}
local playerCounterEnabled = false
local enemyCountText = nil
local MAX_ESP_DISTANCE = 115

-- Chams
local chamsEnabled = false
local chamsTransparency = 0.35
local chamsMaterial = Enum.Material.Neon
local colorSpeed = 2
local originalChams = {}
local chamsConnections = {}

-- ================== FLY FUNGSI ==================
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    if not torso then return end
    
    if torso:FindFirstChild("FlyBV") then torso.FlyBV:Destroy() end
    if torso:FindFirstChild("FlyBG") then torso.FlyBG:Destroy() end
    
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.Name = "FlyBV"
    flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVel.Parent = torso
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.Name = "FlyBG"
    flyBodyGyro.P = 9e4
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.Parent = torso
    
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
        local bv = t:FindFirstChild("FlyBV")
        local bg = t:FindFirstChild("FlyBG")
        if not bv or not bg then return end
        
        local cf = Camera.CFrame
        local f = cf.LookVector
        local r = cf.RightVector
        local u = cf.UpVector
        local dir = f
        if horizontalControl ~= 0 then
            local ang = horizontalControl * 0.5
            dir = (f * math.cos(ang) + r * math.sin(ang)).Unit
        end
        bv.Velocity = (dir * flySpeed) + (u * verticalControl * flySpeed * 0.7)
        bg.CFrame = cf
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
    verticalControl = 0
    horizontalControl = 0
end

-- Touch control
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
        verticalControl = math.abs(d.Y) > 15 and (d.Y < 0 and 1 or -1) or 0
        horizontalControl = math.abs(d.X) > 15 and (d.X < 0 and -1 or 1) or 0
        touchStart = input.Position
    end
end)

UserInputService.TouchEnded:Connect(function()
    touching = false
    verticalControl = 0
    horizontalControl = 0
end)

-- ================== NOCLIP ==================
local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- ================== SPIN ==================
local function toggleSpin(state)
    spinEnabled = state
    if spinConnection then spinConnection:Disconnect() end
    if state then
        spinConnection = RunService.Heartbeat:Connect(function()
            if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * spinDir), 0)
            end
        end)
    end
end

local function toggleSpinDir() spinDir = spinDir * -1 end

-- ================== GOD MODE ==================
local function setupAntiDamage()
    if antiDamageHeartbeat then antiDamageHeartbeat:Disconnect() end
    antiDamageHeartbeat = RunService.Heartbeat:Connect(function()
        if antiDamageEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        end
    end)
end

-- ================== CROSSHAIR ==================
local function createCrosshair()
    if crosshairObject then pcall(function() crosshairObject:Destroy() end) end
    local gui = Instance.new("ScreenGui")
    gui.Name = "AincradCrosshair"
    gui.Parent = game.CoreGui
    local outer = Instance.new("Frame")
    outer.Parent = gui
    outer.Size = UDim2.new(0, 22, 0, 22)
    outer.Position = UDim2.new(0.5, -11, 0.5, -11)
    outer.BackgroundTransparency = 1
    outer.BorderSizePixel = 2
    outer.BorderColor3 = Color3.fromRGB(0, 255, 255)
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
    crosshairObject = gui
end

local function removeCrosshair()
    if crosshairObject then pcall(function() crosshairObject:Destroy() end) end
end

-- ================== CHAMS ==================
local function getRainbow()
    local t = tick() * colorSpeed % (math.pi * 2)
    return Color3.new(math.abs(math.sin(t)), math.abs(math.sin(t + 0.5)), math.abs(math.cos(t)))
end

local function applyChams(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    if chamsConnections[player] then chamsConnections[player]:Disconnect() end
    if not originalChams[player] then originalChams[player] = {} end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if not originalChams[player][part] then
                originalChams[player][part] = {Material = part.Material, Transparency = part.Transparency, Color = part.Color}
            end
            part.Material = chamsMaterial
            part.Transparency = chamsTransparency
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
                    part.Material = chamsMaterial
                    part.Transparency = chamsTransparency
                end)
            end
        end
    end)
    chamsConnections[player] = conn
end

local function removeChams(player)
    if chamsConnections[player] then chamsConnections[player]:Disconnect() chamsConnections[player] = nil end
    if originalChams[player] then
        for part, data in pairs(originalChams[player]) do
            if part and part.Parent then
                pcall(function() part.Material = data.Material part.Transparency = data.Transparency part.Color = data.Color end)
            end
        end
        originalChams[player] = nil
    end
end

-- ================== ESP ==================
local function createESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0, 255, 255)
    box.Filled = false
    box.Visible = false
    local name = Drawing.new("Text")
    name.Size = 14
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Center = true
    name.Outline = true
    name.OutlineColor = Color3.fromRGB(0, 0, 0)
    name.Visible = false
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = Color3.fromRGB(0, 255, 255)
    line.Visible = false
    local healthBg = Drawing.new("Square")
    healthBg.Thickness = 1
    healthBg.Color = Color3.fromRGB(30, 30, 30)
    healthBg.Filled = true
    healthBg.Visible = false
    local healthFg = Drawing.new("Square")
    healthFg.Thickness = 0
    healthFg.Color = Color3.fromRGB(0, 255, 0)
    healthFg.Filled = true
    healthFg.Visible = false
    ESPTable[player] = {box, name, line, healthBg, healthFg}
end

-- Player counter
local function createPlayerCounter()
    if enemyCountText then pcall(function() enemyCountText:Remove() end) end
    enemyCountText = Drawing.new("Text")
    enemyCountText.Size = 22
    enemyCountText.Color = themeColor
    enemyCountText.Center = true
    enemyCountText.Outline = true
    enemyCountText.OutlineColor = Color3.fromRGB(0, 0, 0)
    enemyCountText.Position = Vector2.new(Camera.ViewportSize.X / 2, 50)
    enemyCountText.Visible = false
    enemyCountText.Text = "👥 PLAYER: 0"
end

local function updatePlayerCounter()
    if not playerCounterEnabled or not enemyCountText then return end
    local count = 0
    for player, _ in pairs(ESPTable) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
            local hrp = char.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            if vis then count = count + 1 end
        end
    end
    enemyCountText.Text = "👥 PLAYER: " .. count
    enemyCountText.Visible = playerCounterEnabled
    enemyCountText.Position = Vector2.new(Camera.ViewportSize.X / 2, 50)
end

-- Render ESP
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position
    for player, esp in pairs(ESPTable) do
        local box, name, line, healthBg, healthFg = unpack(esp)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local hrp = char.HumanoidRootPart
            local head = char.Head
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
            local dist = myPos and (myPos - hrp.Position).Magnitude or math.huge
            if visible and dist <= MAX_ESP_DISTANCE then
                local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(top.Y - bottom.Y)
                local width = height / 2
                if espEnabled then
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width/2, top.Y)
                    box.Visible = true
                    name.Position = Vector2.new(pos.X, top.Y - 16)
                    name.Text = player.Name
                    name.Visible = true
                else
                    box.Visible = false
                    name.Visible = false
                end
                if healthEnabled and humanoid then
                    local hpPercent = humanoid.Health / humanoid.MaxHealth
                    local barW = width * 0.8
                    local barH = 4
                    local barX = pos.X - barW / 2
                    local barY = top.Y - 22
                    healthBg.Size = Vector2.new(barW, barH)
                    healthBg.Position = Vector2.new(barX, barY)
                    healthBg.Visible = true
                    healthFg.Size = Vector2.new(barW * hpPercent, barH)
                    healthFg.Position = Vector2.new(barX, barY)
                    healthFg.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
                    healthFg.Visible = true
                else
                    healthBg.Visible = false
                    healthFg.Visible = false
                end
                if lineEnabled then
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                box.Visible = false
                name.Visible = false
                line.Visible = false
                healthBg.Visible = false
                healthFg.Visible = false
            end
        end
    end
    if playerCounterEnabled then updatePlayerCounter() elseif enemyCountText then enemyCountText.Visible = false end
end)

-- Inisialisasi ESP
for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(p)
    if ESPTable[p] then
        for _, d in pairs(ESPTable[p]) do pcall(function() if d and d.Remove then d:Remove() end end) end
        ESPTable[p] = nil
    end
end)

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if infinityJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flyEnabled then startFly() end
    if noclipEnabled then startNoclip() end
    if speedEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 70 end
    end
    if chamsEnabled then
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then applyChams(p) end end
    end
end)

-- ================== BUAT MENU ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AincradMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = ScreenGui
mainFrame.Size = UDim2.new(0, 380, 0, 480)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
mainFrame.BackgroundColor3 = darkColor
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 20)

local border = Instance.new("Frame")
border.Parent = mainFrame
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = themeColor
local borderCorner = Instance.new("UICorner")
borderCorner.Parent = border
borderCorner.CornerRadius = UDim.new(0, 20)

local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = themeColor
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
local headerCorner = Instance.new("UICorner")
headerCorner.Parent = header
headerCorner.CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "AINCRAD MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20

local subtitle = Instance.new("TextLabel")
subtitle.Parent = header
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "By Putzzdev"
subtitle.TextColor3 = themeColor
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.Size = UDim2.new(0.96, 0, 0, 38)
tabBar.Position = UDim2.new(0.02, 0, 0.14, 0)
tabBar.BackgroundColor3 = bgColor
tabBar.BackgroundTransparency = 0.5
tabBar.BorderSizePixel = 0
local tabBarCorner = Instance.new("UICorner")
tabBarCorner.Parent = tabBar
tabBarCorner.CornerRadius = UDim.new(0, 10)

local tabs = {}
local contents = {}

local function createTab(name, idx)
    local btn = Instance.new("TextButton")
    btn.Parent = tabBar
    btn.Size = UDim2.new(0.25, -2, 1, -4)
    btn.Position = UDim2.new((idx-1)*0.25, 2, 0, 2)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BackgroundTransparency = 0.5
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(0.94, 0, 0.74, 0)
    content.Position = UDim2.new(0.03, 0, 0.22, 0)
    content.BackgroundColor3 = bgColor
    content.BackgroundTransparency = 0.3
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 5
    content.ScrollBarImageColor3 = themeColor
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Visible = false
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    local contentCorner = Instance.new("UICorner")
    contentCorner.Parent = content
    contentCorner.CornerRadius = UDim.new(0, 12)
    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    table.insert(tabs, btn)
    table.insert(contents, content)
    
    btn.MouseButton1Click:Connect(function()
        for i, b in ipairs(tabs) do
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
            b.BackgroundTransparency = 0.5
            contents[i].Visible = false
        end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.2
        content.Visible = true
        task.wait()
        local h = 0
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("Frame") then h = h + child.Size.Y.Offset + 8 end
        end
        content.CanvasSize = UDim2.new(0, 0, 0, h + 20)
    end)
    return content
end

local tabMain = createTab("MAIN", 1)
local tabEsp = createTab("ESP", 2)
local tabUtil = createTab("UTILITY", 3)
local tabInfo = createTab("INFO", 4)

-- Fungsi Toggle
local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.95, 0, 0, 42)
    frame.BackgroundColor3 = bgColor
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 10)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local switch = Instance.new("Frame")
    switch.Parent = frame
    switch.Size = UDim2.new(0, 44, 0, 22)
    switch.Position = UDim2.new(0.82, 0, 0.5, -11)
    switch.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    switch.BorderSizePixel = 0
    local swCorner = Instance.new("UICorner")
    swCorner.Parent = switch
    swCorner.CornerRadius = UDim.new(0, 11)
    
    local circle = Instance.new("Frame")
    circle.Parent = switch
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0.05, 0, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    local circCorner = Instance.new("UICorner")
    circCorner.Parent = circle
    circCorner.CornerRadius = UDim.new(1, 0)
    
    local state = false
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = state and themeColor or Color3.fromRGB(60, 60, 70)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0.05, 0, 0.5, -9)}):Play()
        callback(state)
    end)
    return frame
end

local function createButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.95, 0, 0, 42)
    frame.BackgroundColor3 = bgColor
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 10)
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.MouseButton1Click:Connect(callback)
    return frame
end

-- Slider Fly Speed
local flyFrame = Instance.new("Frame")
flyFrame.Parent = tabMain
flyFrame.Size = UDim2.new(0.95, 0, 0, 50)
flyFrame.BackgroundColor3 = bgColor
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
sliderFill.BackgroundColor3 = themeColor
sliderFill.BorderSizePixel = 0
local fillCorner = Instance.new("UICorner")
fillCorner.Parent = sliderFill
fillCorner.CornerRadius = UDim.new(1, 0)

local sliderBtn = Instance.new("TextButton")
sliderBtn.Parent = sliderBar
sliderBtn.Size = UDim2.new(0, 16, 0, 16)
sliderBtn.Position = UDim2.new(0.5, -8, 0.5, -8)
sliderBtn.BackgroundColor3 = themeColor
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
createToggle(tabMain, "✈️ FLY MODE", function(s)
    flyEnabled = s
    if s then startFly() else stopFly() end
end)

createToggle(tabMain, "⚡ SPEED BOOST", function(s)
    speedEnabled = s
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = s and 70 or 16 end
end)

createToggle(tabMain, "🌀 NOCLIP", function(s)
    noclipEnabled = s
    if s then startNoclip() else stopNoclip() end
end)

createToggle(tabMain, "🦘 INFINITY JUMP", function(s)
    infinityJumpEnabled = s
end)

createToggle(tabMain, "🎯 CROSSHAIR", function(s)
    if s then createCrosshair() else removeCrosshair() end
end)

-- ================== TAB ESP ==================
createToggle(tabEsp, "📦 ESP BOX", function(s) espEnabled = s end)
createToggle(tabEsp, "📏 ESP LINE", function(s) lineEnabled = s end)
createToggle(tabEsp, "❤️ HEALTH BAR", function(s) healthEnabled = s end)
createToggle(tabEsp, "👥 PLAYER COUNTER", function(s)
    playerCounterEnabled = s
    if s then createPlayerCounter() updatePlayerCounter() elseif enemyCountText then enemyCountText.Visible = false end
end)
createToggle(tabEsp, "✨ HOLOGRAM CHAMS", function(s)
    chamsEnabled = s
    if s then
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then applyChams(p) end end
    else
        for _, p in pairs(Players:GetPlayers()) do removeChams(p) end
    end
end)

-- ================== TAB UTILITY ==================
createToggle(tabUtil, "💀 GOD MODE", function(s)
    antiDamageEnabled = s
    if s then setupAntiDamage() elseif antiDamageHeartbeat then antiDamageHeartbeat:Disconnect() end
end)

createToggle(tabUtil, "🌀 SPIN", function(s) toggleSpin(s) end)
createButton(tabUtil, "🔄 GANTI ARAH SPIN", function() toggleSpinDir() end)

-- ================== TAB INFO ==================
local infoFrame = Instance.new("Frame")
infoFrame.Parent = tabInfo
infoFrame.Size = UDim2.new(0.95, 0, 0, 200)
infoFrame.Position = UDim2.new(0.025, 0, 0, 10)
infoFrame.BackgroundColor3 = bgColor
infoFrame.BackgroundTransparency = 0.3
infoFrame.BorderSizePixel = 0
local infoCorner = Instance.new("UICorner")
infoCorner.Parent = infoFrame
infoCorner.CornerRadius = UDim.new(0, 12)

local infoText = Instance.new("TextLabel")
infoText.Parent = infoFrame
infoText.Size = UDim2.new(1, 0, 1, 0)
infoText.BackgroundTransparency = 1
infoText.Text = "AINCRAD MENU V1\n\n👨‍💻 DEVELOPER: Putzzdev\n📱 TIKTOK: @Putzz_mvpp\n📞 WHATSAPP: 088976255131\n\n✨ ALL FITUR WORKING!"
infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 13
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Center

-- Show first tab
tabs[1].TextColor3 = Color3.fromRGB(255, 255, 255)
tabs[1].BackgroundTransparency = 0.2
contents[1].Visible = true

-- Tombol toggle menu (di pojok kiri)
local menuBtn = Instance.new("TextButton")
menuBtn.Parent = ScreenGui
menuBtn.Size = UDim2.new(0, 85, 0, 38)
menuBtn.Position = UDim2.new(0, 10, 0.5, -19)
menuBtn.BackgroundColor3 = themeColor
menuBtn.BackgroundTransparency = 0.2
menuBtn.Text = "⚡ MENU"
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
    mainFrame.Visible = menuVisible
    if menuVisible then
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -190, 0.5, -240)}):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -190, 1, 0)}):Play()
    end
end)

-- Notifikasi sukses
local notifGui = Instance.new("ScreenGui")
notifGui.Parent = game.CoreGui
local notifFrame = Instance.new("Frame")
notifFrame.Parent = notifGui
notifFrame.Size = UDim2.new(0, 300, 0, 50)
notifFrame.Position = UDim2.new(0.5, -150, 0, -80)
notifFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
notifFrame.BackgroundTransparency = 0.1
local notifCorner = Instance.new("UICorner")
notifCorner.Parent = notifFrame
notifCorner.CornerRadius = UDim.new(0, 12)
local notifText = Instance.new("TextLabel")
notifText.Parent = notifFrame
notifText.Size = UDim2.new(1, 0, 1, 0)
notifText.BackgroundTransparency = 1
notifText.Text = "✅ AINCRAD MENU ACTIVATED! Klik MENU di pojok kiri"
notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
notifText.Font = Enum.Font.GothamBold
notifText.TextSize = 13
TweenService:Create(notifFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
task.wait(3)
TweenService:Create(notifFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, -80)}):Play()
task.wait(0.5)
notifGui:Destroy()

print("✅ AINCRAD MENU - READY!")