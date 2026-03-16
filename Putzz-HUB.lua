-- ================== PUTZZDEV-HUB V8 (SPIN EDITION + INVISIBLE) ==================
-- Version: 8.1 (Invisible Added)
-- Developer: Putzz XD

-- ================== KEY SYSTEM CONFIG ==================
-- ✅ PERBAIKAN: URL mengarah ke repository baru PutzzdevXiT/Putzzdev
local KEY_URL = "https://raw.githubusercontent.com/PutzzdevXiT/Putzzdev/refs/heads/main/key.json"
local WEBSITE_URL = "https://putzzdevxit.github.io/KEY-GENERATOR-/"
local SCRIPT_NAME = "Putzzdev-HUB"

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

-- ANTI DAMAGE
local antiDamageEnabled = false
local antiDamageConnection = nil
local antiDamageThread = nil

-- SPIN MUTER
local spinEnabled = false
local spinSpeed = 10
local spinConnection = nil
local spinDirection = 1 -- 1 = kanan, -1 = kiri

-- INVISIBLE (DARI SCRIPT LU)
local invisibleEnabled = false
local invisibleConnection = nil
local invisibleParts = {}
local invisibleRootPart = nil
local invisibleHumanoid = nil

-- Rainbow Variables
local rainbowHue = 0
local rainbowSpeed = 0.02
local rainbowActive = true -- Auto aktif

-- ================== FUNGSI KEY SYSTEM ==================

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

-- Fungsi ambil key dari GitHub JSON
local function getKeysFromGitHub()
    local success, data = pcall(function()
        return game:HttpGet(KEY_URL)
    end)
    
    if success and data then
        local success2, jsonData = pcall(function()
            return game:GetService("HttpService"):JSONDecode(data)
        end)
        if success2 and jsonData then
            -- ✅ PERUBAHAN: Sekarang jsonData bisa ARRAY (format baru) atau OBJECT (format lama)
            return jsonData
        end
    end
    return nil
end

-- ================== FUNGSI TIMER DENGAN DETIK ==================
local function getTimeRemaining(expiryTimestamp)
    local currentTime = os.time()
    local remaining = expiryTimestamp - currentTime
    
    if remaining <= 0 then
        return 0, 0, 0, 0, "EXPIRED"
    end
    
    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    local seconds = remaining % 60
    
    local timeStr = string.format("%d Hari : %02d Jam : %02d Menit : %02d Detik", 
        days, hours, minutes, seconds)
    
    return days, hours, minutes, seconds, timeStr
end

-- Fungsi cek expiry key (DIPERBAIKI UNTUK FORMAT ARRAY)
local function checkKeyExpiry(inputKey)
    loadKeyData()
    
    local keysData = getKeysFromGitHub()
    if not keysData then
        return false, "Gagal mengambil data key dari server"
    end
    
    local foundKey = nil
    local expiryDays = nil
    
    -- ✅ PERUBAHAN: Cek apakah data berupa ARRAY atau OBJECT
    if type(keysData) == "table" and not keysData.duration_keys then
        -- Format ARRAY (baru)
        for _, keyData in ipairs(keysData) do
            if keyData.key == inputKey then
                foundKey = keyData.key
                
                -- Tentukan durasi dari field "jenis"
                if keyData.jenis == "1 JAM" then
                    expiryDays = 1/24 -- 1 jam = 1/24 hari
                elseif keyData.jenis == "1 HARI" then
                    expiryDays = 1
                elseif keyData.jenis == "2 HARI" then
                    expiryDays = 2
                elseif keyData.jenis == "3 HARI" then
                    expiryDays = 3
                elseif keyData.jenis == "7 HARI" then
                    expiryDays = 7
                elseif keyData.jenis == "30 HARI" then
                    expiryDays = 30
                elseif keyData.jenis == "PERMANEN" then
                    expiryDays = 36500 -- 100 tahun (anggap permanen)
                else
                    expiryDays = 1 -- default 1 hari
                end
                break
            end
        end
    elseif keysData.duration_keys then
        -- Format LAMA (dari repo lama)
        for _, keyData in ipairs(keysData.duration_keys) do
            if keyData.key == inputKey then
                foundKey = keyData.key
                expiryDays = tonumber(keyData.days)
                break
            end
        end
    end
    
    if not foundKey then
        return false, "KEY TIDAK TERDAFTAR!"
    end
    
    if activeKeys[inputKey] then
        local firstUsed = activeKeys[inputKey].firstUsed
        local currentTime = os.time()
        local expiryTime = firstUsed + (expiryDays * 86400)
        
        if currentTime > expiryTime then
            return false, "KEY SUDAH EXPIRED! (" .. expiryDays .. " hari)"
        else
            local days, hours, minutes, seconds, timeStr = getTimeRemaining(expiryTime)
            keyExpiryTime = expiryTime
            currentUserKey = inputKey
            return true, "KEY VALID! Sisa " .. timeStr
        end
    else
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
        
        return true, "KEY VALID! Berlaku " .. expiryDays .. " hari"
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
KeyFrame.Size = UDim2.new(0, 400, 0, 380)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -190)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.Parent = KeyFrame
KeyCorner.CornerRadius = UDim.new(0, 16)

-- Gradient premium
local KeyGradient = Instance.new("UIGradient")
KeyGradient.Parent = KeyFrame
KeyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
KeyGradient.Rotation = 45

-- Border premium
local KeyBorder = Instance.new("Frame")
KeyBorder.Parent = KeyFrame
KeyBorder.Size = UDim2.new(1, 0, 1, 0)
KeyBorder.BackgroundTransparency = 1
KeyBorder.BorderSizePixel = 2
KeyBorder.BorderColor3 = Color3.fromRGB(0, 200, 255)

local KeyBorderCorner = Instance.new("UICorner")
KeyBorderCorner.Parent = KeyBorder
KeyBorderCorner.CornerRadius = UDim.new(0, 16)

-- Header
local KeyHeader = Instance.new("Frame")
KeyHeader.Parent = KeyFrame
KeyHeader.Size = UDim2.new(1, 0, 0, 80)
KeyHeader.BackgroundTransparency = 1

local KeyIcon = Instance.new("TextLabel")
KeyIcon.Parent = KeyHeader
KeyIcon.Size = UDim2.new(1, 0, 0.5, 0)
KeyIcon.Position = UDim2.new(0, 0, 0, 10)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Text = ""
KeyIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
KeyIcon.Font = Enum.Font.GothamBlack
KeyIcon.TextSize = 40

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyHeader
KeyTitle.Size = UDim2.new(1, 0, 0.5, 0)
KeyTitle.Position = UDim2.new(0, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "PUTZZDEV AUTHENTICATION"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16
KeyTitle.TextStrokeTransparency = 0.3
KeyTitle.TextStrokeColor3 = Color3.fromRGB(0, 200, 255)

-- Info Box
local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = KeyFrame
InfoFrame.Size = UDim2.new(0.9, 0, 0, 70)
InfoFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
InfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
InfoFrame.BackgroundTransparency = 0.2
InfoFrame.BorderSizePixel = 0

local InfoCorner = Instance.new("UICorner")
InfoCorner.Parent = InfoFrame
InfoCorner.CornerRadius = UDim.new(0, 10)

local InfoIcon = Instance.new("TextLabel")
InfoIcon.Parent = InfoFrame
InfoIcon.Size = UDim2.new(0, 30, 1, 0)
InfoIcon.Position = UDim2.new(0, 10, 0, 0)
InfoIcon.BackgroundTransparency = 1
InfoIcon.Text = "ℹ️"
InfoIcon.TextColor3 = Color3.fromRGB(0, 200, 255)
InfoIcon.Font = Enum.Font.GothamBold
InfoIcon.TextSize = 18

local InfoText = Instance.new("TextLabel")
InfoText.Parent = InfoFrame
InfoText.Size = UDim2.new(1, -50, 1, 0)
InfoText.Position = UDim2.new(0, 45, 0, 0)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Masukkan Key Anda untuk mengakses script premium"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 13
InfoText.TextXAlignment = Enum.TextXAlignment.Left

-- Label "MASUKAN KEY ANDA"
local KeyLabel = Instance.new("TextLabel")
KeyLabel.Parent = KeyFrame
KeyLabel.Size = UDim2.new(0.8, 0, 0, 20)
KeyLabel.Position = UDim2.new(0.1, 0, 0.38, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "MASUKAN KEY ANDA"
KeyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextSize = 12
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left

-- TextBox untuk key
local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.Position = UDim2.new(0.1, 0, 0.42, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyTextBox.BackgroundTransparency = 0.1
KeyTextBox.TextColor3 = Color3.new(1, 1, 1)
KeyTextBox.PlaceholderText = "Masukkan key..."
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.TextSize = 14
KeyTextBox.ClearTextOnFocus = true

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.Parent = KeyTextBox
KeyBoxCorner.CornerRadius = UDim.new(0, 8)

-- Tombol Verify
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = KeyFrame
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 45)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
VerifyBtn.BackgroundTransparency = 0.1
VerifyBtn.Text = "VERIFIKASI KEY"
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
WebsiteBtn.Position = UDim2.new(0.25, 0, 0.67, 0)
WebsiteBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
WebsiteBtn.BackgroundTransparency = 0.1
WebsiteBtn.Text = "GET KEY"
WebsiteBtn.TextColor3 = Color3.new(1, 1, 1)
WebsiteBtn.Font = Enum.Font.GothamBold
WebsiteBtn.TextSize = 14

local WebsiteCorner = Instance.new("UICorner")
WebsiteCorner.Parent = WebsiteBtn
WebsiteCorner.CornerRadius = UDim.new(0, 6)

-- Status Label
local StatusFrame = Instance.new("Frame")
StatusFrame.Parent = KeyFrame
StatusFrame.Size = UDim2.new(0.9, 0, 0, 40)
StatusFrame.Position = UDim2.new(0.05, 0, 0.78, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
StatusFrame.BackgroundTransparency = 0.3
StatusFrame.BorderSizePixel = 0

local StatusCorner = Instance.new("UICorner")
StatusCorner.Parent = StatusFrame
StatusCorner.CornerRadius = UDim.new(0, 8)

local StatusIcon = Instance.new("TextLabel")
StatusIcon.Parent = StatusFrame
StatusIcon.Size = UDim2.new(0, 30, 1, 0)
StatusIcon.Position = UDim2.new(0, 5, 0, 0)
StatusIcon.BackgroundTransparency = 1
StatusIcon.Text = ""
StatusIcon.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusIcon.Font = Enum.Font.GothamBold
StatusIcon.TextSize = 18

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusFrame
StatusLabel.Size = UDim2.new(1, -40, 1, 0)
StatusLabel.Position = UDim2.new(0, 35, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Menunggu Key..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Loading Circle
local LoadingCircle = Instance.new("Frame")
LoadingCircle.Parent = KeyFrame
LoadingCircle.Size = UDim2.new(0, 30, 0, 30)
LoadingCircle.Position = UDim2.new(0.5, -15, 0.9, -15)
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
            StatusLabel.Text = "✓ Link disalin! Buka browser"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            StatusIcon.Text = "✅"
            showNotification("✅ LINK DISALIN!", "Buka browser dan paste linknya", 2, Color3.fromRGB(0, 150, 0))
        else
            StatusLabel.Text = "🌐 " .. WEBSITE_URL
            StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        end
    end)
end)

-- ================== FUNGSI SPIN MUTER ==================
local function toggleSpin(state)
    spinEnabled = state
    
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
    
    if state then
        spinConnection = RunService.Heartbeat:Connect(function()
            if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = LocalPlayer.Character.HumanoidRootPart
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * spinDirection), 0)
            end
        end)
        showNotification(" SPIN AKTIF", "Kamu muter terus!", 1.5, Color3.fromRGB(255, 0, 255))
    end
end

-- Fungsi ganti arah spin
local function toggleSpinDirection()
    spinDirection = spinDirection * -1
    showNotification("🔄 ARAH SPIN", spinDirection == 1 and "KANAN" or "KIRI", 1, Color3.fromRGB(0, 200, 255))
end

-- ================== FUNGSI INVISIBLE (DARI SCRIPT LU) ==================
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
    
    if invisibleConnection then
        invisibleConnection:Disconnect()
        invisibleConnection = nil
    end
    
    updateInvisibleData()
    
    if state then
        -- Set transparansi parts
        for _, v in pairs(invisibleParts) do
            v.Transparency = 0.5
        end
        
        -- Koneksi heartbeat untuk efek invisible (pindah posisi)
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
        
        showNotification("👻 INVISIBLE ON", "Kamu tidak terlihat!", 1.5, Color3.fromRGB(150, 0, 255))
    else
        -- Kembalikan transparansi
        for _, v in pairs(invisibleParts) do
            v.Transparency = 0
        end
        showNotification("👻 INVISIBLE OFF", "Kamu terlihat lagi", 1.5, Color3.fromRGB(255, 0, 0))
    end
end

-- ================== FUNGSI ANTI DAMAGE (SUPER FIXED) ==================
local function setupAntiDamage()
    if antiDamageConnection then
        antiDamageConnection:Disconnect()
        antiDamageConnection = nil
    end
    
    if antiDamageThread then
        antiDamageThread = nil
    end
    
    antiDamageThread = task.spawn(function()
        while antiDamageEnabled and task.wait(0.01) do
            pcall(function()
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        if humanoid.Health < humanoid.MaxHealth then
                            humanoid.Health = humanoid.MaxHealth
                        end
                        if humanoid.Health <= 0 then
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end
                    
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and (humanoid:GetState() == Enum.HumanoidStateType.Freefall or 
                       humanoid:GetState() == Enum.HumanoidStateType.FallingDown) then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end
            end)
        end
    end)
    
    antiDamageConnection = RunService.Heartbeat:Connect(function()
        if antiDamageEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end)
end

-- ================== FUNGSI UTAMA ==================
local function loadMainScript()
    -- Hapus GUI key
    KeyGui:Destroy()
    
    print("✅ " .. SCRIPT_NAME .. " key berhasil - Memuat semua fitur...")
    
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

    -- ================== FUNGSI TELEPORT KE PLAYER ==================
    local function teleportToPlayer(username)
        local targetPlayer = nil
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(username:lower()) or (player.DisplayName and player.DisplayName:lower():find(username:lower())) then
                targetPlayer = player
                break
            end
        end
        
        if not targetPlayer then
            return false
        end
        
        if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return false
        end
        
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
            return false
        end
        
        local targetRoot = targetPlayer.Character.HumanoidRootPart
        myChar.HumanoidRootPart.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
        return true
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
        name.OutlineColor = Color3.fromRGB(0,0,0)
        name.Visible = false

        local dist = Drawing.new("Text")
        dist.Size = 13
        dist.Color = Color3.new(1,1,1)
        dist.Center = true
        dist.Outline = true
        dist.OutlineColor = Color3.fromRGB(0,0,0)
        dist.Visible = false

        -- ESP LINE WARNA PUTIH
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = Color3.fromRGB(255, 255, 255)
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

    -- Rainbow color untuk background GUI (AUTO AKTIF)
    local hue = 0
    RunService.RenderStepped:Connect(function()
        if rainbowActive then
            hue = (hue + 0.005) % 1
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            
            if mainFrame then
                local border = mainFrame:FindFirstChild("Border")
                if border then
                    border.BorderColor3 = rainbowColor
                end
            end
            
            if title then
                title.TextStrokeColor3 = rainbowColor
            end
        end
        
        -- ESP Box
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
                        line.Color = Color3.fromRGB(255, 255, 255)
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

    -- Inisialisasi player untuk ESP
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

    -- Cleanup ESP setiap 30 detik
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

    -- ================== GUI UTAMA RAINBOW ==================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "PutzzdevHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = ScreenGui
    mainFrame.Size = UDim2.new(0, 380, 0, 600) -- Lebih tinggi untuk fitur invisible
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local corner = Instance.new("UICorner")
    corner.Parent = mainFrame
    corner.CornerRadius = UDim.new(0, 16)

    local gradient = Instance.new("UIGradient")
    gradient.Parent = mainFrame
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
    })
    gradient.Rotation = 45

    -- Border Rainbow (AUTO AKTIF)
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Parent = mainFrame
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 3
    border.BorderColor3 = Color3.fromRGB(0, 200, 255)

    local borderCorner = Instance.new("UICorner")
    borderCorner.Parent = border
    borderCorner.CornerRadius = UDim.new(0, 16)

    -- Timer Display (DENGAN DETIK)
    local timerFrame = Instance.new("Frame")
    timerFrame.Parent = mainFrame
    timerFrame.Size = UDim2.new(0.9, 0, 0, 50)
    timerFrame.Position = UDim2.new(0.05, 0, 0.02, 0)
    timerFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    timerFrame.BackgroundTransparency = 0.3
    timerFrame.BorderSizePixel = 0

    local timerCorner = Instance.new("UICorner")
    timerCorner.Parent = timerFrame
    timerCorner.CornerRadius = UDim.new(0, 8)

    local timerIcon = Instance.new("TextLabel")
    timerIcon.Parent = timerFrame
    timerIcon.Size = UDim2.new(0, 40, 1, 0)
    timerIcon.Position = UDim2.new(0, 5, 0, 0)
    timerIcon.BackgroundTransparency = 1
    timerIcon.Text = "⏳"
    timerIcon.TextColor3 = Color3.fromRGB(255, 255, 0)
    timerIcon.Font = Enum.Font.GothamBold
    timerIcon.TextSize = 24

    local timerLabel = Instance.new("TextLabel")
    timerLabel.Parent = timerFrame
    timerLabel.Size = UDim2.new(1, -50, 1, 0)
    timerLabel.Position = UDim2.new(0, 45, 0, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "Memuat informasi key..."
    timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.TextSize = 13
    timerLabel.TextXAlignment = Enum.TextXAlignment.Left
    timerLabel.TextWrapped = true

    -- Update timer setiap DETIK
    spawn(function()
        while task.wait(1) do
            if currentUserKey and keyExpiryTime > 0 then
                local days, hours, minutes, seconds, timeStr = getTimeRemaining(keyExpiryTime)
                if days == 0 and hours == 0 and minutes == 0 and seconds == 0 then
                    timerLabel.Text = "⚠️ KEY SUDAH EXPIRED! ⚠️"
                    timerLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    timerIcon.TextColor3 = Color3.fromRGB(255, 0, 0)
                else
                    timerLabel.Text = timeStr
                    timerLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    timerIcon.TextColor3 = Color3.fromRGB(255, 255, 0)
                end
            else
                timerLabel.Text = "Key: " .. (currentUserKey or "Tidak ada")
                timerLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
            end
        end
    end)

    -- Header
    local header = Instance.new("Frame")
    header.Parent = mainFrame
    header.Size = UDim2.new(1, 0, 0, 45)
    header.Position = UDim2.new(0, 0, 0, 60)
    header.BackgroundTransparency = 1

    local title = Instance.new("TextLabel")
    title.Parent = header
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "Putzzdev-HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 30
    title.TextStrokeTransparency = 0
    title.TextStrokeColor3 = Color3.fromRGB(0, 200, 255)

    -- Tab bar
    local tabBar = Instance.new("Frame")
    tabBar.Parent = mainFrame
    tabBar.Size = UDim2.new(1, -20, 0, 40)
    tabBar.Position = UDim2.new(0, 10, 0, 110)
    tabBar.BackgroundTransparency = 1

    local tabs = {}
    local contents = {}

    local function createTab(name, icon, idx)
        local btn = Instance.new("TextButton")
        btn.Parent = tabBar
        btn.Size = UDim2.new(0.25, -2, 1, -4)
        btn.Position = UDim2.new((idx-1)*0.25, 5, 0, 2)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        btn.BackgroundTransparency = 0.3
        btn.Text = icon.." "..name
        btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = btn
        btnCorner.CornerRadius = UDim.new(0, 8)

        local content = Instance.new("ScrollingFrame")
        content.Parent = mainFrame
        content.Size = UDim2.new(1, -20, 1, -250) -- Lebih besar untuk fitur banyak
        content.Position = UDim2.new(0, 10, 0, 155)
        content.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        content.BackgroundTransparency = 0.5
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 6
        content.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.Visible = false
        content.AutomaticCanvasSize = Enum.AutomaticSize.Y

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

    local tabMain = createTab("MAIN", "🏠", 1)
    local tabESP = createTab("ESP", "👁️", 2)
    local tabColor = createTab("COLOR", "🎨", 3)
    local tabAbout = createTab("ABOUT", "📋", 4)

    local function createButton(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.Size = UDim2.new(0.9, 0, 0, 35) -- Lebih kecil biar muat
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
        btn.TextSize = 14

        btn.MouseButton1Click:Connect(callback)
        return frame
    end

    local function createToggle(parent, text, default, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.Size = UDim2.new(0.9, 0, 0, 35) -- Lebih kecil
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
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
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left

        local switch = Instance.new("Frame")
        switch.Parent = frame
        switch.Size = UDim2.new(0, 40, 0, 20) -- Lebih kecil
        switch.Position = UDim2.new(0.85, 0, 0.5, -10)
        switch.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(100, 100, 100)
        switch.BorderSizePixel = 0

        local switchCorner = Instance.new("UICorner")
        switchCorner.Parent = switch
        switchCorner.CornerRadius = UDim.new(0, 10)

        local circle = Instance.new("Frame")
        circle.Parent = switch
        circle.Size = UDim2.new(0, 16, 0, 16) -- Lebih kecil
        circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0.05, 0, 0.5, -8)
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
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0.05, 0, 0.5, -8)}):Play()
            callback(state)
        end)
        
        return frame
    end

    local function createTextBox(parent, placeholder, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.Size = UDim2.new(0.9, 0, 0, 40) -- Lebih kecil
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        frame.BorderSizePixel = 0

        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 8)

        local textBox = Instance.new("TextBox")
        textBox.Parent = frame
        textBox.Size = UDim2.new(1, -10, 1, -10)
        textBox.Position = UDim2.new(0, 5, 0, 5)
        textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        textBox.TextColor3 = Color3.new(1, 1, 1)
        textBox.PlaceholderText = placeholder
        textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        textBox.Font = Enum.Font.Gotham
        textBox.TextSize = 14
        textBox.ClearTextOnFocus = false

        local boxCorner = Instance.new("UICorner")
        boxCorner.Parent = textBox
        boxCorner.CornerRadius = UDim.new(0, 6)

        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and textBox.Text ~= "" then
                callback(textBox.Text)
                textBox.Text = ""
            end
        end)

        return frame
    end

    local function createSlider(parent, text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Parent = parent
        frame.Size = UDim2.new(0.9, 0, 0, 45) -- Lebih kecil
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
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left

        local sliderBg = Instance.new("Frame")
        sliderBg.Parent = frame
        sliderBg.Size = UDim2.new(0.9, 0, 0.25, 0)
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

    -- ===== TAB MAIN (DENGAN SCROLL + INVISIBLE) =====
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

    createTextBox(tabMain, "Masukkan username player...", function(username)
        teleportToPlayer(username)
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

    -- ANTI DAMAGE
    createToggle(tabMain, "⚡ GOD MODE", false, function(s)
        antiDamageEnabled = s
        if s then
            setupAntiDamage()
            showNotification("✅ GOD MODE AKTIF", "Anti one-hit kill!", 1.5, Color3.fromRGB(0, 255, 0))
        elseif antiDamageConnection then
            antiDamageConnection:Disconnect()
            antiDamageConnection = nil
            antiDamageThread = nil
        end
    end)

    -- SPIN MUTER
    createToggle(tabMain, "🌀 SPIN MUTER", false, function(s)
        toggleSpin(s)
    end)

    createSlider(tabMain, "⚡ Kecepatan Spin", 1, 30, 10, function(s)
        spinSpeed = s
    end)

    createButton(tabMain, "🔄 Ganti Arah Spin", function()
        toggleSpinDirection()
    end)

    -- INVISIBLE (DARI SCRIPT LU)
    createToggle(tabMain, "👻 INVISIBLE MODE", false, function(s)
        toggleInvisible(s)
    end)

    -- Update karakter saat ganti
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        updateInvisibleData()
        if invisibleEnabled then
            toggleInvisible(true)
        end
    end)

    -- ===== TAB ESP =====
    createToggle(tabESP, "ESP Player", false, function(s) espEnabled = s end)
    createToggle(tabESP, "ESP Line", false, function(s) lineEnabled = s end)
    createToggle(tabESP, "Health Bar", false, function(s) healthEnabled = s end)
    createToggle(tabESP, "ESP Skeleton", false, function(s) skeletonEnabled = s end)

    -- ===== TAB COLOR =====
    createButton(tabColor, "🔴 Merah", function()
        border.BorderColor3 = Color3.fromRGB(255, 0, 0)
        title.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    end)

    createButton(tabColor, "🟢 Hijau", function()
        border.BorderColor3 = Color3.fromRGB(0, 255, 0)
        title.TextStrokeColor3 = Color3.fromRGB(0, 255, 0)
    end)

    createButton(tabColor, "🔵 Biru", function()
        border.BorderColor3 = Color3.fromRGB(0, 0, 255)
        title.TextStrokeColor3 = Color3.fromRGB(0, 0, 255)
    end)

    createButton(tabColor, "🟡 Kuning", function()
        border.BorderColor3 = Color3.fromRGB(255, 255, 0)
        title.TextStrokeColor3 = Color3.fromRGB(255, 255, 0)
    end)

    createButton(tabColor, "🟠 Orange", function()
        border.BorderColor3 = Color3.fromRGB(255, 165, 0)
        title.TextStrokeColor3 = Color3.fromRGB(255, 165, 0)
    end)

    createButton(tabColor, "🟣 Ungu", function()
        border.BorderColor3 = Color3.fromRGB(128, 0, 128)
        title.TextStrokeColor3 = Color3.fromRGB(128, 0, 128)
    end)

    createButton(tabColor, "💗 Pink", function()
        border.BorderColor3 = Color3.fromRGB(255, 192, 203)
        title.TextStrokeColor3 = Color3.fromRGB(255, 192, 203)
    end)

    createButton(tabColor, "🔷 Cyan", function()
        border.BorderColor3 = Color3.fromRGB(0, 255, 255)
        title.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
    end)

    createButton(tabColor, "🌈 Rainbow Auto (Default)", function()
        rainbowActive = true
    end)

    -- ===== TAB ABOUT =====
    local aboutFrame = Instance.new("Frame")
    aboutFrame.Parent = tabAbout
    aboutFrame.Size = UDim2.new(0.9, 0, 0, 170)
    aboutFrame.Position = UDim2.new(0.05, 0, 0, 10)
    aboutFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    aboutFrame.BackgroundTransparency = 0.3
    aboutFrame.BorderSizePixel = 0

    local aboutCorner = Instance.new("UICorner")
    aboutCorner.Parent = aboutFrame
    aboutCorner.CornerRadius = UDim.new(0, 10)

    local aboutTitle = Instance.new("TextLabel")
    aboutTitle.Parent = aboutFrame
    aboutTitle.Size = UDim2.new(1, 0, 0, 30)
    aboutTitle.Position = UDim2.new(0, 0, 0, 10)
    aboutTitle.BackgroundTransparency = 1
    aboutTitle.Text = "PUTZZ DEVELOPER"
    aboutTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    aboutTitle.Font = Enum.Font.GothamBlack
    aboutTitle.TextSize = 18

    local infoText = Instance.new("TextLabel")
    infoText.Parent = aboutFrame
    infoText.Size = UDim2.new(0.9, 0, 0, 100)
    infoText.Position = UDim2.new(0.05, 0, 0, 50)
    infoText.BackgroundTransparency = 1
    infoText.Text = "🔥 Putzzdev-HUB V8.1 🔥\n\n" ..
                     "👤 Developer: Putzz XD\n" ..
                     "📌 Version:6.0\n" ..
                     "📱 TikTok: @putzz_mvpp\n\n" ..
                     "✨ Fitur LENGKAP:\n" ..
                     "   • ESP, Fly, Speed, NoClip\n" ..
                     "   • Aimbot, Infinity Jump\n" ..
                     "   • GOD MODE, SPIN MUTER\n" ..
                     "   • INVISIBLE MODE (Anti Kamera)\n\n" ..
                     "📞 Kontak: 088976255131"
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.Font = Enum.Font.Gotham
    infoText.TextSize = 12
    infoText.TextWrapped = true
    infoText.TextXAlignment = Enum.TextXAlignment.Left

    createButton(tabAbout, "📋 Copy TikTok", function()
        if setclipboard then
            setclipboard("@putzz_mvpp")
            local notif = Instance.new("TextLabel")
            notif.Parent = ScreenGui
            notif.Size = UDim2.new(0, 180, 0, 30)
            notif.Position = UDim2.new(0.5, -90, 0.8, 0)
            notif.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            notif.BackgroundTransparency = 0.2
            notif.Text = "✅ TikTok copied!"
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

    -- Update canvas size untuk scroll
    task.wait(0.1)
    for _, content in pairs(contents) do
        local height = 0
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("Frame") then
                height = height + child.Size.Y.Offset + 8
            end
        end
        content.CanvasSize = UDim2.new(0, 0, 0, height + 20)
    end

    -- Aktifkan tab pertama
    tabs[1].TextColor3 = Color3.fromRGB(0, 200, 255)
    contents[1].Visible = true

    -- ================== TOMBOL P DENGAN EFEK GLOW ==================
    local openBtn = Instance.new("TextButton")
    openBtn.Parent = ScreenGui
    openBtn.Size = UDim2.new(0, 60, 0, 60)
    openBtn.Position = UDim2.new(0, 15, 0.5, -30)
    openBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    openBtn.BackgroundTransparency = 0.1
    openBtn.Text = "P"
    openBtn.TextColor3 = Color3.new(1, 1, 1)
    openBtn.Font = Enum.Font.GothamBlack
    openBtn.TextSize = 30
    openBtn.ZIndex = 2
    openBtn.Active = true
    openBtn.Draggable = true

    -- Bikin bulat
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = openBtn
    btnCorner.CornerRadius = UDim.new(1, 0)

    -- Efek Glow
    local glow = Instance.new("ImageLabel")
    glow.Parent = openBtn
    glow.Size = UDim2.new(1.4, 0, 1.4, 0)
    glow.Position = UDim2.new(-0.2, 0, -0.2, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://3570695787"
    glow.ImageColor3 = Color3.fromRGB(0, 200, 255)
    glow.ImageTransparency = 0.5
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10, 10, 118, 118)
    glow.ZIndex = 1

    -- Animasi warna glow berubah (AUTO RAINBOW)
    spawn(function()
        local hue = 0
        while true do
            if rainbowActive then
                hue = (hue + 0.01) % 1
                local rainbow = Color3.fromHSV(hue, 1, 1)
                glow.ImageColor3 = rainbow
            end
            task.wait(0.05)
        end
    end)

    -- Fungsi buka/tutup menu
    local menuOpen = true
    openBtn.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen

        if menuOpen then
            mainFrame.Visible = true
            TweenService:Create(mainFrame, TweenInfo.new(0.25), {
                Position = UDim2.new(0.5, -190, 0.5, -300)
            }):Play()
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.25), {
                Position = UDim2.new(0.5, -190, 1, 0)
            }):Play()
            task.wait(0.25)
            mainFrame.Visible = false
        end
    end)

    -- Animasi hover
    openBtn.MouseEnter:Connect(function()
        TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 65, 0, 65)}):Play()
    end)

    openBtn.MouseLeave:Connect(function()
        TweenService:Create(openBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    end)

    print("✅ Putzzdev-HUB V8.1 - INVISIBLE ADDED!")
end

-- ================== EVENT VERIFY BUTTON ==================
VerifyBtn.MouseButton1Click:Connect(function()
    local inputKey = KeyTextBox.Text:gsub("%s+", "")
    if inputKey == "" then
        StatusLabel.Text = "Masukkan Key Anda!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        StatusIcon.Text = "❌"
        return
    end
    
    showLoading(true)
    StatusLabel.Text = "Memverifikasi Key..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    StatusIcon.Text = "⏳"
    
    local isValid, message = checkKeyExpiry(inputKey)
    
    showLoading(false)
    
    if isValid then
        StatusLabel.Text = message
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        StatusIcon.Text = "✅"
        
        task.wait(1)
        StatusLabel.Text = "Loading (3)..."
        task.wait(1)
        StatusLabel.Text = "Loading (2)..."
        task.wait(1)
        StatusLabel.Text = "Loading (1)..."
        task.wait(1)
        
        pcall(loadMainScript)
        
    else
        StatusLabel.Text = message
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        StatusIcon.Text = "❌"
        showNotification("❌ GAGAL", message, 2, Color3.fromRGB(150, 0, 0))
    end
end)

-- Enter key juga bisa verify
KeyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyBtn.MouseButton1Click:Fire()
    end
end)

print("🔥 Putzzdev-HUB V8.1 - INVISIBLE MODE READY!")