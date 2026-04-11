-- ================== DRIP CLIENT - ESP EDITION ==================
-- By Putzzdev
-- Fitur: ESP Line + ESP Box + GUI Kece

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Warna
local cyan = Color3.fromRGB(0, 255, 255)
local dark = Color3.fromRGB(8, 8, 12)
local gray = Color3.fromRGB(25, 25, 35)

-- Database
local DB_URL = "https://key-database-701af-default-rtdb.asia-southeast1.firebasedatabase.app/keys.json"
local WEB_URL = "https://putzzdevxit.github.io/KEY-GENERATOR-/"

-- Jarak maksimal ESP
local MAX_DIST = 150

-- ================== VARIABEL ESP ==================
local espEnabled = true  -- Default ON
local espLines = {}
local espBoxes = {}
local espNames = {}

-- ================== FUNGSI CEK KEY ==================
local function cekKey(key)
    local success, data = pcall(function()
        return game:HttpGet(DB_URL, true)
    end)
    if success and data then
        local success2, json = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success2 and json then
            for _, k in pairs(json) do
                if k.key and string.upper(k.key) == string.upper(key) then
                    return true
                end
            end
        end
    end
    return false
end

-- ================== BUAT ESP ==================
local function createESPforPlayer(player)
    if player == LocalPlayer then return end
    
    -- Line dari atas ke player
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = cyan
    line.Visible = false
    table.insert(espLines, {line, player})
    
    -- Box kotak
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = cyan
    box.Filled = false
    box.Visible = false
    table.insert(espBoxes, {box, player})
    
    -- Nama player
    local name = Drawing.new("Text")
    name.Size = 14
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Center = true
    name.Outline = true
    name.OutlineColor = Color3.fromRGB(0, 0, 0)
    name.Visible = false
    table.insert(espNames, {name, player})
end

-- Hapus semua ESP
local function clearESP()
    for _, v in pairs(espLines) do pcall(function() v[1]:Remove() end) end
    for _, v in pairs(espBoxes) do pcall(function() v[1]:Remove() end) end
    for _, v in pairs(espNames) do pcall(function() v[1]:Remove() end) end
    espLines = {}
    espBoxes = {}
    espNames = {}
end

-- Update ESP (dijalankan setiap frame)
local function updateESP()
    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position
    
    for _, data in pairs(espLines) do
        local line, player = data[1], data[2]
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and myPos then
            local hrp = char.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (myPos - hrp.Position).Magnitude
            if vis and dist <= MAX_DIST and espEnabled then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
    
    for _, data in pairs(espBoxes) do
        local box, player = data[1], data[2]
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and myPos then
            local hrp = char.HumanoidRootPart
            local head = char.Head
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (myPos - hrp.Position).Magnitude
            if vis and dist <= MAX_DIST and espEnabled then
                local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(top.Y - bottom.Y)
                local width = height / 2
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(pos.X - width/2, top.Y)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
    
    for _, data in pairs(espNames) do
        local name, player = data[1], data[2]
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and myPos then
            local hrp = char.HumanoidRootPart
            local head = char.Head
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (myPos - hrp.Position).Magnitude
            if vis and dist <= MAX_DIST and espEnabled then
                local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                name.Position = Vector2.new(pos.X, top.Y - 16)
                name.Text = player.Name .. " [" .. math.floor(dist) .. "m]"
                name.Visible = true
            else
                name.Visible = false
            end
        else
            name.Visible = false
        end
    end
end

-- Inisialisasi ESP untuk semua player
local function initESP()
    clearESP()
    for _, p in pairs(Players:GetPlayers()) do
        createESPforPlayer(p)
    end
end

-- Player masuk/keluar
Players.PlayerAdded:Connect(function(p)
    task.wait(0.5)
    createESPforPlayer(p)
end)
Players.PlayerRemoving:Connect(function(p)
    -- Biar cleanup otomatis nanti
end)

-- Render ESP setiap frame
RunService.RenderStepped:Connect(updateESP)

-- ================== GUI KEY ==================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "DripKeySystem"
KeyGui.Parent = game.CoreGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyGui
KeyFrame.Size = UDim2.new(0, 380, 0, 400)
KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -200)
KeyFrame.BackgroundColor3 = dark
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
KeyBorder.BorderColor3 = cyan
local KeyBorderCorner = Instance.new("UICorner")
KeyBorderCorner.Parent = KeyBorder
KeyBorderCorner.CornerRadius = UDim.new(0, 20)

-- Header
local KeyIcon = Instance.new("TextLabel")
KeyIcon.Parent = KeyFrame
KeyIcon.Size = UDim2.new(1, 0, 0, 70)
KeyIcon.Position = UDim2.new(0, 0, 0, 15)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Text = "🔐"
KeyIcon.TextColor3 = cyan
KeyIcon.Font = Enum.Font.GothamBlack
KeyIcon.TextSize = 45

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Position = UDim2.new(0, 0, 0, 75)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "DRIP CLIENT"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 20

-- Info
local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = KeyFrame
InfoFrame.Size = UDim2.new(0.9, 0, 0, 80)
InfoFrame.Position = UDim2.new(0.05, 0, 0.26, 0)
InfoFrame.BackgroundColor3 = gray
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
InfoText.Text = "Masukkan Key Anda\n\nTIPE KEY: 1 JAM | 1 HARI | PERMANEN"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 11
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextWrapped = true

-- Input Key
local KeyLabel = Instance.new("TextLabel")
KeyLabel.Parent = KeyFrame
KeyLabel.Size = UDim2.new(0.8, 0, 0, 20)
KeyLabel.Position = UDim2.new(0.1, 0, 0.52, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "MASUKAN KEY ANDA"
KeyLabel.TextColor3 = cyan
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextSize = 12

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.Position = UDim2.new(0.1, 0, 0.57, 0)
KeyTextBox.BackgroundColor3 = gray
KeyTextBox.BackgroundTransparency = 0.1
KeyTextBox.TextColor3 = Color3.new(1, 1, 1)
KeyTextBox.PlaceholderText = "Contoh: PutzzVIP"
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
VerifyBtn.Position = UDim2.new(0.1, 0, 0.72, 0)
VerifyBtn.BackgroundColor3 = cyan
VerifyBtn.BackgroundTransparency = 0.2
VerifyBtn.Text = "VERIFIKASI KEY"
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 16

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.Parent = VerifyBtn
VerifyCorner.CornerRadius = UDim.new(0, 10)

-- Tombol GET KEY
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Parent = KeyFrame
GetKeyBtn.Size = UDim2.new(0.5, 0, 0, 35)
GetKeyBtn.Position = UDim2.new(0.25, 0, 0.86, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
GetKeyBtn.BackgroundTransparency = 0.2
GetKeyBtn.Text = "🌐 GET KEY"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.Parent = GetKeyBtn
GetKeyCorner.CornerRadius = UDim.new(0, 8)

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = KeyFrame
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.93, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔑 Masukkan key"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

-- Loading
local LoadingCircle = Instance.new("Frame")
LoadingCircle.Parent = KeyFrame
LoadingCircle.Size = UDim2.new(0, 25, 0, 25)
LoadingCircle.Position = UDim2.new(0.5, -12, 0.96, -12)
LoadingCircle.BackgroundColor3 = cyan
LoadingCircle.BackgroundTransparency = 1
LoadingCircle.Visible = false

local CircleCorner = Instance.new("UICorner")
CircleCorner.Parent = LoadingCircle
CircleCorner.CornerRadius = UDim.new(1, 0)

local function showLoading(show)
    LoadingCircle.Visible = show
    if show then
        task.spawn(function()
            local r = 0
            while LoadingCircle and LoadingCircle.Visible do
                r = (r + 5) % 360
                LoadingCircle.Rotation = r
                task.wait(0.01)
            end
        end)
    end
end

-- GET KEY button
GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(WEB_URL)
            StatusLabel.Text = "✅ Link disalin!"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(2)
            StatusLabel.Text = "🔑 Masukkan key"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end)

-- ================== VERIFIKASI ==================
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyTextBox.Text:gsub("%s+", "")
    if key == "" then
        StatusLabel.Text = "❌ Masukkan key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    showLoading(true)
    StatusLabel.Text = "⏳ Verifikasi..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    VerifyBtn.Text = "⏳ VERIFIKASI..."
    
    local valid = cekKey(key)
    
    showLoading(false)
    VerifyBtn.Text = "VERIFIKASI KEY"
    
    if valid then
        StatusLabel.Text = "✅ KEY VALID!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        TweenService:Create(KeyFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
        task.wait(0.3)
        
        for i = 3, 1, -1 do
            StatusLabel.Text = "Loading " .. i .. "..."
            task.wait(1)
        end
        
        KeyGui:Destroy()
        initESP()
        
        -- Notifikasi sukses
        local notif = Instance.new("ScreenGui")
        notif.Parent = game.CoreGui
        local nf = Instance.new("Frame")
        nf.Parent = notif
        nf.Size = UDim2.new(0, 300, 0, 50)
        nf.Position = UDim2.new(0.5, -150, 0.5, -25)
        nf.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        nf.BackgroundTransparency = 0.1
        local nc = Instance.new("UICorner")
        nc.Parent = nf
        nc.CornerRadius = UDim.new(0, 12)
        local nt = Instance.new("TextLabel")
        nt.Parent = nf
        nt.Size = UDim2.new(1, 0, 1, 0)
        nt.BackgroundTransparency = 1
        nt.Text = "✅ DRIP CLIENT ACTIVATED!"
        nt.TextColor3 = Color3.fromRGB(255, 255, 255)
        nt.Font = Enum.Font.GothamBold
        nt.TextSize = 16
        task.wait(2)
        notif:Destroy()
        
        -- ================== MENU UTAMA KECE ==================
        local MenuGui = Instance.new("ScreenGui")
        MenuGui.Name = "DripClient"
        MenuGui.Parent = game.CoreGui
        
        -- Main Frame
        local MainFrame = Instance.new("Frame")
        MainFrame.Parent = MenuGui
        MainFrame.Size = UDim2.new(0, 320, 0, 420)
        MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
        MainFrame.BackgroundColor3 = dark
        MainFrame.BackgroundTransparency = 0.05
        MainFrame.BorderSizePixel = 0
        MainFrame.Active = true
        MainFrame.Draggable = true
        MainFrame.Visible = true
        
        local MainCorner = Instance.new("UICorner")
        MainCorner.Parent = MainFrame
        MainCorner.CornerRadius = UDim.new(0, 20)
        
        -- Border Glow
        local Border = Instance.new("Frame")
        Border.Parent = MainFrame
        Border.Size = UDim2.new(1, 0, 1, 0)
        Border.BackgroundTransparency = 1
        Border.BorderSizePixel = 2
        Border.BorderColor3 = cyan
        local BorderCorner = Instance.new("UICorner")
        BorderCorner.Parent = Border
        BorderCorner.CornerRadius = UDim.new(0, 20)
        
        -- Header
        local Header = Instance.new("Frame")
        Header.Parent = MainFrame
        Header.Size = UDim2.new(1, 0, 0, 60)
        Header.BackgroundColor3 = cyan
        Header.BackgroundTransparency = 0.15
        Header.BorderSizePixel = 0
        local HeaderCorner = Instance.new("UICorner")
        HeaderCorner.Parent = Header
        HeaderCorner.CornerRadius = UDim.new(0, 20)
        
        local Title = Instance.new("TextLabel")
        Title.Parent = Header
        Title.Size = UDim2.new(1, 0, 1, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "DRIP CLIENT"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBlack
        Title.TextSize = 22
        
        local Subtitle = Instance.new("TextLabel")
        Subtitle.Parent = Header
        Subtitle.Size = UDim2.new(1, 0, 0, 20)
        Subtitle.Position = UDim2.new(0, 0, 0, 40)
        Subtitle.BackgroundTransparency = 1
        Subtitle.Text = "ESP EDITION"
        Subtitle.TextColor3 = cyan
        Subtitle.Font = Enum.Font.Gotham
        Subtitle.TextSize = 11
        
        -- Content Scrolling
        local Content = Instance.new("ScrollingFrame")
        Content.Parent = MainFrame
        Content.Size = UDim2.new(0.94, 0, 0.76, 0)
        Content.Position = UDim2.new(0.03, 0, 0.16, 0)
        Content.BackgroundColor3 = gray
        Content.BackgroundTransparency = 0.4
        Content.BorderSizePixel = 0
        Content.ScrollBarThickness = 5
        Content.ScrollBarImageColor3 = cyan
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local ContentCorner = Instance.new("UICorner")
        ContentCorner.Parent = Content
        ContentCorner.CornerRadius = UDim.new(0, 12)
        
        local Layout = Instance.new("UIListLayout")
        Layout.Parent = Content
        Layout.Padding = UDim.new(0, 10)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- ================== FUNGSI TOGGLE ==================
        local function addToggle(text, desc, callback)
            local frame = Instance.new("Frame")
            frame.Parent = Content
            frame.Size = UDim2.new(0.95, 0, 0, 65)
            frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            local fc = Instance.new("UICorner")
            fc.Parent = frame
            fc.CornerRadius = UDim.new(0, 10)
            
            -- Judul
            local lbl = Instance.new("TextLabel")
            lbl.Parent = frame
            lbl.Size = UDim2.new(0.7, 0, 0.5, 0)
            lbl.Position = UDim2.new(0.05, 0, 0, 5)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Deskripsi
            local descLbl = Instance.new("TextLabel")
            descLbl.Parent = frame
            descLbl.Size = UDim2.new(0.7, 0, 0.4, 0)
            descLbl.Position = UDim2.new(0.05, 0, 0.5, 0)
            descLbl.BackgroundTransparency = 1
            descLbl.Text = desc
            descLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextSize = 10
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Switch
            local sw = Instance.new("Frame")
            sw.Parent = frame
            sw.Size = UDim2.new(0, 50, 0, 26)
            sw.Position = UDim2.new(0.82, 0, 0.5, -13)
            sw.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            sw.BorderSizePixel = 0
            local swc = Instance.new("UICorner")
            swc.Parent = sw
            swc.CornerRadius = UDim.new(0, 13)
            
            local circle = Instance.new("Frame")
            circle.Parent = sw
            circle.Size = UDim2.new(0, 22, 0, 22)
            circle.Position = UDim2.new(0.05, 0, 0.5, -11)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle.BorderSizePixel = 0
            local circ = Instance.new("UICorner")
            circ.Parent = circle
            circ.CornerRadius = UDim.new(1, 0)
            
            local state = false
            local btn = Instance.new("TextButton")
            btn.Parent = frame
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = state and cyan or Color3.fromRGB(80, 80, 90)}):Play()
                TweenService:Create(circle, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0.05, 0, 0.5, -11)}):Play()
                callback(state)
            end)
        end
        
        -- ================== TAMBAH FITUR ==================
        -- ESP Toggle (ON by default)
        local espState = true
        local espToggleFrame = Instance.new("Frame")
        espToggleFrame.Parent = Content
        espToggleFrame.Size = UDim2.new(0.95, 0, 0, 65)
        espToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        espToggleFrame.BackgroundTransparency = 0.2
        espToggleFrame.BorderSizePixel = 0
        local espFc = Instance.new("UICorner")
        espFc.Parent = espToggleFrame
        espFc.CornerRadius = UDim.new(0, 10)
        
        local espLbl = Instance.new("TextLabel")
        espLbl.Parent = espToggleFrame
        espLbl.Size = UDim2.new(0.7, 0, 0.5, 0)
        espLbl.Position = UDim2.new(0.05, 0, 0, 5)
        espLbl.BackgroundTransparency = 1
        espLbl.Text = "📡 ESP SYSTEM"
        espLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        espLbl.Font = Enum.Font.GothamBold
        espLbl.TextSize = 14
        espLbl.TextXAlignment = Enum.TextXAlignment.Left
        
        local espDesc = Instance.new("TextLabel")
        espDesc.Parent = espToggleFrame
        espDesc.Size = UDim2.new(0.7, 0, 0.4, 0)
        espDesc.Position = UDim2.new(0.05, 0, 0.5, 0)
        espDesc.BackgroundTransparency = 1
        espDesc.Text = "Line + Box + Name"
        espDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
        espDesc.Font = Enum.Font.Gotham
        espDesc.TextSize = 10
        espDesc.TextXAlignment = Enum.TextXAlignment.Left
        
        local espSw = Instance.new("Frame")
        espSw.Parent = espToggleFrame
        espSw.Size = UDim2.new(0, 50, 0, 26)
        espSw.Position = UDim2.new(0.82, 0, 0.5, -13)
        espSw.BackgroundColor3 = cyan
        espSw.BorderSizePixel = 0
        local espSwc = Instance.new("UICorner")
        espSwc.Parent = espSw
        espSwc.CornerRadius = UDim.new(0, 13)
        
        local espCircle = Instance.new("Frame")
        espCircle.Parent = espSw
        espCircle.Size = UDim2.new(0, 22, 0, 22)
        espCircle.Position = UDim2.new(1, -24, 0.5, -11)
        espCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        espCircle.BorderSizePixel = 0
        local espCirc = Instance.new("UICorner")
        espCirc.Parent = espCircle
        espCirc.CornerRadius = UDim.new(1, 0)
        
        local espBtn = Instance.new("TextButton")
        espBtn.Parent = espToggleFrame
        espBtn.Size = UDim2.new(1, 0, 1, 0)
        espBtn.BackgroundTransparency = 1
        espBtn.Text = ""
        espBtn.MouseButton1Click:Connect(function()
            espState = not espState
            espEnabled = espState
            if espState then
                TweenService:Create(espSw, TweenInfo.new(0.15), {BackgroundColor3 = cyan}):Play()
                TweenService:Create(espCircle, TweenInfo.new(0.15), {Position = UDim2.new(1, -24, 0.5, -11)}):Play()
            else
                TweenService:Create(espSw, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
                TweenService:Create(espCircle, TweenInfo.new(0.15), {Position = UDim2.new(0.05, 0, 0.5, -11)}):Play()
                -- Sembunyikan semua ESP
                for _, v in pairs(espLines) do v[1].Visible = false end
                for _, v in pairs(espBoxes) do v[1].Visible = false end
                for _, v in pairs(espNames) do v[1].Visible = false end
            end
        end)
        
        -- Info Panel
        local infoFrame = Instance.new("Frame")
        infoFrame.Parent = Content
        infoFrame.Size = UDim2.new(0.95, 0, 0, 100)
        infoFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        infoFrame.BackgroundTransparency = 0.2
        infoFrame.BorderSizePixel = 0
        local infoCorner = Instance.new("UICorner")
        infoCorner.Parent = infoFrame
        infoCorner.CornerRadius = UDim.new(0, 10)
        
        local infoText = Instance.new("TextLabel")
        infoText.Parent = infoFrame
        infoText.Size = UDim2.new(1, 0, 1, 0)
        infoText.BackgroundTransparency = 1
        infoText.Text = "DRIP CLIENT V7.5\n\n👨‍💻 DEVELOPER: Putzzdev\n📱 TIKTOK: @Putzz_mvpp\n📞 WA: 088976255131"
        infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 11
        infoText.TextWrapped = true
        infoText.TextYAlignment = Enum.TextYAlignment.Center
        
        -- Tombol toggle menu (di pojok kiri)
        local menuBtn = Instance.new("TextButton")
        menuBtn.Parent = MenuGui
        menuBtn.Size = UDim2.new(0, 90, 0, 40)
        menuBtn.Position = UDim2.new(0, 10, 0.5, -20)
        menuBtn.BackgroundColor3 = cyan
        menuBtn.BackgroundTransparency = 0.2
        menuBtn.Text = "🔓 DRIP"
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
            MainFrame.Visible = menuVisible
            if menuVisible then
                TweenService:Create(MainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -160, 0.5, -210)}):Play()
            else
                TweenService:Create(MainFrame, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -160, 1, 0)}):Play()
            end
        end)
        
        print("✅ DRIP CLIENT - ESP READY! Klik DRIP di pojok kiri")
        
    else
        StatusLabel.Text = "❌ KEY INVALID!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        for i = 1, 3 do
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(100, 0, 0)}):Play()
            task.wait(0.05)
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {BackgroundColor3 = dark}):Play()
            task.wait(0.05)
        end
        task.wait(1.5)
        StatusLabel.Text = "🔑 Masukkan key"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        KeyTextBox.Text = ""
    end
end)

print("🔐 DRIP CLIENT - Masukkan key: PutzzVIP")