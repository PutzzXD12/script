--// PUTZZDEV-HUB VERSI SEDENG (300x500) + TOMBOL "P" BISA DIGESER
-- Ukuran: 300x500 (lebih kecil dari sebelumnya)
-- Semua fitur tetap sama

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================== VARIABEL FITUR ==================
-- ESP
local espEnabled = false
local lineEnabled = false
local healthEnabled = false
local skeletonEnabled = false
local ESPTable = {}
local SkeletonESP = {}

-- Fly
local flyEnabled = false
local flySpeed = 60
local bv = nil
local bg = nil

-- Speed
local speedEnabled = false
local normalSpeed = 16
local fastSpeed = 60

-- NoClip
local noclipEnabled = false

-- INVISIBLE (Transparan)
local invisibleEnabled = false
local originalTransparency = {}

-- AIMBOT
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotFOV = 150
local aimbotSmoothness = 5
local aimbotPart = "Head"

-- INFINITY JUMP
local infinityJumpEnabled = false
local jumpCount = 0

-- ================== FUNGSI INFINITY JUMP ==================
local function onJumpRequest()
    if infinityJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end

UserInputService.JumpRequest:Connect(onJumpRequest)

-- Reset jump count saat menyentuh tanah
local function onTouchGround()
    jumpCount = 0
end

LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then
            onTouchGround()
        end
    end)
end)

-- ================== FUNGSI INVISIBLE ==================
local function setInvisible(state)
    local char = LocalPlayer.Character
    if not char then return end
    
    if state then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                originalTransparency[part] = part.Transparency
                part.Transparency = 0.9
            end
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            originalTransparency[humanoid] = humanoid.Transparency
            humanoid.Transparency = 0.9
        end
    else
        for part, trans in pairs(originalTransparency) do
            if part and part.Parent then
                part.Transparency = trans
            end
        end
        table.clear(originalTransparency)
    end
end

-- ================== FUNGSI ESP BOX ==================
local function createESP(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0,255,0)
    box.Filled = false
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 16
    name.Color = Color3.new(1,1,1)
    name.Center = true
    name.Outline = true
    name.Visible = false

    local dist = Drawing.new("Text")
    dist.Size = 13
    dist.Color = Color3.new(1,1,1)
    dist.Center = true
    dist.Outline = true
    dist.Visible = false

    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Visible = false

    local healthBg = Drawing.new("Square")
    healthBg.Thickness = 1
    healthBg.Color = Color3.fromRGB(30,30,30)
    healthBg.Filled = true
    healthBg.Visible = false

    local healthFg = Drawing.new("Square")
    healthFg.Thickness = 0
    healthFg.Color = Color3.fromRGB(0,255,0)
    healthFg.Filled = true
    healthFg.Visible = false

    ESPTable[player] = {box, name, dist, line, healthBg, healthFg}
end

-- ================== ESP SKELETON ==================
local function createSkeleton(player)
    if player == LocalPlayer then return end
    
    local lines = {}
    
    local connections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
        {"LeftShoulder", "RightHip"}, {"RightShoulder", "LeftHip"}
    }
    
    for i = 1, #connections do
        local line = Drawing.new("Line")
        line.Thickness = 2.5
        line.Color = Color3.fromRGB(255, 100, 0)
        line.Visible = false
        table.insert(lines, {line, connections[i][1], connections[i][2]})
    end
    
    SkeletonESP[player] = lines
end

-- Update skeleton
local function updateSkeleton(player, lines)
    local char = player.Character
    if not char then
        for _, lineData in pairs(lines) do
            lineData[1].Visible = false
        end
        return
    end
    
    for _, lineData in pairs(lines) do
        local line, part1Name, part2Name = unpack(lineData)
        local part1 = char:FindFirstChild(part1Name) or char:FindFirstChild(part1Name:gsub("Upper", ""):gsub("Lower", ""))
        local part2 = char:FindFirstChild(part2Name) or char:FindFirstChild(part2Name:gsub("Upper", ""):gsub("Lower", ""))
        
        if part1 and part2 then
            local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)
            
            if vis1 and vis2 then
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Visible = skeletonEnabled
                
                if player.Team and LocalPlayer.Team and player.Team ~= LocalPlayer.Team then
                    line.Color = Color3.fromRGB(255, 50, 50)
                else
                    line.Color = Color3.fromRGB(50, 255, 50)
                end
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

-- ================== FUNGSI AIMBOT ==================
local function getClosestEnemy()
    local closest = nil
    local shortestDistance = aimbotFOV
    local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimbotPart) then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local part = player.Character[aimbotPart]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                
                if onScreen then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local distance = (mousePos - screenPos).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closest = player
                    end
                end
            end
        end
    end
    
    return closest
end

-- Rainbow color untuk ESP Line
local hue = 0
RunService.RenderStepped:Connect(function()
    -- Update rainbow color untuk ESP Line
    hue = (hue + 0.01) % 1
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    
    -- ESP Box dan lainnya
    for player, esp in pairs(ESPTable) do
        local box, name, dist, line, healthBg, healthFg = unpack(esp)

        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local hrp = char.HumanoidRootPart
            local head = char.Head
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

            if visible then
                local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))

                local height = math.abs(top.Y - bottom.Y)
                local width = height / 2

                if espEnabled then
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width/2, top.Y)
                    box.Visible = true

                    name.Position = Vector2.new(pos.X, top.Y - 16)
                    name.Text = player.Name
                    name.Visible = true

                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local distance = (myChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                        dist.Text = math.floor(distance).."m"
                        dist.Position = Vector2.new(pos.X, bottom.Y + 2)
                        dist.Visible = true
                    end
                else
                    box.Visible = false
                    name.Visible = false
                    dist.Visible = false
                end

                if healthEnabled and humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barWidth = width * 0.8
                    local barHeight = 4
                    local barX = pos.X - barWidth/2
                    local barY = top.Y - 20

                    healthBg.Size = Vector2.new(barWidth, barHeight)
                    healthBg.Position = Vector2.new(barX, barY)
                    healthBg.Visible = true

                    healthFg.Size = Vector2.new(barWidth * healthPercent, barHeight)
                    healthFg.Position = Vector2.new(barX, barY)
                    healthFg.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    healthFg.Visible = true
                else
                    healthBg.Visible = false
                    healthFg.Visible = false
                end

                if lineEnabled then
                    line.From = Vector2.new(Camera.ViewportSize.X/2, 0)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Visible = true
                    line.Color = rainbowColor -- WARNA-WARNI
                else
                    line.Visible = false
                end
            else
                box.Visible = false
                name.Visible = false
                dist.Visible = false
                line.Visible = false
                healthBg.Visible = false
                healthFg.Visible = false
            end
        end
    end
    
    -- ESP Skeleton
    if skeletonEnabled then
        for player, lines in pairs(SkeletonESP) do
            updateSkeleton(player, lines)
        end
    else
        for _, lines in pairs(SkeletonESP) do
            for _, lineData in pairs(lines) do
                lineData[1].Visible = false
            end
        end
    end
    
    -- Aimbot
    if aimbotEnabled then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild(aimbotPart) then
            local targetPart = target.Character[aimbotPart]
            local targetPos = targetPart.Position
            
            local cameraPos = Camera.CFrame.Position
            local lookAt = CFrame.lookAt(cameraPos, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, 1 / aimbotSmoothness, Enum.EasingStyle.Sine)
        end
    end
end)

-- Inisialisasi player
for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
    createSkeleton(p)
end

Players.PlayerAdded:Connect(function(p)
    createESP(p)
    createSkeleton(p)
end)

-- ========== FIX ESP BUG: HAPUS SAAT PLAYER KELUAR ==========
Players.PlayerRemoving:Connect(function(player)
    if ESPTable[player] then
        for _, drawing in pairs(ESPTable[player]) do
            pcall(function()
                if drawing and drawing.Remove then
                    drawing:Remove()
                end
            end)
        end
        ESPTable[player] = nil
    end
    
    if SkeletonESP[player] then
        for _, lineData in pairs(SkeletonESP[player]) do
            pcall(function()
                if lineData[1] and lineData[1].Remove then
                    lineData[1]:Remove()
                end
            end)
        end
        SkeletonESP[player] = nil
    end
end)

task.spawn(function()
    while task.wait(30) do
        pcall(function()
            for player, drawings in pairs(ESPTable) do
                if not player or not player.Parent then
                    for _, drawing in pairs(drawings) do
                        if drawing and drawing.Remove then
                            drawing:Remove()
                        end
                    end
                    ESPTable[player] = nil
                end
            end
            
            for player, lines in pairs(SkeletonESP) do
                if not player or not player.Parent then
                    for _, lineData in pairs(lines) do
                        if lineData[1] and lineData[1].Remove then
                            lineData[1]:Remove()
                        end
                    end
                    SkeletonESP[player] = nil
                end
            end
        end)
    end
end)

-- ================== FUNGSI FLY ==================
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.Parent = hrp

    RunService.RenderStepped:Connect(function()
        if flyEnabled and bv and bg then
            bg.CFrame = Camera.CFrame
            bv.Velocity = Camera.CFrame.LookVector * flySpeed
        end
    end)
end

local function stopFly()
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

-- ================== FUNGSI NOCLIP ==================
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ================== GUI KEREN ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PutzzdevHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100

-- ========== MAIN FRAME UKURAN SEDENG (300x500) ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = ScreenGui
mainFrame.Size = UDim2.new(0, 300, 0, 500)  -- Lebih kecil dari sebelumnya
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 16)

-- Gradient
local gradient = Instance.new("UIGradient")
gradient.Parent = mainFrame
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
})
gradient.Rotation = 45

-- Header (tetap proporsional)
local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1, 0, 0, 45)  -- Header lebih kecil
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Putzzdev-HUB"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24  -- Ukuran font disesuaikan
title.TextStrokeTransparency = 0.5

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.Position = UDim2.new(0, 0, 0, 45)
tabBar.BackgroundTransparency = 1

local tabs = {}
local contents = {}

local function createTab(name, icon, idx)
    local btn = Instance.new("TextButton")
    btn.Parent = tabBar
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new((idx-1)*0.25, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = icon.." "..name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13  -- Font tab lebih kecil

    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1, -10, 1, -165)
    content.Position = UDim2.new(0, 5, 0, 90)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 5
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    table.insert(tabs, btn)
    table.insert(contents, content)

    btn.MouseButton1Click:Connect(function()
        for i, b in ipairs(tabs) do
            b.TextColor3 = Color3.fromRGB(180, 180, 180)
            contents[i].Visible = false
        end
        btn.TextColor3 = Color3.fromRGB(0, 200, 255)
        content.Visible = true
    end)
    
    return content
end

-- Buat tabs
local tabMain = createTab("MAIN", "🏠", 1)
local tabESP = createTab("ESP", "👁️", 2)
local tabColor = createTab("COLOR", "🎨", 3)
local tabAbout = createTab("ABOUT", "📋", 4)

-- Fungsi buat button (ukuran disesuaikan)
local function createButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.9, 0, 0, 40)  -- Tinggi button 40
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15  -- Font button lebih kecil

    btn.MouseButton1Click:Connect(callback)
    return frame
end

-- Fungsi buat toggle (ukuran disesuaikan)
local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.9, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("Frame")
    switch.Parent = frame
    switch.Size = UDim2.new(0, 44, 0, 22)  -- Switch lebih kecil
    switch.Position = UDim2.new(0.8, 0, 0.5, -11)
    switch.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(100, 100, 100)
    switch.BorderSizePixel = 0

    local switchCorner = Instance.new("UICorner")
    switchCorner.Parent = switch
    switchCorner.CornerRadius = UDim.new(0, 11)

    local circle = Instance.new("Frame")
    circle.Parent = switch
    circle.Size = UDim2.new(0, 18, 0, 18)  -- Circle lebih kecil
    circle.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0.05, 0, 0.5, -9)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.BorderSizePixel = 0

    local circleCorner = Instance.new("UICorner")
    circleCorner.Parent = circle
    circleCorner.CornerRadius = UDim.new(1, 0)

    local state = default
    local click = Instance.new("TextButton")
    click.Parent = frame
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""

    click.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(100, 100, 100)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0.05, 0, 0.5, -9)}):Play()
        callback(state)
    end)
    
    return frame
end

-- Fungsi buat slider (ukuran disesuaikan)
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.9, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0.4, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.Size = UDim2.new(0.9, 0, 0.3, 0)
    sliderBg.Position = UDim2.new(0.05, 0, 0.5, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    sliderBg.BorderSizePixel = 0

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.Parent = sliderBg
    sliderCorner.CornerRadius = UDim.new(0, 4)

    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    sliderFill.BorderSizePixel = 0

    local fillCorner = Instance.new("UICorner")
    fillCorner.Parent = sliderFill
    fillCorner.CornerRadius = UDim.new(0, 4)

    local value = default
    local dragging = false

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = sliderBg.AbsolutePosition
            local absSize = sliderBg.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - absPos.X) / absSize.X, 0, 1)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            value = math.floor(min + (max - min) * relativeX)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)

    return frame
end

-- ================== FUNGSI GANTI WARNA ==================
local function changeThemeColor(color)
    mainFrame.BackgroundColor3 = color
    title.TextColor3 = color
    
    local grad = mainFrame:FindFirstChildOfClass("UIGradient")
    if grad then
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
        })
    end
end

-- ===== TAB MAIN =====
createToggle(tabMain, "Fly", false, function(s)
    flyEnabled = s
    if s then startFly() else stopFly() end
end)

createToggle(tabMain, "Speed", false, function(s)
    speedEnabled = s
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = s and fastSpeed or normalSpeed
    end
end)

createToggle(tabMain, "NoClip", false, function(s)
    noclipEnabled = s
end)

createToggle(tabMain, "Invisible", false, function(s)
    invisibleEnabled = s
    setInvisible(s)
end)

createToggle(tabMain, "Infinity Jump", false, function(s)
    infinityJumpEnabled = s
end)

createToggle(tabMain, "Aimbot", false, function(s)
    aimbotEnabled = s
end)

createSlider(tabMain, "Aimbot FOV", 50, 500, 150, function(s)
    aimbotFOV = s
end)

createSlider(tabMain, "Smoothness", 1, 20, 5, function(s)
    aimbotSmoothness = s
end)

-- ===== TAB ESP =====
createToggle(tabESP, "ESP Player", false, function(s) espEnabled = s end)
createToggle(tabESP, "ESP Line", false, function(s) lineEnabled = s end)
createToggle(tabESP, "Health Bar", false, function(s) healthEnabled = s end)
createToggle(tabESP, "ESP Skeleton", false, function(s) skeletonEnabled = s end)

-- ===== TAB COLOR =====
createButton(tabColor, "🔴 Merah", function()
    changeThemeColor(Color3.fromRGB(255, 0, 0))
end)

createButton(tabColor, "🟢 Hijau", function()
    changeThemeColor(Color3.fromRGB(0, 255, 0))
end)

createButton(tabColor, "🔵 Biru", function()
    changeThemeColor(Color3.fromRGB(0, 0, 255))
end)

createButton(tabColor, "🟡 Kuning", function()
    changeThemeColor(Color3.fromRGB(255, 255, 0))
end)

createButton(tabColor, "🟠 Orange", function()
    changeThemeColor(Color3.fromRGB(255, 165, 0))
end)

createButton(tabColor, "🟣 Ungu", function()
    changeThemeColor(Color3.fromRGB(128, 0, 128))
end)

createButton(tabColor, "💗 Pink", function()
    changeThemeColor(Color3.fromRGB(255, 192, 203))
end)

createButton(tabColor, "🔷 Cyan", function()
    changeThemeColor(Color3.fromRGB(0, 255, 255))
end)

-- ===== TAB ABOUT =====
local aboutFrame = Instance.new("Frame")
aboutFrame.Parent = tabAbout
aboutFrame.Size = UDim2.new(0.9, 0, 0, 200)
aboutFrame.Position = UDim2.new(0.05, 0, 0, 10)
aboutFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
aboutFrame.BackgroundTransparency = 0.3
aboutFrame.BorderSizePixel = 0

local aboutCorner = Instance.new("UICorner")
aboutCorner.Parent = aboutFrame
aboutCorner.CornerRadius = UDim.new(0, 10)

local aboutTitle = Instance.new("TextLabel")
aboutTitle.Parent = aboutFrame
aboutTitle.Size = UDim2.new(1, 0, 0, 40)
aboutTitle.Position = UDim2.new(0, 0, 0, 0)
aboutTitle.BackgroundTransparency = 1
aboutTitle.Text = "PUTZZ DEVELOPER"
aboutTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
aboutTitle.Font = Enum.Font.GothamBlack
aboutTitle.TextSize = 18

local line = Instance.new("Frame")
line.Parent = aboutFrame
line.Size = UDim2.new(0.8, 0, 0, 2)
line.Position = UDim2.new(0.1, 0, 0, 45)
line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
line.BorderSizePixel = 0

local lineCorner = Instance.new("UICorner")
lineCorner.Parent = line
lineCorner.CornerRadius = UDim.new(0, 2)

local infoText = Instance.new("TextLabel")
infoText.Parent = aboutFrame
infoText.Size = UDim2.new(0.9, 0, 0, 120)
infoText.Position = UDim2.new(0.05, 0, 0, 55)
infoText.BackgroundTransparency = 1
infoText.Text = "🔥 Putzzdev-HUB 🔥\n\n" ..
                 "👤 Developer: Putzz XD\n" ..
                 "📌 Version: 3.0\n" ..
                 "TYPE script: VIP\n\n" ..
                 "✨ Fitur:\n" ..
                 "• ESP Box, Line, Health, Skeleton\n" ..
                 "• Fly, Speed, NoClip, Invisible\n" ..
                 "• Aimbot + Infinity Jump\n" ..
                 "• sekian dan terimakasih\n\n" ..
                 "📞 Kontak: 088976255131"
infoText.TextColor3 = Color3.new(1, 1, 1)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 13
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Left

createButton(tabAbout, "📋 Copy TIKTOK", function()
    if setclipboard then
        setclipboard("putzz_mvpp")
        local notif = Instance.new("TextLabel")
        notif.Parent = ScreenGui
        notif.Size = UDim2.new(0, 180, 0, 30)
        notif.Position = UDim2.new(0.5, -90, 0.8, 0)
        notif.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        notif.BackgroundTransparency = 0.2
        notif.Text = "✅ TIKTOK copied!"
        notif.TextColor3 = Color3.new(1,1,1)
        notif.Font = Enum.Font.GothamBold
        notif.TextSize = 13
        notif.BorderSizePixel = 0
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.Parent = notif
        notifCorner.CornerRadius = UDim.new(0, 8)
        
        task.wait(2)
        notif:Destroy()
    end
end)

tabAbout.CanvasSize = UDim2.new(0, 0, 0, 320)

-- Update canvas size
local function updateCanvas()
    for _, content in pairs(contents) do
        local height = 0
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("Frame") then
                height = height + child.Size.Y.Offset + 6
            end
        end
        content.CanvasSize = UDim2.new(0, 0, 0, height)
    end
end

wait(0.1)
updateCanvas()

tabs[1].TextColor3 = Color3.fromRGB(0, 200, 255)
contents[1].Visible = true

-- Notifikasi
local notifyFrame = Instance.new("Frame")
notifyFrame.Parent = ScreenGui
notifyFrame.Size = UDim2.new(0, 220, 0, 35)
notifyFrame.Position = UDim2.new(0.5, -110, 0.9, 0)
notifyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
notifyFrame.BackgroundTransparency = 0.1
notifyFrame.BorderSizePixel = 0

local notifyCorner = Instance.new("UICorner")
notifyCorner.Parent = notifyFrame
notifyCorner.CornerRadius = UDim.new(0, 8)

local notifyText = Instance.new("TextLabel")
notifyText.Parent = notifyFrame
notifyText.Size = UDim2.new(1, 0, 1, 0)
notifyText.BackgroundTransparency = 1
notifyText.Text = "developer by Putzz XD"
notifyText.TextColor3 = Color3.new(1, 1, 1)
notifyText.Font = Enum.Font.Gotham
notifyText.TextSize = 14

TweenService:Create(notifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -110, 0.8, 0)}):Play()
wait(2)
TweenService:Create(notifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -110, 0.9, 0)}):Play()
wait(0.3)
notifyFrame:Destroy()

-- ================= TOMBOL "P" BISA DIGESER (DRAGGABLE) =================
local openBtn = Instance.new("TextButton")
openBtn.Parent = ScreenGui
openBtn.Size = UDim2.new(0, 45, 0, 45)  -- Lebih kecil
openBtn.Position = UDim2.new(0, 20, 0.5, -22.5)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
openBtn.Text = "P"
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 20
openBtn.AutoButtonColor = true
openBtn.ZIndex = 10
openBtn.Active = true  -- Biar bisa di-drag
openBtn.Draggable = true  -- INI YANG MEMBUAT BISA DIGESER!

local corner = Instance.new("UICorner")
corner.Parent = openBtn
corner.CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke")
stroke.Parent = openBtn
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1.5

-- toggle
local menuOpen = true

openBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen

	if menuOpen then
		mainFrame.Visible = true
		TweenService:Create(mainFrame, TweenInfo.new(0.25), {
			Position = UDim2.new(0.5, -150, 0.5, -250)
		}):Play()
	else
		TweenService:Create(mainFrame, TweenInfo.new(0.25), {
			Position = UDim2.new(0.5, -150, 1, 0)
		}):Play()
		task.wait(0.25)
		mainFrame.Visible = false
	end
end)

print("developer by Putzz XD")