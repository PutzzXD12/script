-- ================== DRIP CLIENT V8 - COMPLETE ==================
-- Developer: Putzzdev
-- Database: key-database-701af
-- Website: https://putzzdevxit.github.io/KEY-GENERATOR-/

local DATABASE_URL = "https://key-database-701af-default-rtdb.asia-southeast1.firebasedatabase.app/keys.json"
local WEBSITE_URL = "https://putzzdevxit.github.io/KEY-GENERATOR-/"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Warna
local themeColor = Color3.fromRGB(156, 39, 176)
local darkPurple = Color3.fromRGB(74, 20, 90)
local boxColor = Color3.fromRGB(0, 255, 0)

-- Variabel Fitur
local espEnabled = false
local lineEnabled = false
local healthEnabled = false
local skeletonEnabled = false
local ESPTable = {}
local SkeletonESP = {}
local playerCounterEnabled = false
local enemyCountText = nil
local flyEnabled = false
local flyConnection = nil
local flySpeed = 50
local flyBodyVelocity = nil
local flyBodyGyro = nil
local verticalControl = 0
local horizontalControl = 0
local touching = false
local touchStartPos = nil
local noclipEnabled = false
local noclipConnection = nil
local speedEnabled = false
local normalSpeed = 16
local fastSpeed = 70
local infinityJumpEnabled = false
local crosshairEnabled = false
local crosshairObject = nil
local antiDamageEnabled = false
local antiDamageHeartbeat = nil
local spinEnabled = false
local spinSpeed = 200
local spinConnection = nil
local spinDirection = 1
local invisibleEnabled = false
local invisibleConnection = nil
local invisibleParts = {}
local invisibleRootPart = nil
local invisibleHumanoid = nil
local chamsEnabled = false
local chamsTransparency = 0.35
local chamsMaterial = Enum.Material.Neon
local colorSpeed = 2
local originalDataChams = {}
local chamsConnections = {}
local MAX_ESP_DISTANCE = 115

-- ================== FUNGSI KEY ==================
local function getKeysFromFirebase()
    local success, data = pcall(function()
        return game:HttpGet(DATABASE_URL, true)
    end)
    if success and data then
        local success2, jsonData = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success2 and jsonData then
            return jsonData
        end
    end
    return nil
end

local function checkKey(inputKey)
    local keysData = getKeysFromFirebase()
    if not keysData then
        return false
    end
    for id, keyData in pairs(keysData) do
        if keyData.key and string.upper(keyData.key) == string.upper(inputKey) then
            return true
        end
    end
    return false
end

-- ================== NOTIF ==================
local function showNotif(text, isError)
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "DripNotif"
        gui.Parent = game.CoreGui
        local frame = Instance.new("Frame")
        frame.Parent = gui
        frame.Size = UDim2.new(0, 300, 0, 60)
        frame.Position = UDim2.new(0.5, -150, 0, -80)
        frame.BackgroundColor3 = isError and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0, 100, 0)
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 12)
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        TweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
        task.wait(2)
        TweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, -80)}):Play()
        task.wait(0.5)
        gui:Destroy()
    end)
end

-- ================== GUI KEY ==================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "DripKeySystem"
KeyGui.Parent = game.CoreGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyGui
KeyFrame.Size = UDim2.new(0, 400, 0, 450)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
KeyFrame.BackgroundColor3 = darkPurple
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.Parent = KeyFrame
KeyCorner.CornerRadius = UDim.new(0, 20)

-- Header
local KeyIcon = Instance.new("TextLabel")
KeyIcon.Parent = KeyFrame
KeyIcon.Size = UDim2.new(1, 0, 0, 80)
KeyIcon.Position = UDim2.new(0, 0, 0, 20)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Text = "🔐"
KeyIcon.TextColor3 = themeColor
KeyIcon.Font = Enum.Font.GothamBlack
KeyIcon.TextSize = 50

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Position = UDim2.new(0, 0, 0, 80)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "DRIP CLIENT"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 20

-- Input Key
local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyTextBox.BackgroundTransparency = 0.1
KeyTextBox.TextColor3 = Color3.new(1, 1, 1)
KeyTextBox.PlaceholderText = "Masukkan key..."
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.TextSize = 14
KeyTextBox.ClearTextOnFocus = true

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.Parent = KeyTextBox
KeyBoxCorner.CornerRadius = UDim.new(0, 10)

-- Tombol Verifikasi
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = KeyFrame
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 45)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.48, 0)
VerifyBtn.BackgroundColor3 = themeColor
VerifyBtn.BackgroundTransparency = 0.2
VerifyBtn.Text = "VERIFIKASI"
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 16

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.Parent = VerifyBtn
VerifyCorner.CornerRadius = UDim.new(0, 10)

-- Tombol GET KEY (copy link website)
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = KeyFrame
GetKeyBtn.Size = UDim2.new(0.8, 0, 0, 40)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
GetKeyBtn.BackgroundTransparency = 0.2
GetKeyBtn.Text = "🌐 GET KEY"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.Parent = GetKeyBtn
GetKeyCorner.CornerRadius = UDim.new(0, 10)

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = KeyFrame
StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔑 Masukkan key"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12

-- Loading
local LoadingCircle = Instance.new("Frame")
LoadingCircle.Parent = KeyFrame
LoadingCircle.Size = UDim2.new(0, 30, 0, 30)
LoadingCircle.Position = UDim2.new(0.5, -15, 0.88, -15)
LoadingCircle.BackgroundColor3 = themeColor
LoadingCircle.BackgroundTransparency = 1
LoadingCircle.Visible = false

local CircleCorner = Instance.new("UICorner")
CircleCorner.Parent = LoadingCircle
CircleCorner.CornerRadius = UDim.new(1, 0)

local function showLoading(show)
    LoadingCircle.Visible = show
    if show then
        task.spawn(function()
            local rotation = 0
            while LoadingCircle and LoadingCircle.Visible do
                rotation = (rotation + 5) % 360
                LoadingCircle.Rotation = rotation
                task.wait(0.01)
            end
        end)
    end
end

-- Tombol GET KEY (copy link)
GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(WEBSITE_URL)
            StatusLabel.Text = "✅ Link website disalin!"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(2)
            StatusLabel.Text = "🔑 Masukkan key"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            StatusLabel.Text = "🌐 " .. WEBSITE_URL
            StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        end
    end)
end)

-- ================== VERIFIKASI ==================
VerifyBtn.MouseButton1Click:Connect(function()
    local inputKey = KeyTextBox.Text:gsub("%s+", "")
    if inputKey == "" then
        StatusLabel.Text = "❌ Masukkan key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1.5)
        StatusLabel.Text = "🔑 Masukkan key"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        return
    end
    
    showLoading(true)
    StatusLabel.Text = "⏳ Verifikasi..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local isValid = checkKey(inputKey)
    
    showLoading(false)
    
    if isValid then
        StatusLabel.Text = "✅ KEY VALID!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        TweenService:Create(KeyFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
        task.wait(0.5)
        KeyGui:Destroy()
        showNotif("✅ AKTIVASI BERHASIL!", false)
        task.wait(0.5)
        loadMainMenu()
    else
        StatusLabel.Text = "❌ KEY INVALID!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        for i = 1, 3 do
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(100, 0, 0)}):Play()
            task.wait(0.05)
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = darkPurple}):Play()
            task.wait(0.05)
        end
        task.wait(1.5)
        StatusLabel.Text = "🔑 Masukkan key"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        KeyTextBox.Text = ""
    end
end)

KeyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then VerifyBtn.MouseButton1Click:Fire() end
end)

-- ================== FLY MODE ==================
local function startFlyMode()
    local char = LocalPlayer.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    if not torso then return end
    if torso:FindFirstChild("FlyBV") then torso.FlyBV:Destroy() end
    if torso:FindFirstChild("FlyBG") then torso.FlyBG:Destroy() end
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Name = "FlyBV"
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Parent = torso
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.Name = "FlyBG"
    flyBodyGyro.P = 9e4
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.Parent = torso
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled then return end
        local currentChar = LocalPlayer.Character
        if not currentChar then return end
        local currentTorso = currentChar:FindFirstChild("UpperTorso") or currentChar:FindFirstChild("Torso") or currentChar:FindFirstChild("HumanoidRootPart")
        if not currentTorso then return end
        local bv = currentTorso:FindFirstChild("FlyBV")
        local bg = currentTorso:FindFirstChild("FlyBG")
        if not bv or not bg then return end
        local camCF = Camera.CFrame
        local forward = camCF.LookVector
        local right = camCF.RightVector
        local up = camCF.UpVector
        local moveDirection = forward
        if horizontalControl ~= 0 then
            local turnAngle = horizontalControl * 0.5
            moveDirection = (forward * math.cos(turnAngle) + right * math.sin(turnAngle)).Unit
        end
        local velocity = (moveDirection * flySpeed) + (up * verticalControl * flySpeed * 0.7)
        bv.Velocity = velocity
        bg.CFrame = camCF
    end)
end

local function stopFlyMode()
    flyEnabled = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
        if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        if torso then
            if torso:FindFirstChild("FlyBV") then torso.FlyBV:Destroy() end
            if torso:FindFirstChild("FlyBG") then torso.FlyBG:Destroy() end
        end
    end
    verticalControl = 0
    horizontalControl = 0
end

-- Touch control untuk fly (HP)
UserInputService.TouchBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        touching = true
        touchStartPos = input.Position
    end
end)

UserInputService.TouchMoved:Connect(function(input, gp)
    if gp then return end
    if not flyEnabled then return end
    if touching and touchStartPos then
        local delta = input.Position - touchStartPos
        verticalControl = math.abs(delta.Y) > 15 and (delta.Y < 0 and 1 or -1) or 0
        horizontalControl = math.abs(delta.X) > 15 and (delta.X < 0 and -1 or 1) or 0
        touchStartPos = input.Position
    end
end)

UserInputService.TouchEnded:Connect(function()
    touching = false
    verticalControl = 0
    horizontalControl = 0
end)

-- ================== CHAMS ==================
local function getRainbowColor()
    local t = tick() * colorSpeed % (math.pi * 2)
    return Color3.new(math.abs(math.sin(t)), math.abs(math.sin(t + 0.5)), math.abs(math.cos(t)))
end

local function applyChams(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    if chamsConnections[player] then chamsConnections[player]:Disconnect() end
    if not originalDataChams[player] then originalDataChams[player] = {} end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if not originalDataChams[player][part] then
                originalDataChams[player][part] = {Material = part.Material, Transparency = part.Transparency, Color = part.Color}
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
        local color = getRainbowColor()
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.Color = color
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
    if originalDataChams[player] then
        for part, data in pairs(originalDataChams[player]) do
            if part and part.Parent then
                pcall(function() part.Material = data.Material part.Transparency = data.Transparency part.Color = data.Color end)
            end
        end
        originalDataChams[player] = nil
    end
end

-- ================== CROSSHAIR ==================
local function createCrosshair()
    if crosshairObject then pcall(function() crosshairObject:Destroy() end) end
    local gui = Instance.new("ScreenGui")
    gui.Name = "DripCrosshair"
    gui.Parent = game.CoreGui
    local outer = Instance.new("Frame")
    outer.Parent = gui
    outer.Size = UDim2.new(0, 20, 0, 20)
    outer.Position = UDim2.new(0.5, -10, 0.5, -10)
    outer.BackgroundTransparency = 1
    outer.BorderSizePixel = 2
    outer.BorderColor3 = Color3.fromRGB(255, 255, 255)
    local outerCorner = Instance.new("UICorner")
    outerCorner.Parent = outer
    outerCorner.CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame")
    dot.Parent = gui
    dot.Size = UDim2.new(0, 4, 0, 4)
    dot.Position = UDim2.new(0.5, -2, 0.5, -2)
    dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    dot.BorderSizePixel = 0
    local dotCorner = Instance.new("UICorner")
    dotCorner.Parent = dot
    dotCorner.CornerRadius = UDim.new(1, 0)
    crosshairObject = gui
end

local function removeCrosshair()
    if crosshairObject then pcall(function() crosshairObject:Destroy() end) end
end

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
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * spinDirection), 0)
            end
        end)
    end
end

local function toggleSpinDirection() spinDirection = spinDirection * -1 end

-- ================== INVISIBLE ==================
local function updateInvisibleData()
    if LocalPlayer.Character then
        invisibleRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        invisibleHumanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        invisibleParts = {}
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency == 0 then table.insert(invisibleParts, v) end
        end
    end
end

local function toggleInvisible(state)
    invisibleEnabled = state
    if invisibleConnection then invisibleConnection:Disconnect() end
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
    else
        for _, v in pairs(invisibleParts) do v.Transparency = 0 end
    end
end

-- ================== GOD MODE ==================
local function setupAntiDamage()
    if antiDamageHeartbeat then antiDamageHeartbeat:Disconnect() end
    antiDamageHeartbeat = RunService.Heartbeat:Connect(function()
        if antiDamageEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        end
    end)
    local function onHealthChanged()
        if antiDamageEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.HealthChanged:Connect(function(newHealth)
                    if antiDamageEnabled and newHealth < hum.MaxHealth then hum.Health = hum.MaxHealth end
                end)
            end
        end
    end
    if LocalPlayer.Character then onHealthChanged() end
    LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); if antiDamageEnabled then onHealthChanged() end end)
end

-- ================== INFINITY JUMP ==================
UserInputService.JumpRequest:Connect(function()
    if infinityJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- ================== ESP ==================
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
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"LowerTorso", "HumanoidRootPart"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }
    for _, conn in pairs(connections) do
        local line = Drawing.new("Line")
        line.Thickness = 3
        line.Color = skeletonColor
        line.Visible = false
        table.insert(lines, {line, conn[1], conn[2]})
    end
    SkeletonESP[player] = lines
end

local function updateSkeleton(player, lines)
    local char = player.Character
    if not char then
        for _, ld in pairs(lines) do ld[1].Visible = false end
        return
    end
    for _, ld in pairs(lines) do
        local line, p1n, p2n = unpack(ld)
        local function findPart(n)
            if n == "UpperTorso" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
            if n == "LowerTorso" then return char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart") end
            if n == "LeftUpperArm" then return char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") end
            if n == "RightUpperArm" then return char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") end
            if n == "LeftUpperLeg" then return char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") end
            if n == "RightUpperLeg" then return char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") end
            if n == "LeftLowerArm" then return char:FindFirstChild("LeftLowerArm") or char:FindFirstChild("Left Arm") end
            if n == "RightLowerArm" then return char:FindFirstChild("RightLowerArm") or char:FindFirstChild("Right Arm") end
            if n == "LeftLowerLeg" then return char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("Left Leg") end
            if n == "RightLowerLeg" then return char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg") end
            return char:FindFirstChild(n)
        end
        local p1 = findPart(p1n)
        local p2 = findPart(p2n)
        if p1 and p2 then
            local pos1, v1 = Camera:WorldToViewportPoint(p1.Position)
            local pos2, v2 = Camera:WorldToViewportPoint(p2.Position)
            if v1 and v2 then
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

-- ================== PLAYER COUNTER ==================
local function createPlayerCounter()
    if enemyCountText then pcall(function() enemyCountText:Remove() end) end
    enemyCountText = Drawing.new("Text")
    enemyCountText.Size = 24
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
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
            if visible then count = count + 1 end
        end
    end
    enemyCountText.Text = "👥 PLAYER: " .. count
    enemyCountText.Visible = playerCounterEnabled
    enemyCountText.Position = Vector2.new(Camera.ViewportSize.X / 2, 50)
end

-- ================== RENDER ESP ==================
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
            else
                box.Visible = false
                name.Visible = false
                distText.Visible = false
                healthBg.Visible = false
                healthFg.Visible = false
            end
            if lineEnabled then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Visible = visible
                line.Color = themeColor
            else
                line.Visible = false
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
                    for _, ld in pairs(lines) do ld[1].Visible = false end
                end
            else
                for _, ld in pairs(lines) do ld[1].Visible = false end
            end
        end
    end
    if playerCounterEnabled then updatePlayerCounter() elseif enemyCountText then enemyCountText.Visible = false end
end)

-- Inisialisasi ESP
for _, p in pairs(Players:GetPlayers()) do createESP(p) createSkeleton(p) end
Players.PlayerAdded:Connect(function(p) createESP(p) createSkeleton(p) end)
Players.PlayerRemoving:Connect(function(p)
    if ESPTable[p] then
        for _, d in pairs(ESPTable[p]) do pcall(function() if d and d.Remove then d:Remove() end end) end
        ESPTable[p] = nil
    end
    if SkeletonESP[p] then
        for _, ld in pairs(SkeletonESP[p]) do pcall(function() if ld[1] and ld[1].Remove then ld[1]:Remove() end end) end
        SkeletonESP[p] = nil
    end
end)

-- Event Chams
Players.PlayerAdded:Connect(function(p)
    if chamsEnabled and p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() task.wait(0.5); if chamsEnabled then applyChams(p) end end)
        if p.Character then task.wait(0.5); applyChams(p) end
    end
end)
Players.PlayerRemoving:Connect(function(p) removeChams(p) end)

-- ================== MENU UTAMA ==================
local function loadMainMenu()
    createPlayerCounter()
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "DripClient"
    ScreenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = ScreenGui
    mainFrame.Size = UDim2.new(0, 380, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
    mainFrame.BackgroundColor3 = darkPurple
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.Parent = mainFrame
    mainCorner.CornerRadius = UDim.new(0, 20)
    
    local header = Instance.new("Frame")
    header.Parent = mainFrame
    header.Size = UDim2.new(1, 0, 0, 50)
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
    title.Text = "DRIP CLIENT V8"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 20
    
    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Parent = mainFrame
    tabBar.Size = UDim2.new(0.96, 0, 0, 35)
    tabBar.Position = UDim2.new(0.02, 0, 0.12, 0)
    tabBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tabBar.BackgroundTransparency = 0.3
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
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        btn.BackgroundTransparency = 0.5
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = btn
        btnCorner.CornerRadius = UDim.new(0, 8)
        
        local content = Instance.new("ScrollingFrame")
        content.Parent = mainFrame
        content.Size = UDim2.new(0.94, 0, 0.76, 0)
        content.Position = UDim2.new(0.03, 0, 0.2, 0)
        content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        content.BackgroundTransparency = 0.4
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 5
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.Visible = false
        content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        content.ScrollingDirection = Enum.ScrollingDirection.Y
        local contentCorner = Instance.new("UICorner")
        contentCorner.Parent = content
        contentCorner.CornerRadius = UDim.new(0, 12)
        local layout = Instance.new("UIListLayout")
        layout.Parent = content
        layout.Padding = UDim.new(0, 6)
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
                if child:IsA("Frame") then h = h + child.Size.Y.Offset + 6 end
            end
            content.CanvasSize = UDim2.new(0, 0, 0, h + 20)
        end)
        return content
    end
    
    local tabMain = createTab("MAIN", 1)
    local tabESP = createTab("ESP", 2)
    local tabUtil = createTab("UTIL", 3)
    local tabInfo = createTab("INFO", 4)
    
    local function createToggle(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.Size = UDim2.new(0.95, 0, 0, 38)
        frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 8)
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0.05, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        local switch = Instance.new("Frame")
        switch.Parent = frame
        switch.Size = UDim2.new(0, 38, 0, 18)
        switch.Position = UDim2.new(0.85, 0, 0.5, -9)
        switch.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        switch.BorderSizePixel = 0
        local switchCorner = Instance.new("UICorner")
        switchCorner.Parent = switch
        switchCorner.CornerRadius = UDim.new(0, 9)
        local circle = Instance.new("Frame")
        circle.Parent = switch
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = UDim2.new(0.05, 0, 0.5, -7)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.BorderSizePixel = 0
        local circleCorner = Instance.new("UICorner")
        circleCorner.Parent = circle
        circleCorner.CornerRadius = UDim.new(1, 0)
        local state = false
        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = state and themeColor or Color3.fromRGB(80, 80, 90)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0.05, 0, 0.5, -7)}):Play()
            callback(state)
        end)
        return frame
    end
    
    local function createButton(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.Size = UDim2.new(0.95, 0, 0, 38)
        frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 8)
        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.MouseButton1Click:Connect(callback)
        return frame
    end
    
    -- Slider Fly Speed
    local flyFrame = Instance.new("Frame")
    flyFrame.Parent = tabMain
    flyFrame.Size = UDim2.new(0.95, 0, 0, 45)
    flyFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    flyFrame.BackgroundTransparency = 0.2
    flyFrame.BorderSizePixel = 0
    local flyCorner = Instance.new("UICorner")
    flyCorner.Parent = flyFrame
    flyCorner.CornerRadius = UDim.new(0, 8)
    
    local flyLabel = Instance.new("TextLabel")
    flyLabel.Parent = flyFrame
    flyLabel.Size = UDim2.new(0.45, 0, 1, 0)
    flyLabel.Position = UDim2.new(0.05, 0, 0, 0)
    flyLabel.BackgroundTransparency = 1
    flyLabel.Text = "🚀 Fly: 50"
    flyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyLabel.Font = Enum.Font.Gotham
    flyLabel.TextSize = 11
    flyLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Parent = flyFrame
    sliderBar.Size = UDim2.new(0.35, 0, 0, 4)
    sliderBar.Position = UDim2.new(0.55, 0, 0.5, -2)
    sliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
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
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    sliderBtn.Position = UDim2.new(0.5, -7, 0.5, -7)
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
            sliderBtn.Position = UDim2.new(percent, -7, 0.5, -7)
            flySpeed = math.floor(percent * 80 + 20)
            flyLabel.Text = "🚀 Fly: " .. flySpeed
        end
    end)
    
    -- MAIN TAB
    createToggle(tabMain, "✈️ FLY MODE", function(s) flyEnabled = s; if s then startFlyMode() else stopFlyMode() end end)
    createToggle(tabMain, "⚡ SPEED BOOST", function(s)
        speedEnabled = s
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = s and fastSpeed or normalSpeed end
        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and speedEnabled then hum.WalkSpeed = fastSpeed end
        end)
    end)
    createToggle(tabMain, "🌀 NOCLIP", function(s) noclipEnabled = s; if s then startNoclip() else stopNoclip() end end)
    createToggle(tabMain, "🦘 INFINITY JUMP", function(s) infinityJumpEnabled = s end)
    createToggle(tabMain, "🎯 CROSSHAIR", function(s) if s then createCrosshair() else removeCrosshair() end end)
    
    -- ESP TAB
    createToggle(tabESP, "📦 ESP BOX", function(s) espEnabled = s end)
    createToggle(tabESP, "📏 ESP LINE", function(s) lineEnabled = s end)
    createToggle(tabESP, "❤️ HEALTH BAR", function(s) healthEnabled = s end)
    createToggle(tabESP, "🦴 SKELETON", function(s) skeletonEnabled = s end)
    createToggle(tabESP, "👥 PLAYER COUNTER", function(s)
        playerCounterEnabled = s
        if s then createPlayerCounter() updatePlayerCounter() elseif enemyCountText then enemyCountText.Visible = false end
    end)
    createToggle(tabESP, "✨ HOLOGRAM", function(s)
        chamsEnabled = s
        if s then
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then applyChams(p) end end
        else
            for _, p in pairs(Players:GetPlayers()) do removeChams(p) end
        end
    end)
    
    -- UTILITY TAB
    createToggle(tabUtil, "💀 GOD MODE", function(s) antiDamageEnabled = s; if s then setupAntiDamage() elseif antiDamageHeartbeat then antiDamageHeartbeat:Disconnect() end end)
    createToggle(tabUtil, "🌀 SPIN", function(s) toggleSpin(s) end)
    createButton(tabUtil, "🔄 GANTI ARAH SPIN", function() toggleSpinDirection() end)
    createToggle(tabUtil, "👻 INVISIBLE", function(s) toggleInvisible(s) end)
    
    -- INFO TAB
    local infoFrame = Instance.new("Frame")
    infoFrame.Parent = tabInfo
    infoFrame.Size = UDim2.new(0.95, 0, 0, 160)
    infoFrame.Position = UDim2.new(0.025, 0, 0, 10)
    infoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    infoFrame.BackgroundTransparency = 0.3
    infoFrame.BorderSizePixel = 0
    local infoCorner = Instance.new("UICorner")
    infoCorner.Parent = infoFrame
    infoCorner.CornerRadius = UDim.new(0, 12)
    
    local infoText = Instance.new("TextLabel")
    infoText.Parent = infoFrame
    infoText.Size = UDim2.new(1, 0, 1, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "DRIP CLIENT V8\n\nDEVELOPER: Putzzdev\n\n© 2024"
    infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoText.Font = Enum.Font.Gotham
    infoText.TextSize = 13
    infoText.TextWrapped = true
    
    -- Show first tab
    tabs[1].TextColor3 = Color3.fromRGB(255, 255, 255)
    tabs[1].BackgroundTransparency = 0.2
    contents[1].Visible = true
    
    -- Tombol Toggle Menu (DRIP) di pojok kiri
    local menuBtn = Instance.new("TextButton")
    menuBtn.Parent = ScreenGui
    menuBtn.Size = UDim2.new(0, 80, 0, 35)
    menuBtn.Position = UDim2.new(0, 10, 0.5, -17)
    menuBtn.BackgroundColor3 = themeColor
    menuBtn.BackgroundTransparency = 0.2
    menuBtn.Text = "🔓 DRIP"
    menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    menuBtn.Font = Enum.Font.GothamBlack
    menuBtn.TextSize = 12
    menuBtn.ZIndex = 10
    menuBtn.Draggable = true
    local menuCorner = Instance.new("UICorner")
    menuCorner.Parent = menuBtn
    menuCorner.CornerRadius = UDim.new(0, 10)
    
    local menuVisible = true
    menuBtn.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        mainFrame.Visible = menuVisible
        if menuVisible then
            TweenService:Create(mainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -190, 0.5, -240)}):Play()
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -190, 1, 0)}):Play()
            task.wait(0.2)
        end
    end)
    
    showNotif("✅ DRIP CLIENT V8 ACTIVATED! Klik DRIP di pojok kiri", false)
    print("✅ DRIP CLIENT V8 LOADED!")
end

print("🔐 DRIP CLIENT V8 - READY!")