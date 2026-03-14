-- ================== PUTZZDEV-HUB DENGAN KEY SYSTEM ==================
-- Version: 4.3 (FIXED - Verifikasi Langsung Jalan)
-- Developer: Putzz XD

-- ================== KEY SYSTEM CONFIG ==================
local KEY_URL = "https://pastebin.com/raw/WfYtM2kY"  -- URL RAW Pastebin berisi key
local WEBSITE_URL = "https://putzzdevxit.github.io/KEY-GENERATOR-/"  -- Website untuk ambil key
local SCRIPT_NAME = "Putzzdev-HUB"

-- ATUR EXPIRY DI SINI (pakai format: "1d", "2d", "3d", "7d", "30d")
local KEY_EXPIRY = {
    ["PUTZZDEV-HUB-X7K9-1D"] = "1d",  -- 1 hari (key di screenshot)
    ["Putzzdev-KEYpertama"] = "3d",   -- 3 hari
    ["Putzzdev-KEYkedua"]   = "2d",   -- 2 hari
    ["Putzzdev-VIP"]        = "7d",   -- 7 hari
    ["Putzzdev-ADMIN"]      = "30d"   -- 30 hari
}

-- File untuk menyimpan data key (otomatis)
local SAVE_FILE = "putzz_key_data.txt"

-- Database key yang sudah aktif
local activeKeys = {}

-- Variabel untuk menyimpan key yang sedang digunakan
local currentUserKey = nil
local keyExpiryTime = 0

-- ================== LOAD SERVICES ==================
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

-- AIMBOT
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotFOV = 150
local aimbotSmoothness = 5
local aimbotPart = "Head"

-- INFINITY JUMP
local infinityJumpEnabled = false
local jumpCount = 0

-- ================== FUNGSI KEY SYSTEM ==================

-- Konversi format expiry (contoh: "3d" -> 3 hari)
local function parseExpiry(expiryStr)
    local num = expiryStr:match("(%d+)")
    return tonumber(num) or 0
end

-- Load data key dari file
local function loadKeyData()
    if isfile and isfile(SAVE_FILE) then
        local success, content = pcall(function()
            return readfile(SAVE_FILE)
        end)
        if success and content and content ~= "" then
            local success2, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(content)
            end)
            if success2 then
                activeKeys = data
            end
        end
    end
end

-- Save data key ke file
local function saveKeyData()
    if writefile then
        local success, json = pcall(function()
            return game:GetService("HttpService"):JSONEncode(activeKeys)
        end)
        if success then
            writefile(SAVE_FILE, json)
        end
    end
end

-- Fungsi ambil key dari Pastebin
local function getKeysFromPastebin()
    local success, data = pcall(function()
        return game:HttpGet(KEY_URL)
    end)
    
    if success and data then
        local keys = {}
        for key in data:gmatch("[^\r\n]+") do
            table.insert(keys, key:gsub("%s+", ""))
        end
        return keys
    end
    return nil
end

-- Fungsi dapatkan sisa waktu dalam format hari dan jam
local function getTimeRemaining(expiryTimestamp)
    local currentTime = os.time()
    local remaining = expiryTimestamp - currentTime
    
    if remaining <= 0 then
        return 0, 0, "Expired"
    end
    
    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    
    if days > 0 then
        return days, hours, days .. " hari " .. hours .. " jam"
    else
        return 0, hours, hours .. " jam"
    end
end

-- Fungsi cek expiry key (VERSI SEDERHANA - PASTI JALAN)
local function checkKeyExpiry(inputKey)
    -- Load data key dari file
    loadKeyData()
    
    -- CEK LANGSUNG KE KEY_EXPIRY (TANPA CEK PASTEBIN DULU)
    -- Ini biar cepet dan ga error
    if KEY_EXPIRY[inputKey] then
        local expiryDays = parseExpiry(KEY_EXPIRY[inputKey])
        
        -- Cek apakah key sudah pernah dipakai
        if activeKeys[inputKey] then
            -- Key sudah dipakai, cek expiry
            local firstUsed = activeKeys[inputKey].firstUsed
            local currentTime = os.time()
            local expiryTime = firstUsed + (expiryDays * 86400)
            
            if currentTime > expiryTime then
                return false, "Key sudah expired! (" .. expiryDays .. " hari)"
            else
                local days, hours, timeStr = getTimeRemaining(expiryTime)
                keyExpiryTime = expiryTime
                currentUserKey = inputKey
                return true, "Key valid! Sisa " .. timeStr
            end
        else
            -- Key baru pertama kali dipakai
            local currentTime = os.time()
            activeKeys[inputKey] = {
                firstUsed = currentTime,
                key = inputKey,
                expiryDays = expiryDays
            }
            saveKeyData()
            
            local expiryTime = currentTime + (expiryDays * 86400)
            keyExpiryTime = expiryTime
            currentUserKey = inputKey
            
            return true, "Key valid! Berlaku " .. expiryDays .. " hari"
        end
    else
        return false, "Key tidak terdaftar!"
    end
end

-- Fungsi notifikasi
local function showNotification(title, text, duration, color)
    local notif = Instance.new("Frame")
    notif.Parent = KeyGui
    notif.Size = UDim2.new(0, 300, 0, 70)
    notif.Position = UDim2.new(0.5, -150, 0, -80)
    notif.BackgroundColor3 = color or Color3.fromRGB(30, 30, 40)
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.ZIndex = 999

    local notifCorner = Instance.new("UICorner")
    notifCorner.Parent = notif
    notifCorner.CornerRadius = UDim.new(0, 12)

    local notifTitle = Instance.new("TextLabel")
    notifTitle.Parent = notif
    notifTitle.Size = UDim2.new(1, 0, 0.5, 0)
    notifTitle.Position = UDim2.new(0, 0, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.new(1, 1, 1)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 18

    local notifText = Instance.new("TextLabel")
    notifText.Parent = notif
    notifText.Size = UDim2.new(1, 0, 0.5, 0)
    notifText.Position = UDim2.new(0, 0, 0, 35)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.new(1, 1, 1)
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 14

    TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
    task.wait(duration or 3)
    TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, -80)}):Play()
    task.wait(0.5)
    notif:Destroy()
end

-- ================== BUAT GUI KEY SYSTEM ==================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "PutzzKeySystem"
KeyGui.Parent = game.CoreGui
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.DisplayOrder = 999

-- Frame utama key system
local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyGui
KeyFrame.Size = UDim2.new(0, 400, 0, 400)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.Parent = KeyFrame
KeyCorner.CornerRadius = UDim.new(0, 16)

-- Gradient
local KeyGradient = Instance.new("UIGradient")
KeyGradient.Parent = KeyFrame
KeyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
})
KeyGradient.Rotation = 45

-- Header
local KeyHeader = Instance.new("Frame")
KeyHeader.Parent = KeyFrame
KeyHeader.Size = UDim2.new(1, 0, 0, 80)
KeyHeader.BackgroundTransparency = 1

local KeyIcon = Instance.new("TextLabel")
KeyIcon.Parent = KeyHeader
KeyIcon.Size = UDim2.new(1, 0, 0.5, 0)
KeyIcon.Position = UDim2.new(0, 0, 0, 5)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Text = "🔐"
KeyIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
KeyIcon.Font = Enum.Font.GothamBlack
KeyIcon.TextSize = 40

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyHeader
KeyTitle.Size = UDim2.new(1, 0, 0.5, 0)
KeyTitle.Position = UDim2.new(0, 0, 0, 45)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = SCRIPT_NAME .. " KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.TextSize = 18
KeyTitle.TextStrokeTransparency = 0.5

-- Info Box
local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = KeyFrame
InfoFrame.Size = UDim2.new(0.9, 0, 0, 80)
InfoFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
InfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
InfoFrame.BackgroundTransparency = 0.3
InfoFrame.BorderSizePixel = 0

local InfoCorner = Instance.new("UICorner")
InfoCorner.Parent = InfoFrame
InfoCorner.CornerRadius = UDim.new(0, 10)

local InfoText = Instance.new("TextLabel")
InfoText.Parent = InfoFrame
InfoText.Size = UDim2.new(1, -20, 1, -10)
InfoText.Position = UDim2.new(0, 10, 0, 5)
InfoText.BackgroundTransparency = 1
InfoText.Text = "📢 Cara Dapat Key:\n1. Klik tombol '🔑 GET KEY'\n2. Copy key dari website\n3. Masukkan key dan klik VERIFY"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 13
InfoText.TextWrapped = true
InfoText.TextXAlignment = Enum.TextXAlignment.Left

-- TextBox untuk key
local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.Position = UDim2.new(0.1, 0, 0.48, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyTextBox.TextColor3 = Color3.new(1, 1, 1)
KeyTextBox.PlaceholderText = "Masukkan key disini..."
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.TextSize = 16
KeyTextBox.ClearTextOnFocus = false

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.Parent = KeyTextBox
KeyBoxCorner.CornerRadius = UDim.new(0, 8)

-- Tombol Verify
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = KeyFrame
VerifyBtn.Size = UDim2.new(0.5, 0, 0, 45)
VerifyBtn.Position = UDim2.new(0.25, 0, 0.62, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
VerifyBtn.Text = "✅ VERIFY"
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 16

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.Parent = VerifyBtn
VerifyCorner.CornerRadius = UDim.new(0, 8)

-- Tombol Website
local WebsiteBtn = Instance.new("TextButton")
WebsiteBtn.Parent = KeyFrame
WebsiteBtn.Size = UDim2.new(0.5, 0, 0, 35)
WebsiteBtn.Position = UDim2.new(0.25, 0, 0.78, 0)
WebsiteBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
WebsiteBtn.Text = "🔑 GET KEY"
WebsiteBtn.TextColor3 = Color3.new(1, 1, 1)
WebsiteBtn.Font = Enum.Font.GothamBold
WebsiteBtn.TextSize = 14

local WebsiteCorner = Instance.new("UICorner")
WebsiteCorner.Parent = WebsiteBtn
WebsiteCorner.CornerRadius = UDim.new(0, 6)

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = KeyFrame
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Menunggu key..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13
StatusLabel.TextWrapped = true

-- Loading Circle
local LoadingCircle = Instance.new("Frame")
LoadingCircle.Parent = KeyFrame
LoadingCircle.Size = UDim2.new(0, 30, 0, 30)
LoadingCircle.Position = UDim2.new(0.5, -15, 0.85, -15)
LoadingCircle.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
LoadingCircle.BackgroundTransparency = 1
LoadingCircle.Visible = false

local CircleCorner = Instance.new("UICorner")
CircleCorner.Parent = LoadingCircle
CircleCorner.CornerRadius = UDim.new(1, 0)

-- Fungsi loading animation
local function showLoading(show)
    LoadingCircle.Visible = show
    if show then
        spawn(function()
            local rotation = 0
            while LoadingCircle.Visible do
                rotation = (rotation + 5) % 360
                LoadingCircle.Rotation = rotation
                task.wait(0.01)
            end
        end)
    end
end

-- Event tombol website
WebsiteBtn.MouseButton1Click:Connect(function()
    local success = pcall(function()
        if setclipboard then
            setclipboard(WEBSITE_URL)
            StatusLabel.Text = "✅ Link sudah di copy! Buka browser"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            StatusLabel.Text = "🌐 Website: " .. WEBSITE_URL
            StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        end
    end)
end)

-- ================== FUNGSI UTAMA ==================
local function loadMainScript()
    -- Hapus GUI key
    KeyGui:Destroy()
    
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

    -- ================== FUNGSI TELEPORT ==================
    local function teleportToPlayer(username)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(username:lower()) then
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    end
                end
                break
            end
        end
    end

    -- ================== FUNGSI ESP ==================
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

    -- ================== FUNGSI AIMBOT ==================
    local function getClosestEnemy()
        local closest = nil
        local shortestDistance = aimbotFOV
        local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
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
        
        return closest
    end

    -- Rainbow color
    local hue = 0
    RunService.RenderStepped:Connect(function()
        hue = (hue + 0.01) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        
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
                        line.Color = rainbowColor
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
        
        if aimbotEnabled then
            local target = getClosestEnemy()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local targetPos = target.Character.Head.Position
                local cameraPos = Camera.CFrame.Position
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(cameraPos, targetPos), 0.2)
            end
        end
    end)

    -- Inisialisasi player
    for _, p in pairs(Players:GetPlayers()) do
        createESP(p)
    end

    Players.PlayerAdded:Connect(function(p)
        createESP(p)
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

    -- ================== GUI UTAMA ==================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "PutzzdevHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = ScreenGui
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local corner = Instance.new("UICorner")
    corner.Parent = mainFrame
    corner.CornerRadius = UDim.new(0, 16)

    -- Header
    local header = Instance.new("Frame")
    header.Parent = mainFrame
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1

    local title = Instance.new("TextLabel")
    title.Parent = header
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "Putzzdev-HUB"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24

    -- Timer
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Parent = mainFrame
    timerLabel.Size = UDim2.new(0.9, 0, 0, 30)
    timerLabel.Position = UDim2.new(0.05, 0, 0.12, 0)
    timerLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    timerLabel.BackgroundTransparency = 0.3
    timerLabel.Text = "Sisa waktu: -"
    timerLabel.TextColor3 = Color3.new(1, 1, 1)
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.TextSize = 14

    local timerCorner = Instance.new("UICorner")
    timerCorner.Parent = timerLabel

    -- Update timer
    spawn(function()
        while task.wait(1) do
            if currentUserKey and keyExpiryTime > 0 then
                local days, hours, timeStr = getTimeRemaining(keyExpiryTime)
                timerLabel.Text = "⏳ Sisa: " .. timeStr
                timerLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
        end
    end)

    -- Tab bar
    local tabBar = Instance.new("Frame")
    tabBar.Parent = mainFrame
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 60)
    tabBar.BackgroundTransparency = 1

    -- Toggle Fly
    local flyToggle = Instance.new("TextButton")
    flyToggle.Parent = mainFrame
    flyToggle.Size = UDim2.new(0.9, 0, 0, 40)
    flyToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
    flyToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    flyToggle.Text = "🦅 Fly: OFF"
    flyToggle.TextColor3 = Color3.new(1, 1, 1)
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 16

    local flyCorner = Instance.new("UICorner")
    flyCorner.Parent = flyToggle

    flyToggle.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        flyToggle.Text = flyEnabled and "🦅 Fly: ON" or "🦅 Fly: OFF"
        if flyEnabled then startFly() else stopFly() end
    end)

    -- Toggle Speed
    local speedToggle = Instance.new("TextButton")
    speedToggle.Parent = mainFrame
    speedToggle.Size = UDim2.new(0.9, 0, 0, 40)
    speedToggle.Position = UDim2.new(0.05, 0, 0.4, 0)
    speedToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    speedToggle.Text = "⚡ Speed: OFF"
    speedToggle.TextColor3 = Color3.new(1, 1, 1)
    speedToggle.Font = Enum.Font.GothamBold
    speedToggle.TextSize = 16

    local speedCorner = Instance.new("UICorner")
    speedCorner.Parent = speedToggle

    speedToggle.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        speedToggle.Text = speedEnabled and "⚡ Speed: ON" or "⚡ Speed: OFF"
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speedEnabled and fastSpeed or normalSpeed
        end
    end)

    -- Toggle NoClip
    local noclipToggle = Instance.new("TextButton")
    noclipToggle.Parent = mainFrame
    noclipToggle.Size = UDim2.new(0.9, 0, 0, 40)
    noclipToggle.Position = UDim2.new(0.05, 0, 0.55, 0)
    noclipToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    noclipToggle.Text = "🔄 NoClip: OFF"
    noclipToggle.TextColor3 = Color3.new(1, 1, 1)
    noclipToggle.Font = Enum.Font.GothamBold
    noclipToggle.TextSize = 16

    local noclipCorner = Instance.new("UICorner")
    noclipCorner.Parent = noclipToggle

    noclipToggle.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        noclipToggle.Text = noclipEnabled and "🔄 NoClip: ON" or "🔄 NoClip: OFF"
    end)

    -- Teleport Input
    local tpBox = Instance.new("TextBox")
    tpBox.Parent = mainFrame
    tpBox.Size = UDim2.new(0.9, 0, 0, 40)
    tpBox.Position = UDim2.new(0.05, 0, 0.7, 0)
    tpBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tpBox.PlaceholderText = "📞 Nama player..."
    tpBox.TextColor3 = Color3.new(1, 1, 1)
    tpBox.Font = Enum.Font.Gotham
    tpBox.TextSize = 14

    local tpCorner = Instance.new("UICorner")
    tpCorner.Parent = tpBox

    tpBox.FocusLost:Connect(function(enter)
        if enter and tpBox.Text ~= "" then
            teleportToPlayer(tpBox.Text)
            tpBox.Text = ""
        end
    end)

    -- Tombol P
    local openBtn = Instance.new("TextButton")
    openBtn.Parent = ScreenGui
    openBtn.Size = UDim2.new(0, 45, 0, 45)
    openBtn.Position = UDim2.new(0, 20, 0.5, -22.5)
    openBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    openBtn.Text = "P"
    openBtn.TextColor3 = Color3.new(1, 1, 1)
    openBtn.Font = Enum.Font.GothamBlack
    openBtn.TextSize = 20
    openBtn.Draggable = true

    local openCorner = Instance.new("UICorner")
    openCorner.Parent = openBtn
    openCorner.CornerRadius = UDim.new(1, 0)

    openBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    print("✅ Putzzdev-HUB Loaded!")
end

-- ================== EVENT VERIFY BUTTON ==================
VerifyBtn.MouseButton1Click:Connect(function()
    local inputKey = KeyTextBox.Text:gsub("%s+", "")
    if inputKey == "" then
        StatusLabel.Text = "❌ Masukkan key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    -- Show loading
    showLoading(true)
    StatusLabel.Text = "⏳ Memverifikasi..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Langsung cek (tanpa delay)
    local isValid, message = checkKeyExpiry(inputKey)
    
    -- Hilangkan loading
    showLoading(false)
    
    if isValid then
        StatusLabel.Text = "✅ " .. message
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Tunggu 2 detik lalu loading 3 detik
        task.wait(1)
        
        StatusLabel.Text = "⏳ Loading (3)..."
        task.wait(1)
        StatusLabel.Text = "⏳ Loading (2)..."
        task.wait(1)
        StatusLabel.Text = "⏳ Loading (1)..."
        task.wait(1)
        
        -- Jalankan script utama
        loadMainScript()
        
    else
        StatusLabel.Text = "❌ " .. message
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Enter key juga bisa verify
KeyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyBtn.MouseButton1Click:Fire()
    end
end)

print("🔐 Putzzdev-HUB Key System Loaded")