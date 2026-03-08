--// PUTZZDEV-HUB FINAL (ALL FEATURES + INVISIBLE + ESP SUPER)
-- Ukuran: Sedang (350x450), semua fitur siap pakai
-- ESP Model: Seperti di screenshot (Line putus-putus + Box tebal)

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

-- ================== FUNGSI ESP SUPER (Model Screenshot) ==================
local function createESP(player)
    if player == LocalPlayer then return end

    -- BOX (Tebal seperti screenshot)
    local box = Drawing.new("Square")
    box.Thickness = 3  -- Tebal
    box.Color = Color3.fromRGB(0, 255, 255)  -- Cyan
    box.Filled = false
    box.Visible = false
    box.Transparency = 0.3

    -- BOX DALAM (efek double line)
    local boxInner = Drawing.new("Square")
    boxInner.Thickness = 1
    boxInner.Color = Color3.fromRGB(255, 255, 255)  -- Putih
    boxInner.Filled = false
    boxInner.Visible = false
    boxInner.Transparency = 0.5

    -- LINE (Putus-putus seperti screenshot)
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Transparency = 0.3
    line.Visible = false

    -- LINE DOT EFFECT (membuat putus-putus)
    local dots = {}
    for i = 1, 10 do
        local dot = Drawing.new("Line")
        dot.Thickness = 2
        dot.Color = Color3.fromRGB(0, 255, 255)
        dot.Transparency = 0.5
        dot.Visible = false
        table.insert(dots, dot)
    end

    -- NAMA
    local name = Drawing.new("Text")
    name.Size = 18
    name.Color = Color3.fromRGB(0, 255, 255)
    name.Center = true
    name.Outline = true
    name.OutlineColor = Color3.fromRGB(0, 0, 0)
    name.Visible = false

    -- JARAK
    local dist = Drawing.new("Text")
    dist.Size = 14
    dist.Color = Color3.fromRGB(255, 255, 255)
    dist.Center = true
    dist.Outline = true
    dist.OutlineColor = Color3.fromRGB(0, 0, 0)
    dist.Visible = false

    -- HEALTH BAR
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

    ESPTable[player] = {box, boxInner, name, dist, line, dots, healthBg, healthFg}
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
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }
    
    for i = 1, #connections do
        local line = Drawing.new("Line")
        line.Thickness = 2.5
        line.Color = Color3.fromRGB(0, 255, 255)
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
                line.Color = Color3.fromRGB(0, 255, 255)
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

-- ================== RENDER STEP ==================
RunService.RenderStepped:Connect(function()
    -- ESP Box (Model Screenshot)
    for player, esp in pairs(ESPTable) do
        local box, boxInner, name, dist, line, dots, healthBg, healthFg = unpack(esp)

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
                    -- BOX UTAMA (tebal)
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width/2, top.Y)
                    box.Visible = true
                    
                    -- BOX DALAM (tipis)
                    boxInner.Size = Vector2.new(width-2, height-2)
                    boxInner.Position = Vector2.new(pos.X - (width-2)/2, top.Y + 1)
                    boxInner.Visible = true

                    -- NAMA
                    name.Position = Vector2.new(pos.X, top.Y - 20)
                    name.Text = player.Name
                    name.Visible = true

                    -- JARAK
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local distance = (myChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                        dist.Text = math.floor(distance).."m"
                        dist.Position = Vector2.new(pos.X, bottom.Y + 5)
                        dist.Visible = true
                    end

                    -- LINE (efek putus-putus seperti screenshot)
                    if lineEnabled then
                        local startPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        local endPos = Vector2.new(pos.X, pos.Y)
                        local direction = (endPos - startPos).Unit
                        local distance = (endPos - startPos).Magnitude
                        
                        -- Buat garis putus-putus dengan multiple line segments
                        local segmentLength = 10
                        local gapLength = 5
                        local numSegments = math.floor(distance / (segmentLength + gapLength))
                        
                        for i = 1, #dots do
                            if i <= numSegments then
                                local t1 = (i-1) * (segmentLength + gapLength) / distance
                                local t2 = t1 + segmentLength / distance
                                
                                if t2 <= 1 then
                                    local p1 = startPos + direction * (t1 * distance)
                                    local p2 = startPos + direction * (t2 * distance)
                                    
                                    dots[i].From = p1
                                    dots[i].To = p2
                                    dots[i].Visible = true
                                else
                                    dots[i].Visible = false
                                end
                            else
                                dots[i].Visible = false
                            end
                        end
                    else
                        for i = 1, #dots do
                            dots[i].Visible = false
                        end
                    end

                    -- HEALTH BAR
                    if healthEnabled and humanoid then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local barWidth = width * 0.8
                        local barHeight = 4
                        local barX = pos.X - barWidth/2
                        local barY = top.Y - 25

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
                else
                    box.Visible = false
                    boxInner.Visible = false
                    name.Visible = false
                    dist.Visible = false
                    for i = 1, #dots do
                        dots[i].Visible = false
                    end
                    healthBg.Visible = false
                    healthFg.Visible = false
                end
            else
                box.Visible = false
                boxInner.Visible = false
                name.Visible = false
                dist.Visible = false
                for i = 1, #dots do
                    dots[i].Visible = false
                end
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

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Parent = ScreenGui
mainFrame.Size = UDim2.new(0, 350, 0, 480)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -240)
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

-- Header
local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "PUTZZDEV-HUB"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.TextStrokeTransparency = 0.5

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.Size = UDim2.new(1, 0, 0, 45)
tabBar.Position = UDim2.new(0, 0, 0, 55)
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
    btn.TextSize = 15

    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1, -10, 1, -110)
    content.Position = UDim2.new(0, 5, 0, 105)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 5
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0, 8)
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
local tabMove = createTab("MOVE", "🏃", 3)
local tabMisc = createTab("MISC", "⚙️", 4)

-- Fungsi buat button
local function createButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.9, 0, 0, 45)
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
    btn.TextSize = 16

    btn.MouseButton1Click:Connect(callback)
    return frame
end

-- Fungsi buat toggle
local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.9, 0, 0, 45)
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
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("Frame")
    switch.Parent = frame
    switch.Size = UDim2.new(0, 46, 0, 24)
    switch.Position = UDim2.new(0.8, 0, 0.5, -12)
    switch.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(100, 100, 100)
    switch.BorderSizePixel = 0

    local switchCorner = Instance.new("UICorner")
    switchCorner.Parent = switch
    switchCorner.CornerRadius = UDim.new(0, 12)

    local circle = Instance.new("Frame")
    circle.Parent = switch
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0.05, 0, 0.5, -10)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.BorderSizePixel = 0

    local circleCorner = Instance.new("UICorner")
    circleCorner.Parent = circle
    circleCorner.CornerRadius = UDim.new