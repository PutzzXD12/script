-- ================== DRIP CLIENT V7.5 - NEW KEY SYSTEM ==================
-- Developer: Putzz XD
-- Database: putzz-key-default-rtdb
-- Website: https://putzzdevxit.github.io/KEY-GENERATOR-/

-- ================== KONFIGURASI ==================
local DATABASE_URL = "https://putzz-key-default-rtdb.europe-west1.firebasedatabase.app/keys.json"
local WEBSITE_URL = "https://putzzdevxit.github.io/KEY-GENERATOR-/"
local SCRIPT_NAME = "DRIP CLIENT"

-- ================== LOAD SERVICES ==================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- ================== VARIABEL ==================
local themeColor = Color3.fromRGB(156, 39, 176)
local darkPurple = Color3.fromRGB(74, 20, 90)
local boxColor = Color3.fromRGB(0, 255, 0)
local skeletonColor = Color3.fromRGB(0, 255, 0)
local MAX_ESP_DISTANCE = 115

-- Status Key
local keyValid = false
local keyExpiryTime = 0
local keyType = ""

-- Fitur variables
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
local noclipEnabled = false
local noclipConnection = nil
local speedEnabled = false
local normalSpeed = 16
local fastSpeed = 70
local infinityJumpEnabled = false
local crosshairEnabled = false
local crosshairObject = nil
local antiDamageEnabled = false
local antiDamageConnection = nil
local antiDamageThread = nil
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

-- ================== FUNGSI KEY SYSTEM ==================
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

local function getTimeRemaining(expiryTimestamp)
    local currentTime = os.time()
    local remaining = expiryTimestamp - currentTime
    
    if remaining <= 0 then
        return "EXPIRED"
    end
    
    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    local seconds = remaining % 60
    
    if days > 0 then
        return string.format("%d Hari %02d Jam", days, hours)
    elseif hours > 0 then
        return string.format("%02d Jam %02d Menit", hours, minutes)
    elseif minutes > 0 then
        return string.format("%02d Menit %02d Detik", minutes, seconds)
    else
        return string.format("%02d Detik", seconds)
    end
end

local function checkKey(inputKey)
    local keysData = getKeysFromFirebase()
    
    if not keysData then
        return false, "Gagal koneksi ke database!", nil, 0
    end
    
    -- Cari key di database
    local foundKey = nil
    local keyJenis = nil
    
    for id, keyData in pairs(keysData) do
        if keyData.key and string.upper(keyData.key) == string.upper(inputKey) then
            foundKey = keyData.key
            keyJenis = keyData.jenis or keyData.type or "1 HARI"
            break
        end
    end
    
    if not foundKey then
        return false, "KEY TIDAK TERDAFTAR!", nil, 0
    end
    
    -- Hitung expiry time
    local currentTime = os.time()
    local expiryDays = 1
    local durationText = ""
    
    if keyJenis == "1 JAM" then
        expiryDays = 1/24
        durationText = "1 Jam"
    elseif keyJenis == "1 HARI" then
        expiryDays = 1
        durationText = "1 Hari"
    elseif keyJenis == "2 HARI" then
        expiryDays = 2
        durationText = "2 Hari"
    elseif keyJenis == "3 HARI" then
        expiryDays = 3
        durationText = "3 Hari"
    elseif keyJenis == "4 HARI" then
        expiryDays = 4
        durationText = "4 Hari"
    elseif keyJenis == "7 HARI" then
        expiryDays = 7
        durationText = "7 Hari"
    elseif keyJenis == "30 HARI" then
        expiryDays = 30
        durationText = "30 Hari"
    elseif keyJenis == "PERMANEN" then
        expiryDays = 999999
        durationText = "PERMANEN"
    else
        expiryDays = 1
        durationText = "1 Hari"
    end
    
    local expiryTime = currentTime + (expiryDays * 86400)
    
    if expiryDays >= 999999 then
        return true, "✅ KEY VALID! (PERMANEN)", keyJenis, expiryTime
    else
        return true, "✅ KEY VALID! (" .. durationText .. ")", keyJenis, expiryTime
    end
end

-- ================== BUAT GUI KEY SYSTEM ==================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "DripKeySystem"
KeyGui.Parent = game.CoreGui
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.DisplayOrder = 999

local function showNotification(title, text, duration, color)
    pcall(function()
        local notifFrame = Instance.new("Frame")
        notifFrame.Parent = KeyGui
        notifFrame.Size = UDim2.new(0, 300, 0, 70)
        notifFrame.Position = UDim2.new(0.5, -150, 0, -80)
        notifFrame.BackgroundColor3 = color or Color3.fromRGB(30, 30, 40)
        notifFrame.BackgroundTransparency = 0.1
        notifFrame.BorderSizePixel = 0
        notifFrame.ZIndex = 999

        local notifCorner = Instance.new("UICorner")
        notifCorner.Parent = notifFrame
        notifCorner.CornerRadius = UDim.new(0, 12)

        local notifTitle = Instance.new("TextLabel")
        notifTitle.Parent = notifFrame
        notifTitle.Size = UDim2.new(1, 0, 0.5, 0)
        notifTitle.Position = UDim2.new(0, 0, 0, 5)
        notifTitle.BackgroundTransparency = 1
        notifTitle.Text = title
        notifTitle.TextColor3 = Color3.new(1, 1, 1)
        notifTitle.Font = Enum.Font.GothamBold
        notifTitle.TextSize = 18

        local notifText = Instance.new("TextLabel")
        notifText.Parent = notifFrame
        notifText.Size = UDim2.new(1, 0, 0.5, 0)
        notifText.Position = UDim2.new(0, 0, 0, 35)
        notifText.BackgroundTransparency = 1
        notifText.Text = text
        notifText.TextColor3 = Color3.new(1, 1, 1)
        notifText.Font = Enum.Font.Gotham
        notifText.TextSize = 14

        TweenService:Create(notifFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
        task.wait(duration or 3)
        TweenService:Create(notifFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, -80)}):Play()
        task.wait(0.5)
        notifFrame:Destroy()
    end)
end

-- Buat UI Key
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

local KeyBorder = Instance.new("Frame")
KeyBorder.Parent = KeyFrame
KeyBorder.Size = UDim2.new(1, 0, 1, 0)
KeyBorder.BackgroundTransparency = 1
KeyBorder.BorderSizePixel = 2
KeyBorder.BorderColor3 = themeColor

local KeyBorderCorner = Instance.new("UICorner")
KeyBorderCorner.Parent = KeyBorder
KeyBorderCorner.CornerRadius = UDim.new(0, 20)

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
KeyIcon.Text = "🔐"
KeyIcon.TextColor3 = themeColor
KeyIcon.Font = Enum.Font.GothamBlack
KeyIcon.TextSize = 45

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyHeader
KeyTitle.Size = UDim2.new(1, 0, 0.5, 0)
KeyTitle.Position = UDim2.new(0, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "DRIP CLIENT AUTH"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16

-- Info Frame
local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = KeyFrame
InfoFrame.Size = UDim2.new(0.9, 0, 0, 90)
InfoFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
InfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
InfoFrame.BackgroundTransparency = 0.3
InfoFrame.BorderSizePixel = 0

local InfoCorner = Instance.new("UICorner")
InfoCorner.Parent = InfoFrame
InfoCorner.CornerRadius = UDim.new(0, 12)

local InfoText = Instance.new("TextLabel")
InfoText.Parent = InfoFrame
InfoText.Size = UDim2.new(1, -20, 1, -10)
InfoText.Position = UDim2.new(0, 10, 0, 5)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Masukkan Key Anda untuk mengakses script premium\n\n📌 TIPE KEY:\n1 JAM | 1 HARI | 2 HARI | 3 HARI | 4 HARI | 7 HARI | 30 HARI | PERMANEN"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 11
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextWrapped = true

-- Input Key
local KeyLabel = Instance.new("TextLabel")
KeyLabel.Parent = KeyFrame
KeyLabel.Size = UDim2.new(0.8, 0, 0, 20)
KeyLabel.Position = UDim2.new(0.1, 0, 0.40, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "MASUKAN KEY ANDA"
KeyLabel.TextColor3 = themeColor
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextSize = 12

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.Position = UDim2.new(0.1, 0, 0.44, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyTextBox.BackgroundTransparency = 0.1
KeyTextBox.TextColor3 = Color3.new(1, 1, 1)
KeyTextBox.PlaceholderText = "Contoh: DRIP2025"
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
VerifyBtn.Position = UDim2.new(0.1, 0, 0.57, 0)
VerifyBtn.BackgroundColor3 = themeColor
VerifyBtn.BackgroundTransparency = 0.2
VerifyBtn.Text = "VERIFIKASI KEY"
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 16

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.Parent = VerifyBtn
VerifyCorner.CornerRadius = UDim.new(0, 10)

-- Tombol Website
local WebsiteBtn = Instance.new("TextButton")
WebsiteBtn.Parent = KeyFrame
WebsiteBtn.Size = UDim2.new(0.5, 0, 0, 35)
WebsiteBtn.Position = UDim2.new(0.25, 0, 0.69, 0)
WebsiteBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
WebsiteBtn.BackgroundTransparency = 0.2
WebsiteBtn.Text = "🌐 GET KEY"
WebsiteBtn.TextColor3 = Color3.new(1, 1, 1)
WebsiteBtn.Font = Enum.Font.GothamBold
WebsiteBtn.TextSize = 14

local WebsiteCorner = Instance.new("UICorner")
WebsiteCorner.Parent = WebsiteBtn
WebsiteCorner.CornerRadius = UDim.new(0, 8)

-- Status Frame
local StatusFrame = Instance.new("Frame")
StatusFrame.Parent = KeyFrame
StatusFrame.Size = UDim2.new(0.9, 0, 0, 60)
StatusFrame.Position = UDim2.new(0.05, 0, 0.80, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
StatusFrame.BackgroundTransparency = 0.3
StatusFrame.BorderSizePixel = 0

local StatusCorner = Instance.new("UICorner")
StatusCorner.Parent = StatusFrame
StatusCorner.CornerRadius = UDim.new(0, 10)

local StatusIcon = Instance.new("TextLabel")
StatusIcon.Parent = StatusFrame
StatusIcon.Size = UDim2.new(0, 30, 1, 0)
StatusIcon.Position = UDim2.new(0, 5, 0, 0)
StatusIcon.BackgroundTransparency = 1
StatusIcon.Text = "🔒"
StatusIcon.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusIcon.Font = Enum.Font.GothamBold
StatusIcon.TextSize = 18

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusFrame
StatusLabel.Size = UDim2.new(1, -40, 1, 0)
StatusLabel.Position = UDim2.new(0, 35, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔑 Masukkan key untuk melanjutkan"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextWrapped = true

-- Loading Animation
local LoadingCircle = Instance.new("Frame")
LoadingCircle.Parent = KeyFrame
LoadingCircle.Size = UDim2.new(0, 30, 0, 30)
LoadingCircle.Position = UDim2.new(0.5, -15, 0.95, -15)
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
                if LoadingCircle then LoadingCircle.Rotation = rotation end
                task.wait(0.01)
            end
        end)
    end
end

-- Tombol Website
WebsiteBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(WEBSITE_URL)
            StatusLabel.Text = "✅ Link disalin! Buka browser untuk ambil key"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            StatusIcon.Text = "✅"
            task.wait(2)
            StatusLabel.Text = "🔑 Masukkan key untuk melanjutkan"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            StatusIcon.Text = "🔒"
        end
    end)
end)

-- ================== TOMBOL VERIFIKASI ==================
VerifyBtn.MouseButton1Click:Connect(function()
    local inputKey = KeyTextBox.Text:gsub("%s+", "")
    
    if inputKey == "" then
        StatusLabel.Text = "❌ Masukkan key terlebih dahulu!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        StatusIcon.Text = "❌"
        -- Efek getar
        TweenService:Create(KeyFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -195, 0.5, -225)}):Play()
        task.wait(0.05)
        TweenService:Create(KeyFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -200, 0.5, -225)}):Play()
        task.wait(1)
        StatusLabel.Text = "🔑 Masukkan key untuk melanjutkan"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusIcon.Text = "🔒"
        return
    end
    
    -- Loading
    showLoading(true)
    VerifyBtn.Text = "⏳ VERIFIKASI..."
    VerifyBtn.BackgroundTransparency = 0.5
    StatusLabel.Text = "⏳ Menghubungi database..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    StatusIcon.Text = "⏳"
    
    -- Cek key
    local isValid, message, keyType, expiryTime = checkKey(inputKey)
    
    showLoading(false)
    VerifyBtn.Text = "VERIFIKASI KEY"
    VerifyBtn.BackgroundTransparency = 0.2
    
    if isValid then
        -- KEY VALID
        keyValid = true
        keyExpiryTime = expiryTime
        
        StatusLabel.Text = message
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        StatusIcon.Text = "✅"
        
        -- Animasi sukses
        TweenService:Create(KeyFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
        task.wait(0.2)
        TweenService:Create(KeyFrame, TweenInfo.new(0.2), {BackgroundColor3 = darkPurple}):Play()
        
        showNotification("✅ AKTIVASI BERHASIL!", message, 2, Color3.fromRGB(0, 150, 0))
        
        -- Countdown loading
        for i = 3, 1, -1 do
            StatusLabel.Text = "📦 Loading " .. i .. "..."
            task.wait(1)
        end
        
        -- Load main menu
        local success, err = pcall(loadMainMenu)
        if not success then
            StatusLabel.Text = "❌ Gagal load menu: " .. tostring(err)
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            StatusIcon.Text = "❌"
        end
        
    else
        -- KEY INVALID
        StatusLabel.Text = "❌ " .. message
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        StatusIcon.Text = "❌"
        
        -- Animasi gagal
        for i = 1, 3 do
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(100, 0, 0)}):Play()
            task.wait(0.05)
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = darkPurple}):Play()
            task.wait(0.05)
        end
        
        showNotification("❌ GAGAL!", message, 2, Color3.fromRGB(150, 0, 0))
        
        -- Reset status setelah 3 detik
        task.wait(3)
        StatusLabel.Text = "🔑 Masukkan key untuk melanjutkan"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusIcon.Text = "🔒"
        KeyTextBox.Text = ""
    end
end)

-- Enter key otomatis verifikasi
KeyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyBtn.MouseButton1Click:Fire()
    end
end)

print("🔐 DRIP CLIENT - SISTEM KEY READY!")
print("📡 Database: putzz-key-default-rtdb")
print("🌐 Website: https://putzzdevxit.github.io/KEY-GENERATOR-/")

-- ================== LOAD MAIN MENU (LANJUTKAN NANTI) ==================
local function loadMainMenu()
    -- Hapus GUI key
    KeyGui:Destroy()
    
    print("✅ DRIP CLIENT - Memuat menu utama...")
    
    -- Di sini nanti kamu bisa tambahkan semua fitur ESP, FLY, dll
    -- Tampilkan notifikasi sukses
    local notifGui = Instance.new("ScreenGui")
    notifGui.Parent = game.CoreGui
    notifGui.Name = "DripNotif"
    
    local successFrame = Instance.new("Frame")
    successFrame.Parent = notifGui
    successFrame.Size = UDim2.new(0, 350, 0, 80)
    successFrame.Position = UDim2.new(0.5, -175, 0.5, -40)
    successFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    successFrame.BackgroundTransparency = 0.2
    successFrame.BorderSizePixel = 0
    
    local successCorner = Instance.new("UICorner")
    successCorner.Parent = successFrame
    successCorner.CornerRadius = UDim.new(0, 15)
    
    local successText = Instance.new("TextLabel")
    successText.Parent = successFrame
    successText.Size = UDim2.new(1, 0, 1, 0)
    successText.BackgroundTransparency = 1
    successText.Text = "✅ DRIP CLIENT ACTIVATED!\nTekan tombol di pojok kiri untuk membuka menu"
    successText.TextColor3 = Color3.fromRGB(255, 255, 255)
    successText.Font = Enum.Font.GothamBold
    successText.TextSize = 14
    successText.TextWrapped = true
    
    TweenService:Create(successFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    task.wait(3)
    TweenService:Create(successFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    notifGui:Destroy()
    
    -- Tombol buka menu sederhana
    local openBtn = Instance.new("TextButton")
    openBtn.Parent = game.CoreGui
    openBtn.Size = UDim2.new(0, 120, 0, 45)
    openBtn.Position = UDim2.new(0, 15, 0.5, -22.5)
    openBtn.BackgroundColor3 = themeColor
    openBtn.BackgroundTransparency = 0.2
    openBtn.Text = "DRIP CLIENT"
    openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    openBtn.Font = Enum.Font.GothamBlack
    openBtn.TextSize = 13
    openBtn.ZIndex = 10
    openBtn.Draggable = true
    
    local openBtnCorner = Instance.new("UICorner")
    openBtnCorner.Parent = openBtn
    openBtnCorner.CornerRadius = UDim.new(0, 14)
    
    openBtn.MouseButton1Click:Connect(function()
        showNotification("DRIP CLIENT", "Fitur sedang dalam pengembangan!", 2, themeColor)
    end)
    
    print("✅ DRIP CLIENT - READY!")
end