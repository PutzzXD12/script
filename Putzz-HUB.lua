--// PUTZZDEV-HUB V3 (ULTIMATE EDITION)
-- Desain: Modern Glassmorphism + Neon Effects
-- Ukuran: 400x500, Support HP & PC

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
local accentColor = Color3.fromRGB(255, 50, 100) -- Pink

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

-- ================== FUNGSI ESP SUPER ==================
local function createESP(player)
    if player == LocalPlayer then return end

    -- BOX UTAMA (Neon)
    local box = Drawing.new("Square")
    box.Thickness = 3
    box.Color = themeColor
    box.Filled = false
    box.Visible = false
    box.Transparency = 0.2

    -- BOX GLOW (efek neon)
    local boxGlow = Drawing.new("Square")
    boxGlow.Thickness = 1
    boxGlow.Color = Color3.fromRGB(255, 255, 255)
    boxGlow.Filled = false
    boxGlow.Visible = false
    boxGlow.Transparency = 0.6

    -- LINE (Putus-putus dengan glow)
    local dots = {}
    for i = 1, 15 do
        local dot = Drawing.new("Line")
        dot.Thickness = 3
        dot.Color = themeColor
        dot.Transparency = 0.3
        dot.Visible = false
        table.insert(dots, dot)
    end

    -- NAMA (Dengan shadow)
    local name = Drawing.new("Text")
    name.Size = 18
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Center = true
    name.Outline = true
    name.OutlineColor = themeColor
    name.Visible = false

    -- JARAK
    local dist = Drawing.new("Text")
    dist.Size = 14
    dist.Color = Color3.fromRGB(200, 200, 200)
    dist.Center = true
    dist.Outline = true
    dist.OutlineColor = Color3.fromRGB(0, 0, 0)
    dist.Visible = false

    -- HEALTH BAR (Glassmorphism)
    local healthBg = Drawing.new("Square")
    healthBg.Thickness = 1
    healthBg.Color = Color3.fromRGB(40, 40, 50)
    healthBg.Filled = true
    healthBg.Transparency = 0.3
    healthBg.Visible = false

    local healthFg = Drawing.new("Square")
    healthFg.Thickness = 0
    healthFg.Color = Color3.fromRGB(0, 255, 100)
    healthFg.Filled = true
    healthFg.Visible = false

    ESPTable[player] = {box, boxGlow, name, dist, dots, healthBg, healthFg}
end

-- ================== ESP SKELETON NEON ==================
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
        line.Thickness = 3
        line.Color = accentColor
        line.Transparency = 0.2
        line.Visible = false
        
        local lineGlow = Drawing.new("Line")
        lineGlow.Thickness = 1
        lineGlow.Color = Color3.fromRGB(255, 255, 255)
        lineGlow.Transparency = 0.5
        lineGlow.Visible = false
        
        table.insert(lines, {line, lineGlow, connections[i][1], connections[i][2]})
    end
    
    SkeletonESP[player] = lines
end

-- Update skeleton
local function updateSkeleton(player, lines)
    local char = player.Character
    if not char then
        for _, lineData in pairs(lines) do
            lineData[1].Visible = false
            lineData[2].Visible = false
        end
        return
    end
    
    for _, lineData in pairs(lines) do
        local line, lineGlow, part1Name, part2Name = unpack(lineData)
        local part1 = char:FindFirstChild(part1Name) or char:FindFirstChild(part1Name:gsub("Upper", ""):gsub("Lower", ""))
        local part2 = char:FindFirstChild(part2Name) or char:FindFirstChild(part2Name:gsub("Upper", ""):gsub("Lower", ""))
        
        if part1 and part2 then
            local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)
            
            if vis1 and vis2 then
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                lineGlow.From = Vector2.new(pos1.X, pos1.Y)
                lineGlow.To = Vector2.new(pos2.X, pos2.Y)
                line.Visible = skeletonEnabled
                lineGlow.Visible = skeletonEnabled
                line.Color = accentColor
            else
                line.Visible = false
                lineGlow.Visible = false
            end
        else
            line.Visible = false
            lineGlow.Visible = false
        end
    end
end

-- ================== RENDER STEP ==================
RunService.RenderStepped:Connect(function()
    -- ESP Box
    for player, esp in pairs(ESPTable) do
        local box, boxGlow, name, dist, dots, healthBg, healthFg = unpack(esp)

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
                    -- BOX dengan efek glow
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width/2, top.Y)
                    box.Visible = true
                    
                    boxGlow.Size = Vector2.new(width-2, height-2)
                    boxGlow.Position = Vector2.new(pos.X - (width-2)/2, top.Y + 1)
                    boxGlow.Visible = true

                    -- NAMA dengan warna tema
                    name.Position = Vector2.new(pos.X, top.Y - 22)
                    name.Text = player.Name
                    name.Visible = true

                    -- JARAK
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local distance = (myChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                        dist.Text = math.floor(distance).."m"
                        dist.Position = Vector2.new(pos.X, bottom.Y + 8)
                        dist.Visible = true
                    end

                    -- LINE PUTUS-PUTUS
                    if lineEnabled then
                        local startPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        local endPos = Vector2.new(pos.X, pos.Y)
                        local direction = (endPos - startPos).Unit
                        local distance = (endPos - startPos).Magnitude
                        
                        local segmentLength = 12
                        local gapLength = 6
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

                    -- HEALTH BAR GLASS
                    if healthEnabled and humanoid then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local barWidth = width * 0.8
                        local barHeight = 5
                        local barX = pos.X - barWidth/2
                        local barY = top.Y - 28

                        healthBg.Size = Vector2.new(barWidth, barHeight)
                        healthBg.Position = Vector2.new(barX, barY)
                        healthBg.Visible = true

                        healthFg.Size = Vector2.new(barWidth * healthPercent, barHeight)
                        healthFg.Position = Vector2.new(barX, barY)
                        healthFg.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 50)
                        healthFg.Visible = true
                    else
                        healthBg.Visible = false
                        healthFg.Visible = false
                    end
                else
                    box.Visible = false
                    boxGlow.Visible = false
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
                boxGlow.Visible = false
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
                lineData[2].Visible = false
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

-- ================== GUI MODERN GLASSMORPHISM ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PutzzdevHub_V3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100

-- ===== MAIN CONTAINER =====
local mainFrame = Instance.new("Frame")
mainFrame.Parent = ScreenGui
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
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

-- BLUR (optional - butuh Topbar)
pcall(function()
    local blur = Instance.new("BlurEffect")
    blur.Parent = game:GetService("Lighting")
    blur.Size = 8
end)

-- CORNER
local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 20)

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
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.Parent = header
headerCorner.CornerRadius = UDim.new(0, 20)

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
title.TextSize = 32
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = themeColor

local titleShadow = Instance.new("TextLabel")
titleShadow.Parent = header
titleShadow.Size = UDim2.new(1, 2, 1, 2)
titleShadow.Position = UDim2.new(0, 2, 0, 2)
titleShadow.BackgroundTransparency = 1
titleShadow.Text = "PUTZZDEV"
titleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
titleShadow.Font = Enum.Font.GothamBlack
titleShadow.TextSize = 32
titleShadow.TextTransparency = 0.5

-- ===== CONTROL BUTTONS =====
local closeBtn = Instance.new("ImageButton")
closeBtn.Parent = header
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Image = "rbxassetid://6031280882"
closeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = closeBtn
closeCorner.CornerRadius = UDim.new(0, 10)

local minBtn = Instance.new("ImageButton")
minBtn.Parent = header
minBtn.Size = UDim2.new(0, 35, 0, 35)
minBtn.Position = UDim2.new(1, -90, 0.5, -17.5)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minBtn.BackgroundTransparency = 0.3
minBtn.Image = "rbxassetid://6031280882"
minBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)

local minCorner = Instance.new("UICorner")
minCorner.Parent = minBtn
minCorner.CornerRadius = UDim.new(0, 10)

-- ===== TAB BAR MODERN =====
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.Size = UDim2.new(1, -20, 0, 50)
tabBar.Position = UDim2.new(0, 10, 0, 80)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabBar.BackgroundTransparency = 0.3
tabBar.BorderSizePixel = 0

local tabCorner = Instance.new("UICorner")
tabCorner.Parent = tabBar
tabCorner.CornerRadius = UDim.new(0, 12)

local tabs = {}
local contents = {}

local function createTab(name, icon, idx)
    local btn = Instance.new("TextButton")
    btn.Parent = tabBar
    btn.Size = UDim2.new(0.25, -2, 1, -10)
    btn.Position = UDim2.new((idx-1)*0.25, 5, 0, 5)
    btn.BackgroundColor3 = themeColor
    btn.BackgroundTransparency = 0.7
    btn.Text = icon.." "..name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 10)

    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1, -20, 1, -150)
    content.Position = UDim2.new(0, 10, 0, 140)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 5
    content.ScrollBarImageColor3 = themeColor
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

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
    frame.Size = UDim2.new(0.95, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 12)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = frame
    iconLabel.Size = UDim2.new(0, 40, 1, 0)
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = themeColor
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 24

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(1, -50, 1, 0)
    btn.Position = UDim2.new(0, 50, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseButton1Click:Connect(callback)
    return frame
end

-- ===== FUNGSI TOGGLE MODERN =====
local function createModernToggle(parent, text, icon, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.95, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 12)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = frame
    iconLabel.Size = UDim2.new(0, 40, 1, 0)
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = themeColor
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 24

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, -40, 1, 0)
    label.Position = UDim2.new(0, 50, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggle switch modern
    local switch = Instance.new("Frame")
    switch.Parent = frame
    switch.Size = UDim2.new(0, 50, 0, 26)
    switch.Position = UDim2.new(1, -60, 0.5, -13)
    switch.BackgroundColor3 = default and themeColor or Color3.fromRGB(80, 80, 90)
    switch.BorderSizePixel = 0

    local switchCorner = Instance.new("UICorner")
    switchCorner.Parent = switch
    switchCorner.CornerRadius = UDim.new(0, 13)

    local circle = Instance.new("Frame")
    circle.Parent = switch
    circle.Size = UDim2.new(0, 22, 0, 22)
    circle.Position = default and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0.05, 0, 0.5, -11)
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
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0.05, 0, 0.5, -11)}):Play()
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

createModernToggle(tabMain, "Invisible Mode", "👻", false, function(s)
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
tpFrame.Size = UDim2.new(0.95, 0, 0, 100)
tpFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tpFrame.BackgroundTransparency = 0.3
tpFrame.BorderSizePixel = 0

local tpCorner = Instance.new("UICorner")
tpCorner.Parent = tpFrame
tpCorner.CornerRadius = UDim.new(0, 12)

local tpTitle = Instance.new("TextLabel")
tpTitle.Parent = tpFrame
tpTitle.Size = UDim2.new(1, -20, 0, 30)
tpTitle.Position = UDim2.new(0, 10, 0, 10)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "📞 Teleport ke Player"
tpTitle.TextColor3 = themeColor
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 16
tpTitle.TextXAlignment = Enum.TextXAlignment.Left

local tpInput = Instance.new("TextBox")
tpInput.Parent = tpFrame
tpInput.Size = UDim2.new(0.7, -10, 0, 40)
tpInput.Position = UDim2.new(0, 10, 0, 45)
tpInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
tpInput.PlaceholderText = "Nama player..."
tpInput.Text = ""
tpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
tpInput.Font = Enum.Font.Gotham
tpInput.TextSize = 16

local tpInputCorner = Instance.new("UICorner")
tpInputCorner.Parent = tpInput
tpInputCorner.CornerRadius = UDim.new(0, 8)

local tpBtn = Instance.new("TextButton")
tpBtn.Parent = tpFrame
tpBtn.Size = UDim2.new(0.25, -5, 0, 40)
tpBtn.Position = UDim2.new(0.75, 0, 0, 45)
tpBtn.BackgroundColor3 = themeColor
tpBtn.BackgroundTransparency = 0.2
tpBtn.Text = "GO"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 18

local tpBtnCorner = Instance.new("UICorner")
tpBtnCorner.Parent = tpBtn
tpBtnCorner.CornerRadius = UDim.new(0, 8)

tpBtn.MouseButton1Click:Connect(function()
    local targetName = tpInput.Text
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName:lower()) then
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
            end
            break
        end
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

-- Credit
local credit = Instance.new("TextLabel")
credit.Parent = mainFrame
credit.Size = UDim2.new(1, 0, 0, 30)
credit.Position = UDim2.new(0, 0, 1, -30)
credit.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
credit.BackgroundTransparency = 0.3
credit.Text = "developer by putzz 🔥"
credit.TextColor3 = Color3.fromRGB(150, 150, 150)
credit.Font = Enum.Font.Gotham
credit.TextSize = 14

local creditCorner = Instance.new("UICorner")
creditCorner.Parent = credit
creditCorner.CornerRadius = UDim.new(0, 20)

-- Set canvas size
local function updateCanvas()
    for _, content in pairs(contents) do
        local height = 0
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("Frame") then
                height = height + child.Size.Y.Offset + 10
            end
        end
        content.CanvasSize = UDim2.new(0, 0, 0, height + 20)
    end
end

wait(0.1)
updateCanvas()

-- Aktifkan tab pertama
tabs[1].BackgroundTransparency = 0.3
tabs[1].TextColor3 = Color3.fromRGB(255, 255, 255)
contents[1].Visible = true

-- Button functions
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Toggle button (Floating)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Parent = ScreenGui
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
toggleBtn.BackgroundColor3 = themeColor
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.Image = "rbxassetid://6031280882"
toggleBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Visible = false

local toggleCorner = Instance.new("UICorner")
toggleCorner.Parent = toggleBtn
toggleCorner.CornerRadius = UDim.new(1, 0)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    toggleBtn.Visible = false
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
notifCorner.CornerRadius = UDim.new(0, 15)

local notifText = Instance.new("TextLabel")
notifText.Parent = notif
notifText.Size = UDim2.new(1, 0, 1, 0)
notifText.BackgroundTransparency = 1
notifText.Text = "✨ PutzzDev V3 Loaded! ✨"
notifText.TextColor3 = themeColor
notifText.Font = Enum.Font.GothamBold
notifText.TextSize = 18

TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
wait(2)
TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, -70)}):Play()
wait(0.5)
notif:Destroy()

print("✅ PutzzDev V3 Loaded! - Desain Glassmorphism + Neon")