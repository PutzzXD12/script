--// PUTZZDEV-HUB V3 (ULTIMATE EDITION) - FULL CODE
-- Desain: Modern Glassmorphism + Neon Effects
-- ESP: Skeleton Style (Box & Line pake garis tebal) - LINE HIJAU
-- Fitur: ESP, Fly, Speed, NoClip, Invisible, Teleport
-- Menu Button: Huruf "P" di samping kiri (buka/tutup dengan animasi)

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

-- INVISIBLE
local invisibleEnabled = false
local originalTransparency = {}

-- Warna tema
local themeColor = Color3.fromRGB(0, 200, 255) -- Cyan
local lineColor = Color3.fromRGB(0, 255, 0) -- HIJAU untuk line

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

-- ================== FUNGSI ESP BOX (SKELETON STYLE) ==================
local function createESP(player)
    if player == LocalPlayer then return end

    -- 4 Line untuk membuat box (style skeleton)
    local boxLines = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 2.5
        line.Color = lineColor  -- HIJAU
        line.Visible = false
        table.insert(boxLines, line)
    end

    -- NAMA
    local name = Drawing.new("Text")
    name.Size = 16
    name.Color = Color3.new(1,1,1)
    name.Center = true
    name.Outline = true
    name.OutlineColor = Color3.fromRGB(0,0,0)
    name.Visible = false

    -- JARAK
    local dist = Drawing.new("Text")
    dist.Size = 13
    dist.Color = Color3.new(1,1,1)
    dist.Center = true
    dist.Outline = true
    dist.OutlineColor = Color3.fromRGB(0,0,0)
    dist.Visible = false

    -- LINE (style skeleton) - WARNA HIJAU
    local line = Drawing.new("Line")
    line.Thickness = 2.5
    line.Color = lineColor  -- HIJAU
    line.Visible = false

    -- HEALTH BAR
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

    ESPTable[player] = {boxLines, name, dist, line, healthBg, healthFg}
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
        line.Color = lineColor  -- HIJAU
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
    -- ESP Box (Skeleton Style)
    for player, esp in pairs(ESPTable) do
        local boxLines, name, dist, line, healthBg, healthFg = unpack(esp)

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
                
                -- Hitung koordinat box
                local leftX = pos.X - width/2
                local rightX = pos.X + width/2
                local topY = top.Y
                local bottomY = bottom.Y

                if espEnabled then
                    -- Update 4 line untuk box (style skeleton)
                    if #boxLines >= 4 then
                        -- Garis atas
                        boxLines[1].From = Vector2.new(leftX, topY)
                        boxLines[1].To = Vector2.new(rightX, topY)
                        boxLines[1].Visible = true
                        boxLines[1].Color = lineColor  -- HIJAU
                        
                        -- Garis kanan
                        boxLines[2].From = Vector2.new(rightX, topY)
                        boxLines[2].To = Vector2.new(rightX, bottomY)
                        boxLines[2].Visible = true
                        boxLines[2].Color = lineColor  -- HIJAU
                        
                        -- Garis bawah
                        boxLines[3].From = Vector2.new(rightX, bottomY)
                        boxLines[3].To = Vector2.new(leftX, bottomY)
                        boxLines[3].Visible = true
                        boxLines[3].Color = lineColor  -- HIJAU
                        
                        -- Garis kiri
                        boxLines[4].From = Vector2.new(leftX, bottomY)
                        boxLines[4].To = Vector2.new(leftX, topY)
                        boxLines[4].Visible = true
                        boxLines[4].Color = lineColor  -- HIJAU
                    end

                    -- NAMA
                    name.Position = Vector2.new(pos.X, topY - 20)
                    name.Text = player.Name
                    name.Visible = true

                    -- JARAK
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local distance = (myChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                        dist.Text = math.floor(distance).."m"
                        dist.Position = Vector2.new(pos.X, bottomY + 5)
                        dist.Visible = true
                    end

                    -- LINE (style skeleton) - WARNA HIJAU
                    if lineEnabled then
                        line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(pos.X, pos.Y)
                        line.Visible = true
                        line.Color = lineColor  -- HIJAU
                    else
                        line.Visible = false
                    end

                    -- HEALTH BAR
                    if healthEnabled and humanoid then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local barWidth = width * 0.8
                        local barHeight = 4
                        local barX = pos.X - barWidth/2
                        local barY = topY - 25

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
                    -- Sembunyikan semua
                    for i = 1, #boxLines do
                        boxLines[i].Visible = false
                    end
                    name.Visible = false
                    dist.Visible = false
                    line.Visible = false
                    healthBg.Visible = false
                    healthFg.Visible = false
                end
            else
                -- Sembunyikan jika tidak visible
                for i = 1, #boxLines do
                    boxLines[i].Visible = false
                end
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

Players.PlayerRemoving:Connect(function(p)
    if ESPTable[p] then
        ESPTable[p] = nil
    end
    if SkeletonESP[p] then
        SkeletonESP[p] = nil
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

-- ================== FUNGSI TELEPORT ==================
local function teleportToPlayer(targetName)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName:lower()) or (player.DisplayName and player.DisplayName:lower():find(targetName:lower())) then
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    return true
                end
            end
        end
    end
    return false
end

-- ================== GUI MODERN GLASSMORPHISM ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PutzzdevHub_V3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100

-- ===== MAIN CONTAINER (UKURAN SEDANG) =====
local mainFrame = Instance.new("Frame")
mainFrame.Parent = ScreenGui
mainFrame.Size = UDim2.new(0, 350, 0, 450)  -- Ukuran sedang (350x450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

-- GLASS EFFECT
local glassEffect = Instance.new("Frame")
glassEffect.Parent = mainFrame
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassEffect.BackgroundTransparency = 0.95
glassEffect.BorderSizePixel = 0

-- CORNER
local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 16)

-- BORDER NEON
local border = Instance.new("Frame")
border.Parent = mainFrame
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = themeColor

-- ===== HEADER GLASS =====
local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.Parent = header
headerCorner.CornerRadius = UDim.new(0, 16)

-- Gradient header
local headerGradient = Instance.new("UIGradient")
headerGradient.Parent = header
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
})
headerGradient.Rotation = 90

-- Title dengan efek neon
local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "PUTZZDEV"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = themeColor

-- ===== TAB BAR MODERN =====
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.Size = UDim2.new(1, -20, 0, 45)
tabBar.Position = UDim2.new(0, 10, 0, 65)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabBar.BackgroundTransparency = 0.3
tabBar.BorderSizePixel = 0

local tabCorner = Instance.new("UICorner")
tabCorner.Parent = tabBar
tabCorner.CornerRadius = UDim.new(0, 10)

local tabs = {}
local contents = {}

local function createTab(name, icon, idx)
    local btn = Instance.new("TextButton")
    btn.Parent = tabBar
    btn.Size = UDim2.new(0.25, -2, 1, -6)
    btn.Position = UDim2.new((idx-1)*0.25, 5, 0, 3)
    btn.BackgroundColor3 = themeColor
    btn.BackgroundTransparency = 0.7
    btn.Text = icon.." "..name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)

    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1, -20, 1, -150)
    content.Position = UDim2.new(0, 10, 0, 115)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = themeColor
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Visible = false
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y  -- Auto scroll

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    table.insert(tabs, btn)
    table.insert(contents, content)

    btn.MouseButton1Click:Connect(function()
        for i, b in ipairs(tabs) do
            b.BackgroundTransparency = 0.7
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
            contents[i].Visible = false
        end
        btn.BackgroundTransparency = 0.3
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        content.Visible = true
    end)
    
    return content
end

-- Buat tabs dengan icon keren
local tabMain = createTab("MAIN", "⚡", 1)
local tabESP = createTab("ESP", "👁️", 2)
local tabMove = createTab("MOVE", "🚀", 3)
local tabMisc = createTab("MISC", "💎", 4)

-- ===== FUNGSI BUTTON MODERN =====
local function createModernButton(parent, text, icon, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.95, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 10)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = frame
    iconLabel.Size = UDim2.new(0, 35, 1, 0)
    iconLabel.Position = UDim2.new(0, 8, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = themeColor
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 20

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(1, -45, 1, 0)
    btn.Position = UDim2.new(0, 43, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseButton1Click:Connect(callback)
    return frame
end

-- ===== FUNGSI TOGGLE MODERN =====
local function createModernToggle(parent, text, icon, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.95, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 10)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = frame
    iconLabel.Size = UDim2.new(0, 35, 1, 0)
    iconLabel.Position = UDim2.new(0, 8, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = themeColor
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 20

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5, -40, 1, 0)
    label.Position = UDim2.new(0, 43, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggle switch modern
    local switch = Instance.new("Frame")
    switch.Parent = frame
    switch.Size = UDim2.new(0, 46, 0, 24)
    switch.Position = UDim2.new(1, -56, 0.5, -12)
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

-- ===== ISI TAB MAIN =====
createModernToggle(tabMain, "Fly Mode", "🦅", false, function(s)
    flyEnabled = s
    if s then startFly() else stopFly() end
end)

createModernToggle(tabMain, "Speed Boost", "⚡", false, function(s)
    speedEnabled = s
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = s and fastSpeed or normalSpeed
    end
end)

createModernToggle(tabMain, "NoClip", "🔄", false, function(s)
    noclipEnabled = s
end)

createModernToggle(tabMain, "Invisible", "👻", false, function(s)
    invisibleEnabled = s
    setInvisible(s)
end)

-- ===== ISI TAB ESP =====
createModernToggle(tabESP, "ESP Box", "📦", false, function(s)
    espEnabled = s
end)

createModernToggle(tabESP, "ESP Line", "📏", false, function(s)
    lineEnabled = s
end)

createModernToggle(tabESP, "Health Bar", "❤️", false, function(s)
    healthEnabled = s
end)

createModernToggle(tabESP, "ESP Skeleton", "🦴", false, function(s)
    skeletonEnabled = s
end)

-- ===== ISI TAB MOVE =====
createModernButton(tabMove, "Terbang Naik", "⬆️", function()
    if flyEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = hrp.Velocity + Vector3.new(0, 70, 0) end
    end
end)

createModernButton(tabMove, "Terbang Turun", "⬇️", function()
    if flyEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = hrp.Velocity - Vector3.new(0, 70, 0) end
    end
end)

-- Teleport input
local tpFrame = Instance.new("Frame")
tpFrame.Parent = tabMove
tpFrame.Size = UDim2.new(0.95, 0, 0, 90)
tpFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tpFrame.BackgroundTransparency = 0.3
tpFrame.BorderSizePixel = 0

local tpCorner = Instance.new("UICorner")
tpCorner.Parent = tpFrame
tpCorner.CornerRadius = UDim.new(0, 10)

local tpTitle = Instance.new("TextLabel")
tpTitle.Parent = tpFrame
tpTitle.Size = UDim2.new(1, -20, 0, 25)
tpTitle.Position = UDim2.new(0, 10, 0, 5)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "📞 Teleport ke Player"
tpTitle.TextColor3 = themeColor
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 14
tpTitle.TextXAlignment = Enum.TextXAlignment.Left

local tpInput = Instance.new("TextBox")
tpInput.Parent = tpFrame
tpInput.Size = UDim2.new(0.65, -10, 0, 35)
tpInput.Position = UDim2.new(0, 10, 0, 35)
tpInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
tpInput.PlaceholderText = "Nama player..."
tpInput.Text = ""
tpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
tpInput.Font = Enum.Font.Gotham
tpInput.TextSize = 14

local tpInputCorner = Instance.new("UICorner")
tpInputCorner.Parent = tpInput
tpInputCorner.CornerRadius = UDim.new(0, 6)

local tpBtn = Instance.new("TextButton")
tpBtn.Parent = tpFrame
tpBtn.Size = UDim2.new(0.3, -5, 0, 35)
tpBtn.Position = UDim2.new(0.7, 0, 0, 35)
tpBtn.BackgroundColor3 = themeColor
tpBtn.BackgroundTransparency = 0.2
tpBtn.Text = "GO"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 16

local tpBtnCorner = Instance.new("UICorner")
tpBtnCorner.Parent = tpBtn
tpBtnCorner.CornerRadius = UDim.new(0, 6)

tpBtn.MouseButton1Click:Connect(function()
    teleportToPlayer(tpInput.Text)
end)

tpInput.FocusLost:Connect(function(enter)
    if enter then
        teleportToPlayer(tpInput.Text)
    end
end)

-- ===== ISI TAB MISC =====
createModernButton(tabMisc, "Refresh ESP", "🔄", function()
    for p, _ in pairs(ESPTable) do ESPTable[p] = nil end
    for p, _ in pairs(SkeletonESP) do SkeletonESP[p] = nil end
    for _, p in pairs(Players:GetPlayers()) do
        createESP(p)
        createSkeleton(p)
    end
end)

createModernButton(tabMisc, "Copy TIKTOK", "📋", function()
    if setclipboard then
        setclipboard("putzz_mvpp")
    end
end)

createModernButton(tabMisc, "Destroy GUI", "🗑️", function()
    ScreenGui:Destroy()
end)

-- Credit
local credit = Instance.new("TextLabel")
credit.Parent = mainFrame
credit.Size = UDim2.new(1, 0, 0, 25)
credit.Position = UDim2.new(0, 0, 1, -25)
credit.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
credit.BackgroundTransparency = 0.3
credit.Text = "developer by putzz 🔥 | green line"
credit.TextColor3 = Color3.fromRGB(150, 150, 150)
credit.Font = Enum.Font.Gotham
credit.TextSize = 12

local creditCorner = Instance.new("UICorner")
creditCorner.Parent = credit
creditCorner.CornerRadius = UDim.new(0, 16)

-- Aktifkan tab pertama
tabs[1].BackgroundTransparency = 0.3
tabs[1].TextColor3 = Color3.fromRGB(255, 255, 255)
contents[1].Visible = true

-- ================= OPEN / CLOSE BUTTON =================
local openBtn = Instance.new("TextButton")
openBtn.Parent = ScreenGui
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 15, 0.5, -25)
openBtn.BackgroundColor3 = themeColor
openBtn.Text = "P"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 24
openBtn.AutoButtonColor = true
openBtn.ZIndex = 10

local corner = Instance.new("UICorner")
corner.Parent = openBtn
corner.CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke")
stroke.Parent = openBtn
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Thickness = 1.5

-- toggle
local menuOpen = true

openBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen

	if menuOpen then
		mainFrame.Visible = true
		TweenService:Create(mainFrame,TweenInfo.new(0.3),{
			Position = UDim2.new(0.5,-175,0.5,-225)
		}):Play()
	else
		TweenService:Create(mainFrame,TweenInfo.new(0.3),{
			Position = UDim2.new(0.5,-175,1,0)
		}):Play()

		task.wait(0.3)
		mainFrame.Visible = false
	end
end)

-- Animasi hover untuk tombol
openBtn.MouseEnter:Connect(function()
    TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

openBtn.MouseLeave:Connect(function()
    TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- Notifikasi masuk
local notif = Instance.new("Frame")
notif.Parent = ScreenGui
notif.Size = UDim2.new(0, 300, 0, 60)
notif.Position = UDim2.new(0.5, -150, 0, -70)
notif.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
notif.BackgroundTransparency = 0.1
notif.BorderSizePixel = 0
notif.ClipsDescendants = true

local notifCorner = Instance.new("UICorner")
notifCorner.Parent = notif
notifCorner.CornerRadius = UDim.new(0, 12)

local notifText = Instance.new("TextLabel")
notifText.Parent = notif
notifText.Size = UDim2.new(1, 0, 0.6, 0)
notifText.Position = UDim2.new(0, 0, 0, 5)
notifText.BackgroundTransparency = 1
notifText.Text = "✨ PutzzDev V3 ✨"
notifText.TextColor3 = themeColor
notifText.Font = Enum.Font.GothamBlack
notifText.TextSize = 20

local notifSub = Instance.new("TextLabel")
notifSub.Parent = notif
notifSub.Size = UDim2.new(1, 0, 0.3, 0)
notifSub.Position = UDim2.new(0, 0, 0, 35)
notifSub.BackgroundTransparency = 1
notifSub.Text = "Green Line Edition"
notifSub.TextColor3 = lineColor
notifSub.Font = Enum.Font.Gotham
notifSub.TextSize = 14

TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, 15)}):Play()
wait(2)
TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, -70)}):Play()
wait(0.5)
notif:Destroy()

print("✅ PutzzDev V3 Loaded! - Green Line Edition | Tekan 'P' untuk buka/tutup")