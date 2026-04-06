-- ================== DRIP CLIENT V7.2 (TESTING - LANGSUNG JALAN) ==================
-- Version: 7.2 (Direct Execute - No Loadstring)
-- Developer: Putzz XD

-- Langsung jalan tanpa key system untuk testing
-- HAPUS INI NANTI KALAU SUDAH WORK

-- ================== LOAD SERVICES ==================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- ================== VARIABEL FITUR ==================
local espEnabled = false
local lineEnabled = false
local healthEnabled = false
local skeletonEnabled = false
local ESPTable = {}
local SkeletonESP = {}

local flyEnabled = false
local flySpeed = 60
local bv = nil
local bg = nil

local speedEnabled = false
local normalSpeed = 16
local fastSpeed = 60

local noclipEnabled = false
local infinityJumpEnabled = false
local jumpCount = 0

local antiDamageEnabled = false
local antiDamageConnection = nil
local antiDamageThread = nil
local antiDamageHeartbeat = nil

local spinEnabled = false
local spinSpeed = 10
local spinConnection = nil
local spinDirection = 1

local invisibleEnabled = false
local invisibleConnection = nil
local invisibleParts = {}
local invisibleRootPart = nil
local invisibleHumanoid = nil

-- Warna
local themeColor = Color3.fromRGB(156, 39, 176)
local darkPurple = Color3.fromRGB(74, 20, 90)
local boxColor = Color3.fromRGB(0, 255, 0)
local skeletonColor = Color3.fromRGB(0, 255, 0)
local MAX_ESP_DISTANCE = 115

-- ================== FUNGSI UTILITY ==================
local function toggleSpin(state)
    spinEnabled = state
    if spinConnection then spinConnection:Disconnect() spinConnection = nil end
    if state then
        spinConnection = RunService.Heartbeat:Connect(function()
            if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = LocalPlayer.Character.HumanoidRootPart
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * spinDirection), 0)
            end
        end)
        print("SPIN ON")
    end
end

local function toggleSpinDirection()
    spinDirection = spinDirection * -1
end

local function updateInvisibleData()
    if LocalPlayer.Character then
        invisibleRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        invisibleHumanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        invisibleParts = {}
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency == 0 then
                table.insert(invisibleParts, v)
            end
        end
    end
end

local function toggleInvisible(state)
    invisibleEnabled = state
    if invisibleConnection then invisibleConnection:Disconnect() invisibleConnection = nil end
    updateInvisibleData()
    if state then
        for _, v in pairs(invisibleParts) do v.Transparency = 0.5 end
        invisibleConnection = RunService.Heartbeat:Connect(function()
            if invisibleEnabled and invisibleRootPart and invisibleHumanoid then
                local oldCF = invisibleRootPart.CFrame
                local oldOffset = invisibleHumanoid.CameraOffset
                local hideCF = oldCF * CFrame.new(0, -200000, 0)
                invisibleRootPart.CFrame = hideCF
                invisibleHumanoid.CameraOffset = hideCF:ToObjectSpace(CFrame.new(oldCF.Position)).Position
                RunService.RenderStepped:Wait()
                invisibleRootPart.CFrame = oldCF
                invisibleHumanoid.CameraOffset = oldOffset
            end
        end)
        print("INVISIBLE ON")
    else
        for _, v in pairs(invisibleParts) do v.Transparency = 0 end
        print("INVISIBLE OFF")
    end
end

local function setupAntiDamage()
    if antiDamageHeartbeat then antiDamageHeartbeat:Disconnect() end
    if antiDamageConnection then antiDamageConnection:Disconnect() end
    if antiDamageThread then antiDamageThread = nil end
    
    antiDamageHeartbeat = RunService.Heartbeat:Connect(function()
        if antiDamageEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end
                if humanoid.Health <= 0 then humanoid.Health = humanoid.MaxHealth end
            end
        end
    end)
    
    antiDamageThread = task.spawn(function()
        while antiDamageEnabled do
            task.wait(0.001)
            pcall(function()
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end
                end
            end)
        end
    end)
    
    local function onHealthChanged()
        if antiDamageEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HealthChanged:Connect(function(newHealth)
                    if antiDamageEnabled and newHealth < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end
                end)
            end
        end
    end
    
    if LocalPlayer.Character then onHealthChanged() end
    LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); if antiDamageEnabled then onHealthChanged() end end)
    print("GOD MODE ON")
end

-- ================== FUNGSI INFINITY JUMP ==================
local function onJumpRequest()
    if infinityJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end
UserInputService.JumpRequest:Connect(onJumpRequest)

-- ================== FUNGSI TELEPORT ==================
local function teleportToPlayer(username)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(username:lower()) then
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    return true
                end
            end
        end
    end
    return false
end

-- ================== FUNGSI ESP ==================
local function createESP(player)
    if player == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 2.5
    box.Color = boxColor
    box.Filled = false
    box.Visible = false
    
    local name = Drawing.new("Text")
    name.Size = 16
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Center = true
    name.Outline = true
    name.OutlineColor = Color3.fromRGB(0, 0, 0)
    name.Visible = false
    
    local dist = Drawing.new("Text")
    dist.Size = 13
    dist.Color = Color3.fromRGB(200, 200, 200)
    dist.Center = true
    dist.Outline = true
    dist.OutlineColor = Color3.fromRGB(0, 0, 0)
    dist.Visible = false
    
    local line = Drawing.new("Line")
    line.Thickness = 2.5
    line.Color = themeColor
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
    
    ESPTable[player] = {box, name, dist, line, healthBg, healthFg}
end

local function createSkeleton(player)
    if player == LocalPlayer then return end
    local lines = {}
    local connections = {
        {"Head", "UpperTorso"}, {"Head", "Torso"},
        {"UpperTorso", "LowerTorso"}, {"Torso", "HumanoidRootPart"},
        {"UpperTorso", "LeftUpperArm"}, {"Torso", "Left Arm"}, 
        {"LeftUpperArm", "LeftLowerArm"}, {"Left Arm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"Torso", "Right Arm"},
        {"RightUpperArm", "RightLowerArm"}, {"Right Arm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"HumanoidRootPart", "Left Leg"},
        {"LeftUpperLeg", "LeftLowerLeg"}, {"Left Leg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"HumanoidRootPart", "Right Leg"},
        {"RightUpperLeg", "RightLowerLeg"}, {"Right Leg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
    for i = 1, #connections do
        local line = Drawing.new("Line")
        line.Thickness = 3
        line.Color = skeletonColor
        line.Visible = false
        table.insert(lines, {line, connections[i][1], connections[i][2]})
    end
    SkeletonESP[player] = lines
end

local function updateSkeleton(player, lines)
    local char = player.Character
    if not char then
        for _, lineData in pairs(lines) do lineData[1].Visible = false end
        return
    end
    for _, lineData in pairs(lines) do
        local line, part1Name, part2Name = unpack(lineData)
        
        local function findPart(partName)
            if partName == "UpperTorso" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
            if partName == "LowerTorso" then return char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart") end
            if partName == "LeftUpperArm" then return char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") end
            if partName == "RightUpperArm" then return char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") end
            if partName == "LeftUpperLeg" then return char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") end
            if partName == "RightUpperLeg" then return char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") end
            if partName == "LeftLowerArm" then return char:FindFirstChild("LeftLowerArm") or char:FindFirstChild("Left Arm") end
            if partName == "RightLowerArm" then return char:FindFirstChild("RightLowerArm") or char:FindFirstChild("Right Arm") end
            if partName == "LeftLowerLeg" then return char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("Left Leg") end
            if partName == "RightLowerLeg" then return char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg") end
            if partName == "LeftHand" then return char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm") end
            if partName == "RightHand" then return char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm") end
            if partName == "LeftFoot" then return char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg") end
            if partName == "RightFoot" then return char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") end
            return char:FindFirstChild(partName)
        end
        
        local part1 = findPart(part1Name)
        local part2 = findPart(part2Name)
        
        if part1 and part2 then
            local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)
            if vis1 and vis2 then
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Visible = skeletonEnabled
                line.Color = skeletonColor
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

-- Inisialisasi ESP
for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
    createSkeleton(p)
end

Players.PlayerAdded:Connect(function(p)
    createESP(p)
    createSkeleton(p)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPTable[player] then
        for _, drawing in pairs(ESPTable[player]) do
            pcall(function() if drawing and drawing.Remove then drawing:Remove() end end)
        end
        ESPTable[player] = nil
    end
    if SkeletonESP[player] then
        for _, lineData in pairs(SkeletonESP[player]) do
            pcall(function() if lineData[1] and lineData[1].Remove then lineData[1]:Remove() end end)
        end
        SkeletonESP[player] = nil
    end
end)

-- ================== FUNGSI FLY ==================
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
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
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- ================== RENDER STEP ESP ==================
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position
    
    for player, esp in pairs(ESPTable) do
        local box, name, distText, line, healthBg, healthFg = unpack(esp)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local hrp = char.HumanoidRootPart
            local head = char.Head
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
            local distance = myPos and (myPos - hrp.Position).Magnitude or math.huge
            local withinRange = distance <= MAX_ESP_DISTANCE
            
            if visible and withinRange then
                local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(top.Y - bottom.Y)
                local width = height / 2
                
                if espEnabled then
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width/2, top.Y)
                    box.Visible = true
                    box.Color = boxColor
                    
                    name.Position = Vector2.new(pos.X, top.Y - 18)
                    name.Text = player.Name
                    name.Visible = true
                    distText.Text = math.floor(distance) .. "m"
                    distText.Position = Vector2.new(pos.X, bottom.Y + 5)
                    distText.Visible = true
                else
                    box.Visible = false
                    name.Visible = false
                    distText.Visible = false
                end
                
                if healthEnabled and humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barWidth = width * 0.8
                    local barHeight = 4
                    local barX = pos.X - barWidth / 2
                    local barY = top.Y - 22
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
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Visible = true
                    line.Color = themeColor
                else
                    line.Visible = false
                end
            else
                box.Visible = false
                name.Visible = false
                distText.Visible = false
                line.Visible = false
                healthBg.Visible = false
                healthFg.Visible = false
            end
        end
    end
    
    if skeletonEnabled then
        for player, lines in pairs(SkeletonESP) do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and myPos then
                local hrp = char.HumanoidRootPart
                local distance = (myPos - hrp.Position).Magnitude
                if distance <= MAX_ESP_DISTANCE then
                    updateSkeleton(player, lines)
                else
                    for _, lineData in pairs(lines) do lineData[1].Visible = false end
                end
            else
                for _, lineData in pairs(lines) do lineData[1].Visible = false end
            end
        end
    else
        for _, lines in pairs(SkeletonESP) do
            for _, lineData in pairs(lines) do lineData[1].Visible = false end
        end
    end
end)

-- ================== GUI UTAMA ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "DripClient"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100

local mainFrame = Instance.new("Frame")
mainFrame.Parent = ScreenGui
mainFrame.Size = UDim2.new(0, 400, 0, 550)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
mainFrame.BackgroundColor3 = darkPurple
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 24)

local glowBg = Instance.new("ImageLabel")
glowBg.Parent = mainFrame
glowBg.Size = UDim2.new(1.1, 0, 1.1, 0)
glowBg.Position = UDim2.new(-0.05, 0, -0.05, 0)
glowBg.BackgroundTransparency = 1
glowBg.Image = "rbxassetid://6014261993"
glowBg.ImageColor3 = themeColor
glowBg.ImageTransparency = 0.7
glowBg.ScaleType = Enum.ScaleType.Slice
glowBg.SliceCenter = Rect.new(10, 10, 118, 118)
glowBg.ZIndex = 0

local premiumBorder = Instance.new("Frame")
premiumBorder.Parent = mainFrame
premiumBorder.Size = UDim2.new(1, 0, 1, 0)
premiumBorder.BackgroundTransparency = 1
premiumBorder.BorderSizePixel = 3
premiumBorder.BorderColor3 = themeColor
local borderCorner = Instance.new("UICorner")
borderCorner.Parent = premiumBorder
borderCorner.CornerRadius = UDim.new(0, 24)

local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1, 0, 0, 70)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = themeColor
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
local headerCorner = Instance.new("UICorner")
headerCorner.Parent = header
headerCorner.CornerRadius = UDim.new(0, 24)
local headerGradient = Instance.new("UIGradient")
headerGradient.Parent = header
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, themeColor),
    ColorSequenceKeypoint.new(1, darkPurple)
})
headerGradient.Rotation = 90

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 0.6, 0)
title.Position = UDim2.new(0, 0, 0, 15)
title.BackgroundTransparency = 1
title.Text = "DRIP CLIENT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 26
title.TextXAlignment = Enum.TextXAlignment.Center

local subtitle = Instance.new("TextLabel")
subtitle.Parent = header
subtitle.Size = UDim2.new(1, 0, 0.3, 0)
subtitle.Position = UDim2.new(0, 0, 0, 48)
subtitle.BackgroundTransparency = 1
subtitle.Text = "GREEN BOX | DISTANCE 115M"
subtitle.TextColor3 = boxColor
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Center

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.Size = UDim2.new(0.95, 0, 0, 42)
tabBar.Position = UDim2.new(0.025, 0, 0.13, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
tabBar.BackgroundTransparency = 0.3
tabBar.BorderSizePixel = 0
local tabBarCorner = Instance.new("UICorner")
tabBarCorner.Parent = tabBar
tabBarCorner.CornerRadius = UDim.new(0, 10)

local tabs = {}
local contents = {}

local function createTab(name, icon, idx)
    local btn = Instance.new("TextButton")
    btn.Parent = tabBar
    btn.Size = UDim2.new(0.2, -2, 1, -6)
    btn.Position = UDim2.new((idx-1)*0.2, 5, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    btn.BackgroundTransparency = 0.5
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(0.94, 0, 1, -0.28)
    content.Position = UDim2.new(0.03, 0, 0.2, 0)
    content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    content.BackgroundTransparency = 0.4
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 8
    content.ScrollBarImageColor3 = themeColor
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Visible = false
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    content.ElasticBehavior = Enum.ElasticBehavior.Never
    content.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    local contentCorner = Instance.new("UICorner")
    contentCorner.Parent = content
    contentCorner.CornerRadius = UDim.new(0, 12)
    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0, 10)
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
        task.wait(0.05)
        local height = 0
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("Frame") then
                height = height + child.Size.Y.Offset + 10
            end
        end
        content.CanvasSize = UDim2.new(0, 0, 0, height + 40)
    end)
    
    return content
end

local tabMain = createTab("MAIN", "▸", 1)
local tabESP = createTab("ESP", "▸", 2)
local tabUtility = createTab("UTILITY", "▸", 3)
local tabColor = createTab("COLOR", "▸", 4)
local tabInfo = createTab("INFORMASI", "▸", 5)

-- Komponen UI
local function createButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.95, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
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
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    return frame
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.95, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 10)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    local switch = Instance.new("Frame")
    switch.Parent = frame
    switch.Size = UDim2.new(0, 48, 0, 24)
    switch.Position = UDim2.new(0.82, 0, 0.5, -12)
    switch.BackgroundColor3 = default and themeColor or Color3.fromRGB(80, 80, 90)
    switch.BorderSizePixel = 0
    local switchCorner = Instance.new("UICorner")
    switchCorner.Parent = switch
    switchCorner.CornerRadius = UDim.new(0, 12)
    local circle = Instance.new("Frame")
    circle.Parent = switch
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0.05, 0, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and themeColor or Color3.fromRGB(80, 80, 90)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0.05, 0, 0.5, -10)}):Play()
        callback(state)
    end)
    return frame
end

local function createTextBox(parent, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.95, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 10)
    local textBox = Instance.new("TextBox")
    textBox.Parent = frame
    textBox.Size = UDim2.new(1, -10, 1, -10)
    textBox.Position = UDim2.new(0, 5, 0, 5)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = placeholder
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = false
    local boxCorner = Instance.new("UICorner")
    boxCorner.Parent = textBox
    boxCorner.CornerRadius = UDim.new(0, 8)
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and textBox.Text ~= "" then
            callback(textBox.Text)
            textBox.Text = ""
        end
    end)
    return frame
end

-- ===== TAB MAIN =====
createToggle(tabMain, "Fly", false, function(s)
    flyEnabled = s
    if s then startFly() else stopFly() end
end)

createToggle(tabMain, "Speed Boost", false, function(s)
    speedEnabled = s
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = s and fastSpeed or normalSpeed end
end)

createToggle(tabMain, "NoClip", false, function(s)
    noclipEnabled = s
end)

createTextBox(tabMain, "Masukkan username player...", function(username)
    teleportToPlayer(username)
end)

createToggle(tabMain, "Infinity Jump", false, function(s)
    infinityJumpEnabled = s
end)

-- ===== TAB ESP =====
createToggle(tabESP, "ESP Box", false, function(s) espEnabled = s end)
createToggle(tabESP, "ESP Line", false, function(s) lineEnabled = s end)
createToggle(tabESP, "Health Bar", false, function(s) healthEnabled = s end)
createToggle(tabESP, "ESP Skeleton", false, function(s) skeletonEnabled = s end)

-- ===== TAB UTILITY =====
createToggle(tabUtility, "God Mode", false, function(s)
    antiDamageEnabled = s
    if s then
        setupAntiDamage()
    else
        if antiDamageHeartbeat then antiDamageHeartbeat:Disconnect() end
        if antiDamageConnection then antiDamageConnection:Disconnect() end
        antiDamageThread = nil
    end
end)

createToggle(tabUtility, "Spin Muter", false, function(s)
    toggleSpin(s)
end)

createButton(tabUtility, "Ganti Arah Spin", function()
    toggleSpinDirection()
end)

createToggle(tabUtility, "Invisible Mode", false, function(s)
    toggleInvisible(s)
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    updateInvisibleData()
    if invisibleEnabled then toggleInvisible(true) end
end)

-- ===== TAB COLOR =====
local function changeTheme(newColor)
    themeColor = newColor
    premiumBorder.BorderColor3 = themeColor
    for _, content in pairs(contents) do
        content.ScrollBarImageColor3 = themeColor
    end
    for player, esp in pairs(ESPTable) do
        if esp and esp[4] then esp[4].Color = themeColor end
    end
end

createButton(tabColor, "Ungu (Default)", function()
    changeTheme(Color3.fromRGB(156, 39, 176))
end)
createButton(tabColor, "Pink", function()
    changeTheme(Color3.fromRGB(255, 105, 180))
end)
createButton(tabColor, "Merah", function()
    changeTheme(Color3.fromRGB(255, 0, 0))
end)
createButton(tabColor, "Hijau", function()
    changeTheme(Color3.fromRGB(0, 255, 0))
end)
createButton(tabColor, "Biru", function()
    changeTheme(Color3.fromRGB(0, 0, 255))
end)
createButton(tabColor, "Kuning", function()
    changeTheme(Color3.fromRGB(255, 255, 0))
end)
createButton(tabColor, "Orange", function()
    changeTheme(Color3.fromRGB(255, 165, 0))
end)
createButton(tabColor, "Cyan", function()
    changeTheme(Color3.fromRGB(0, 255, 255))
end)

-- ===== TAB INFORMASI =====
local infoFrame = Instance.new("Frame")
infoFrame.Parent = tabInfo
infoFrame.Size = UDim2.new(0.95, 0, 0, 180)
infoFrame.Position = UDim2.new(0.025, 0, 0, 10)
infoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
infoFrame.BackgroundTransparency = 0.3
infoFrame.BorderSizePixel = 0
local infoCorner = Instance.new("UICorner")
infoCorner.Parent = infoFrame
infoCorner.CornerRadius = UDim.new(0, 12)

local infoTitle = Instance.new("TextLabel")
infoTitle.Parent = infoFrame
infoTitle.Size = UDim2.new(1, 0, 0, 35)
infoTitle.Position = UDim2.new(0, 0, 0, 10)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "INFORMASI SCRIPT"
infoTitle.TextColor3 = themeColor
infoTitle.Font = Enum.Font.GothamBlack
infoTitle.TextSize = 20

local infoText = Instance.new("TextLabel")
infoText.Parent = infoFrame
infoText.Size = UDim2.new(0.95, 0, 0, 110)
infoText.Position = UDim2.new(0.025, 0, 0, 55)
infoText.BackgroundTransparency = 1
infoText.Text = "DRIP CLIENT\n\nVERSI 7.2\n\nDEVELOPER: Putzzdev\n\nKONTAK: 088976255131"
infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 14
infoText.TextWrapped = true
infoText.TextXAlignment = Enum.TextXAlignment.Center

-- Update canvas size
task.wait(0.1)
for _, content in pairs(contents) do
    local height = 0
    for _, child in pairs(content:GetChildren()) do
        if child:IsA("Frame") then
            height = height + child.Size.Y.Offset + 10
        end
    end
    content.CanvasSize = UDim2.new(0, 0, 0, height + 40)
end

tabs[1].TextColor3 = Color3.fromRGB(255, 255, 255)
tabs[1].BackgroundTransparency = 0.2
contents[1].Visible = true

-- Tombol menu
local openBtn = Instance.new("TextButton")
openBtn.Parent = ScreenGui
openBtn.Size = UDim2.new(0, 120, 0, 45)
openBtn.Position = UDim2.new(0, 15, 0.5, -22.5)
openBtn.BackgroundColor3 = themeColor
openBtn.BackgroundTransparency = 0.2
openBtn.Text = "DRIP CLIENT"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 13
openBtn.ZIndex = 10
openBtn.Active = true
openBtn.Draggable = true

local openBtnCorner = Instance.new("UICorner")
openBtnCorner.Parent = openBtn
openBtnCorner.CornerRadius = UDim.new(0, 14)
local openBtnStroke = Instance.new("UIStroke")
openBtnStroke.Parent = openBtn
openBtnStroke.Color = Color3.fromRGB(255, 255, 255)
openBtnStroke.Thickness = 1.5

local menuOpen = true
openBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.25), {
            Position = UDim2.new(0.5, -200, 0.5, -275)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.25), {
            Position = UDim2.new(0.5, -200, 1, 0)
        }):Play()
        task.wait(0.25)
        mainFrame.Visible = false
    end
end)

openBtn.MouseEnter:Connect(function()
    TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, 48)}):Play()
    openBtn.BackgroundTransparency = 0
end)
openBtn.MouseLeave:Connect(function()
    TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 45)}):Play()
    openBtn.BackgroundTransparency = 0.2
end)

print("✅ DRIP CLIENT V7.2 - MENU BERHASIL DIMUAT!")